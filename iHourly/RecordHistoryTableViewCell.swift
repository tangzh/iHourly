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
    var record: Record? {
        didSet {
            updateUI()
        }
    }
    

    @IBOutlet weak var projectNameLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var timeLengthLabel: UILabel!
    
    func updateUI() {
        if let record = self.record {
            projectNameLabel.text = record.projectName
            startDateLabel.text = record.getLocalDate(record.starttime)
            endDateLabel.text = record.getLocalDate(record.stoptime)
            timeLengthLabel.text = record.getFormatTimeLength()
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
