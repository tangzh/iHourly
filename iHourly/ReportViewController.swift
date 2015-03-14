//
//  ReportViewController.swift
//  iHourly
//
//  Created by tang on 3/10/15.
//  Copyright (c) 2015 Stanford Univeristy. All rights reserved.
//

import UIKit
import CoreData

class ReportViewController: UIViewController {
//    var startDateFilter: NSDate?
//    var endDateFilter: NSDate?
    struct filterKey {
        static let start = "startDateFilter"
        static let end = "endDateFilter"
    }
    
//    struct filters {
//        let startDateFilter: NSDate
//        let endDateFilter: NSDate
//    }
    var filter = Filter()
    
    @IBOutlet weak var reportView: ReportView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        println("will appear")
        var appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let context: NSManagedObjectContext = appDel.managedObjectContext {
            var request = NSFetchRequest(entityName: "Records")
            request.returnsObjectsAsFaults = false
            if let results = context.executeFetchRequest(request, error: nil) as? Array<NSManagedObject>{
                if results.count >= 0{
                    reportView.records = results
                    if let startDateFilter = filter.startDateFilter{
                        reportView.records = reportView.records.filter {
                            if let startDate = $0.valueForKey("starttime") as? NSDate {
                                return startDate.timeIntervalSinceDate(startDateFilter) > 0
                            }else {
                                return true
                            }
                        }
                    }
                    if let endDateFilter = filter.endDateFilter {
                        reportView.records = reportView.records.filter {
                            if let endDate = $0.valueForKey("stoptime") as? NSDate {
                                return endDate.timeIntervalSinceDate(endDateFilter) < 0
                            }else {
                                return true
                            }
                        }
                    }

                    
                }
            }
        }
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "filter" {
            if let rfvc = segue.destinationViewController.contentViewController as? ReportFilterViewController{
                rfvc.filter = filter
            }
        }

    }
    

}
