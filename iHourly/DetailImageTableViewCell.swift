//
//  DetailImageTableViewCell.swift
//  iHourly
//
//  Created by tang on 3/13/15.
//  Copyright (c) 2015 Stanford Univeristy. All rights reserved.
//

import UIKit

class DetailImageTableViewCell: UITableViewCell {
    var detailImageData: UIImage? {
        didSet {
            updateUI()
        }
    }
    var imageUrl: String? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var detailImage: UIImageView!
    
    func updateUI() {
        if detailImageData != nil {
           detailImage?.image = detailImageData
        }
        
        if let urlString = imageUrl {
            let fileManager = NSFileManager()
            if let docsDir = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first as? NSURL{
                let url = docsDir.URLByAppendingPathComponent(urlString)
                let qos = Int(QOS_CLASS_USER_INITIATED.value)
                dispatch_async(dispatch_get_global_queue(qos, 0)) { [weak self] in
                    if let imageData = NSData(contentsOfURL: url) {
                        if let image = UIImage(data: imageData) {
                            dispatch_async(dispatch_get_main_queue()) {
                                self!.detailImage.image = image
                            }
                        }
                    }
                }
            }
        }
    }


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
