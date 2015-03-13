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
                }
            }
        }
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
