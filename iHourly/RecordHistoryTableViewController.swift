//
//  RecordHistoryTableViewController.swift
//  iHourly
//
//  Created by tang on 3/5/15.
//  Copyright (c) 2015 Stanford Univeristy. All rights reserved.
//

import UIKit
import CoreData

class RecordHistoryTableViewController: UITableViewController {
    var records = [NSManagedObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        var appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let context: NSManagedObjectContext = appDel.managedObjectContext {
            var request = NSFetchRequest(entityName: "Records")
            request.returnsObjectsAsFaults = false
            if let results = context.executeFetchRequest(request, error: nil) {
                records = results as Array<NSManagedObject>
            }
        }
    }
    
    // to format the date to current timezone
    func getLocalDate(inputDate: NSDate?) -> String {
        if inputDate == nil {
            return " "
        }else {
            let dateFormatter = NSDateFormatter()
            dateFormatter.timeStyle = NSDateFormatterStyle.MediumStyle //Set time style
            dateFormatter.dateStyle = NSDateFormatterStyle.MediumStyle //Set date style
            dateFormatter.timeZone = NSTimeZone()
            let localDate = dateFormatter.stringFromDate(inputDate!)
            return localDate
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Record", forIndexPath: indexPath) as RecordHistoryTableViewCell
        let record = records[indexPath.row]

//        println("\(record)")
        var showRecord = Record(data: record)
        
        cell.record = showRecord
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        if let rdvc = segue.destinationViewController as? RecordDetailViewController {
            if let id = segue.identifier {
                switch(id) {
                case "showRecordDetail":
                    rdvc.title = "Detail"
                    if let selectedPath = tableView.indexPathForSelectedRow() {
                        rdvc.record = Record(data: records[selectedPath.row])
                    }
                default: println("entered deafult")
                }
            }
        }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            let recordToDelete = records[indexPath.row]
            var appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            if let context: NSManagedObjectContext = appDel.managedObjectContext {
                context.deleteObject(recordToDelete)
            }
            records.removeAtIndex(indexPath.row)
            
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
