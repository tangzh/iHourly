//
//  ReportFilterViewController.swift
//  iHourly
//
//  Created by tang on 3/13/15.
//  Copyright (c) 2015 Stanford Univeristy. All rights reserved.
//

import UIKit


class ReportFilterViewController: UIViewController {
    var dateFormatter = NSDateFormatter()
    
    var filter: Filter?

    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var startDate: UIDatePicker!
    
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var endDate: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initDateFormatter()
        startDateLabel.text = dateFormatter.stringFromDate(filter?.startDateFilter ?? NSDate() )
        endDateLabel.text = dateFormatter.stringFromDate(filter?.endDateFilter ?? NSDate())
        startDate.addTarget(self, action: Selector("startDateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        endDate.addTarget(self, action: "endDateChanged:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    func initDateFormatter() {
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
    }
    
    func startDateChanged(datePicker:UIDatePicker) {
        var strDate = dateFormatter.stringFromDate(datePicker.date)
        startDateLabel.text = strDate
    }
    
    func endDateChanged(datePicker:UIDatePicker) {
        var strDate = dateFormatter.stringFromDate(datePicker.date)
        endDateLabel.text = strDate
    }
    
    @IBAction func doneFilter(sender: AnyObject) {
        if (endDate.date).timeIntervalSinceDate(startDate.date) <= 0 {
            showAlert()
        }else {
            filter?.startDateFilter = startDate.date
            filter?.endDateFilter = endDate.date
            
            presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
    func showAlert() {
        var alert = UIAlertController(title: "Invalid Filter",
            message: "You can not have a start date that is later than end date.",
            preferredStyle: UIAlertControllerStyle.Alert
        )
        
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default)
            { (action: UIAlertAction!) -> Void in
            }
        )
        
        presentViewController(alert, animated: true, completion: nil)
    }
}
