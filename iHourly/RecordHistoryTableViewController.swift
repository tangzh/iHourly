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
    
    var records = [[NSManagedObject]]()
    var sections = [String]()
    
    // MARK: - Sort Criterion
    @IBOutlet weak var sortCriterion: UISegmentedControl!
    @IBAction func changeCriterion(sender: UISegmentedControl) {
        sections.removeAll()
        records.removeAll()
        refresh()
        tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func refresh() {
        
        var appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let context: NSManagedObjectContext = appDel.managedObjectContext {
            var request = NSFetchRequest(entityName: "Records")
            request.returnsObjectsAsFaults = false
            if let results = context.executeFetchRequest(request, error: nil) as? Array<NSManagedObject>{
                if results.count > 0{
                    switch(self.sortCriterion.selectedSegmentIndex) {
                    case 0:
                        records.append(results.reverse())
                        sections.append("time")
                    case 1:
                        for record in results {
                            if let projectName = record.valueForKey("project") as? String {
                                if(!contains(sections, projectName)) {
                                    sections.append(projectName)
                                    records.append([NSManagedObject]())
                                }
                                if let index = find(sections, projectName) {
                                    records[index].append(record)
                                }
                            }
                        }
                    case 2:
                        records.append(results.sorted({ $0.valueForKey("timeLength") as? Int > $1.valueForKey("timeLength") as? Int }))
                        sections.append("Longest")
                    default: break
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        sections.removeAll()
        records.removeAll()
        refresh()
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return records[section].count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection: Int) -> String {
        return sections[titleForHeaderInSection]
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Record", forIndexPath: indexPath) as RecordHistoryTableViewCell
        let record = records[indexPath.section][indexPath.row]
        var showRecord = Record(data: record)
        
        cell.record = showRecord
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

//        if let rdvc = segue.destinationViewController as? RecordDetailViewController {
//            if let id = segue.identifier {
//                switch(id) {
//                case "showRecordDetail":
//                    rdvc.title = "Detail"
//                    if let selectedPath = tableView.indexPathForSelectedRow() {
//                        rdvc.record = Record(data: records[selectedPath.section][selectedPath.row])
//                    }
//                default: println("entered deafult")
//                }
//            }
//        }
        
        if let rdtvc = segue.destinationViewController as? RecordDetailTableViewController {
            if let id = segue.identifier {
                switch(id) {
                case "showDetail":
                   rdtvc.title = "Table report"
                   if let selectedPath = tableView.indexPathForSelectedRow() {
                        rdtvc.record = Record(data: records[selectedPath.section][selectedPath.row])
                    }
                default:
                    println("enter default")
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
            let recordToDelete = records[indexPath.section][indexPath.row]
            var appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
            if let context: NSManagedObjectContext = appDel.managedObjectContext {
                context.deleteObject(recordToDelete)
            }
            records[indexPath.section].removeAtIndex(indexPath.row)
            
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
