//
//  DetailTextTableViewCell.swift
//  iHourly
//
//  Created by tang on 3/13/15.
//  Copyright (c) 2015 Stanford Univeristy. All rights reserved.
//

import UIKit

class DetailTextTableViewCell: UITableViewCell {
    var value: String? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var detailLabel: UILabel!
    
    
    private func updateUI() {
        detailLabel?.text = value
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
