//
//  RecordDetailViewController.swift
//  iHourly
//
//  Created by tang on 3/9/15.
//  Copyright (c) 2015 Stanford Univeristy. All rights reserved.
//

import UIKit

class RecordDetailViewController: UIViewController {
    
    var record: Record? {
        didSet {
            updateUI()
        }
    }
    
    
    @IBOutlet weak var projectName: UILabel!
    @IBOutlet weak var starttimeLabel: UILabel!
    @IBOutlet weak var stoptimeLabel: UILabel!
    @IBOutlet weak var notesField: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    func updateUI() {
        if let record = self.record {
//            println("\(record)")
            projectName?.text = record.projectName
            starttimeLabel?.text = record.getLocalDate(record.starttime)
            stoptimeLabel?.text = record.getLocalDate(record.stoptime)
            notesField?.text = record.note
            
            if let urlString = record.photoUrl {
                let url = NSURL(string: urlString)
                let qos = Int(QOS_CLASS_USER_INITIATED.value)
                dispatch_async(dispatch_get_global_queue(qos, 0)) { [weak self] in
                    if let imageData = NSData(contentsOfURL: url!) {
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

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        imageView.addGestureRecognizer( UITapGestureRecognizer(target: self, action: "changePhoto:") )
    }
    
    func changePhoto() {
        
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

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
