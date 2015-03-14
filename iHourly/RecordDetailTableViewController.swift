//
//  RecordDetailTableViewController.swift
//  iHourly
//
//  Created by tang on 3/13/15.
//  Copyright (c) 2015 Stanford Univeristy. All rights reserved.
//

import UIKit

class RecordDetailTableViewController: UITableViewController {
    var record: Record? {
        didSet {
            getGroupedRecordDetail()
        }
    }
    
    private struct RecordDetail {
        var title: String
        var values = [AnyObject]()
        var group: String

    }
    
    private var recordDetails = [RecordDetail]()
    
    private func getGroupedRecordDetail() {
        if let currentRecord = record {
            if let projectName = currentRecord.projectName {
                recordDetails.append( RecordDetail(title: "Project", values: [projectName], group: "detail") )
            }
            
            if currentRecord.timeLength != nil{
                recordDetails.append( RecordDetail( title: "Time", values: [currentRecord.starttime!, currentRecord.stoptime!], group: "detail") )
            }
            
            if let note = currentRecord.note {
                recordDetails.append(RecordDetail(title: "Note", values: [note], group: "detail"))
            }
            
            if let imageUrl = currentRecord.photoUrl {
                recordDetails.append(RecordDetail(title: "Photo", values: [imageUrl], group: "detailImage"))
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return recordDetails.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return recordDetails[section].values.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection: Int) -> String {
        return recordDetails[titleForHeaderInSection].title
    }
    
    private struct Storyboard {
        static let ImageCellReuseIdentifier = "detailImage"
        static let TextCellReuseIdentifier = "detail"
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let detail = recordDetails[indexPath.section]
        let dequeued: AnyObject = tableView.dequeueReusableCellWithIdentifier(detail.group, forIndexPath: indexPath)
        
        if detail.group == Storyboard.ImageCellReuseIdentifier {
            let cell = dequeued as DetailImageTableViewCell
            cell.imageUrl = detail.values.first as? String
            return cell
        }else {
            let cell = dequeued as DetailTextTableViewCell
            if let textValue = detail.values[indexPath.row] as? String {
                cell.value = textValue
            }else {
                cell.value = record?.getLocalDate(detail.values[indexPath.row] as? NSDate)
            }
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat{
        let detail = recordDetails[indexPath.section]
        
        if detail.group == Storyboard.ImageCellReuseIdentifier {
            let ratio = CGFloat(1)
            return tableView.frame.width / ratio
        }else {
            return UITableViewAutomaticDimension
        }
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
