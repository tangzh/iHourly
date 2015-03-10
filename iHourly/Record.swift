//
//  Record.swift
//  iHourly
//
//  Created by tang on 3/5/15.
//  Copyright (c) 2015 Stanford Univeristy. All rights reserved.
//

import Foundation
import CoreData

public class Record {

    var projectName: String?
    var starttime: NSDate?
    var stoptime: NSDate?
    var note: String?
    var photoUrl: String?
    
    init(data: NSManagedObject?) {
        if let record = data {
            self.projectName = record.valueForKey("project") as? String
            self.starttime = record.valueForKey("starttime") as? NSDate
            self.stoptime = record.valueForKey("stoptime") as? NSDate
            self.note = record.valueForKey("note") as? String
            self.photoUrl = record.valueForKey("photoURL") as? String
        }
        
    }
    
    func saveToCoreData(appDel: AppDelegate ) {
        //var appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        if let context: NSManagedObjectContext = appDel.managedObjectContext {
            var newRecord = NSEntityDescription.insertNewObjectForEntityForName("Records", inManagedObjectContext: context) as NSManagedObject
            newRecord.setValue(projectName, forKey: "project")
            newRecord.setValue(starttime, forKey: "starttime")
            newRecord.setValue(stoptime, forKey: "stoptime")
            newRecord.setValue(note, forKey: "note")
            newRecord.setValue(photoUrl, forKey: "photoURL")
            newRecord.setValue(timeLength, forKey: "timeLength")
            
            context.save(nil)
        }
    }
    
    var timeLength: Int? {
        get {
            if stoptime != nil && starttime != nil{
                return Int(stoptime!.timeIntervalSinceDate(starttime!))
            }else {
                return nil
            }
        }
    }
    
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
    
    func getFormatTimeLength() -> String {
        if let totalTime = timeLength {
            let hour = totalTime / 3600
            let min = (totalTime - hour*3600) / 60
            let second = (totalTime - hour*3600) % 60
            return "\(hour) hour \(min) min \(second) sec"
        }else {
            return "0s"
        }
    }
}