//
//  AddPhotoViewController.swift
//  iHourly
//
//  Created by tang on 3/9/15.
//  Copyright (c) 2015 Stanford Univeristy. All rights reserved.
//

import UIKit
import MobileCoreServices

class AddPhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate
 {
    var record: Record?{
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        if let urlString = record?.photoUrl {
            let fileManager = NSFileManager()
            if let docsDir = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first as? NSURL{
                let url = docsDir.URLByAppendingPathComponent(urlString)
                let qos = Int(QOS_CLASS_USER_INITIATED.value)
                dispatch_async(dispatch_get_global_queue(qos, 0)) { [weak self] in
                    if let imageData = NSData(contentsOfURL: url) {
                        if urlString == self?.record?.photoUrl {
                            if let image = UIImage(data: imageData) {
                                dispatch_async(dispatch_get_main_queue()) {
                                    self?.imageView.image = image
                                    self?.makeRoomForImage()
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Take photo
    @IBAction func takePhoto(sender: AnyObject) {
        if UIImagePickerController.isSourceTypeAvailable(.Camera) {
            let picker =  UIImagePickerController()
            picker.sourceType = .Camera
            picker.mediaTypes = [kUTTypeImage]
            picker.delegate = self
            picker.allowsEditing = true
            presentViewController(picker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var image = info[UIImagePickerControllerEditedImage] as? UIImage
        if image == nil {
            image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        imageView.image = image
        makeRoomForImage()
        saveImageInRecord()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func saveImageInRecord()
    {
        if let image = imageView.image {
            if let imageData = UIImageJPEGRepresentation(image, 1.0) {
                let fileManager = NSFileManager()
                if let docsDir = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first as? NSURL {
                    let unique = NSDate.timeIntervalSinceReferenceDate()
                    let url = docsDir.URLByAppendingPathComponent("\(unique).jpg")
                    if let path = url.absoluteString {
                        if imageData.writeToURL(url, atomically: true) {
                            record?.photoUrl = "\(unique).jpg"
                        }
                    }
                }
            }
            
        }
    }

    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func makeRoomForImage() {
        var extraHeight: CGFloat = 0
        if imageView.image?.aspectRatio > 0 {
            if let width = imageView.superview?.frame.size.width {
                let height = width / imageView.image!.aspectRatio
                extraHeight = height - imageView.frame.height
                imageView.frame = CGRect(x: 0, y: 0, width: width, height: height)
            }
        } else {
            extraHeight = -imageView.frame.height
            imageView.frame = CGRectZero
        }
        preferredContentSize = CGSize(width: preferredContentSize.width, height: preferredContentSize.height + extraHeight)
    }
    
    
    @IBAction func done(sender: AnyObject) {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIImage {
    var aspectRatio: CGFloat {
        return size.height != 0 ? size.width / size.height : 0
    }
}
