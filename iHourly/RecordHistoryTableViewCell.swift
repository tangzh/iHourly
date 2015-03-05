//
//  RecordHistoryTableViewCell.swift
//  iHourly
//
//  Created by tang on 3/5/15.
//  Copyright (c) 2015 Stanford Univeristy. All rights reserved.
//

import UIKit
import CoreData

class RecordHistoryTableViewCell: UITableViewCell {
    var record: [String: String]? {
        didSet {
            updateUI()
        }
    }
    

    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    
    func updateUI() {
        if let record = self.record {
            projectNameLabel.text = record["project"]
            startDateLabel.text = record["starttime"]
            endDateLabel.text = record["stoptime"]
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
