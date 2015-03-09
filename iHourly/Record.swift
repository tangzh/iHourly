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
//    public let projectName: String
//    public let starttime: NSDate
//    public let endtime: NSDate
//    
//    init?(data: NSDictionary?) {
//        if let projectName = data?.valueForKeyPath("projectName") as? String {
//            self.projectName = projectName
//        }
//    }
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
            
            context.save(nil)
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

}