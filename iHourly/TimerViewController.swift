//
//  TimerViewController.swift
//  iHourly
//
//  Created by tang on 3/1/15.
//  Copyright (c) 2015 Stanford Univeristy. All rights reserved.
//
// Citation: http://rshankar.com/simple-stopwatch-app-in-swift/

import UIKit
import CoreData

class TimerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var timeView: UILabel!
    @IBOutlet weak var projectChosen: UITextField!
    @IBOutlet weak var controlButton: UIButton!
    
    var projectPickerTwo = UIPickerView()
    
    var timer = NSTimer()
//    var starttime = NSTimeInterval()
    var starttime = NSDate()
//    var timeRecorded: Double = 0
    var timeRecorded: NSDateComponents?
    var projects = ["Study", "Work", "Eat", "Transportation"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        controlButton.setTitleColor(UIColor.greenColor(), forState: .Normal)
        projectPickerTwo.delegate = self
        projectPickerTwo.dataSource = self
        
        var toolbar = UIToolbar(frame: CGRectMake(0, 0, self.view.bounds.size.width, 44))
        var item = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done,
            target: self, action: "doneChooseProject")
        
        toolbar.setItems([item], animated: true)
        projectChosen.delegate = self
        projectChosen.inputView = projectPickerTwo
        projectChosen.inputAccessoryView = toolbar
        projectChosen.text = "\(projects[0])"
        
        // test for core data
//        var appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
//        if let context: NSManagedObjectContext = appDel.managedObjectContext {
//            var request = NSFetchRequest(entityName: "Records")
//            request.returnsObjectsAsFaults = false
//            
//            var results = context.executeFetchRequest(request, error: nil)
//            
//            println("\(results)")
//        }
    }

    @IBAction func startTime(sender: UIButton) {
        if(controlButton.titleLabel?.text == "Start") {
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateTimeView", userInfo: nil, repeats: true)
//            starttime = NSDate.timeIntervalSinceReferenceDate()
            starttime = NSDate()
            controlButton.setTitle("Stop", forState: .Normal)
            controlButton.setTitleColor(UIColor.redColor(), forState: .Normal)
        }else if(controlButton.titleLabel?.text == "Stop") {
            controlButton.setTitle("Start", forState: .Normal)
            timer.invalidate()
            showAlert()
            controlButton.setTitleColor(UIColor.greenColor(), forState: .Normal)
        }
    }
    
    func showAlert() {
        var alert = UIAlertController(title: "Time Recorded",
            message: "Do you want to save \n \(timeView.text!) \n to \(projectChosen.text!)?",
            preferredStyle: UIAlertControllerStyle.Alert
        )
        var appDel: AppDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default)
            { (action: UIAlertAction!) -> Void in
                if let context: NSManagedObjectContext = appDel.managedObjectContext {
                    var newRecord = NSEntityDescription.insertNewObjectForEntityForName("Records", inManagedObjectContext: context) as NSManagedObject
                    newRecord.setValue(self.projectChosen.text, forKey: "project")
                    newRecord.setValue(self.starttime, forKey: "starttime")
                    newRecord.setValue(NSDate(), forKey: "stoptime")
                    
                    context.save(nil)
                }
            }
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default)
            { (action: UIAlertAction!) -> Void in
            }
        )
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func doneChooseProject() {
        projectChosen.resignFirstResponder()
    }
    
    func updateTimeView() {
        if timeView != nil {
            var current = NSDate()
            let calendar = NSCalendar.currentCalendar()
            let flags: NSCalendarUnit = .HourCalendarUnit | .MinuteCalendarUnit | .SecondCalendarUnit

//            var current = NSDate.timeIntervalSinceReferenceDate()
            timeRecorded = calendar.components(flags, fromDate: starttime, toDate: current, options: nil)//current - starttime
            println("\(starttime) \(current)")
            
           let hour = timeRecorded!.hour as Int
           let hourLabel = "\(hour)"
            //formateTime(hour)
//            timeRecorded -= NSTimeInterval(hour*3600)
            
            
//            let minute = Int(timeRecorded / 60)
            let minuteLabel =  timeRecorded?.minute//formateTime(minute)
//            timeRecorded -= NSTimeInterval(minute*60)
            
//            let second = Int(timeRecorded)
            let secondLabel = timeRecorded?.second//formateTime(second)
            
            
            timeView.text = "\(hourLabel) : \(minuteLabel): \(secondLabel)"
        }
    }
    
    private func formateTime(inputTime: Int) -> String {
        if( inputTime < 10 ) {
            return "0\(inputTime)"
        }else {
            return "\(inputTime)"
        }
    }
    
    @IBAction func stopTimer(sender: UIButton) {
        timer.invalidate()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return projects.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return projects[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        projectChosen.text = "\(projects[row])"
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
