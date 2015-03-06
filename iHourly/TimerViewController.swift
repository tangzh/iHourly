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
    
    private var timer = NSTimer()
    private var starttime = NSDate()
    var timeRecorded = NSDateComponents()
    var projects = ["Study", "Work", "Eat", "Transportation"]
    var recordNote: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshProjects()
        initProjectPicker()
        controlButton.setTitleColor(UIColor.uicolorFromHex(0x33691E), forState: .Normal)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        controlButton.layer.cornerRadius = 0.5 * controlButton.bounds.size.width
    }
    
    func refreshProjects() {
        if let oldProjects = NSUserDefaults.standardUserDefaults().objectForKey("History") as? Array<String> {
            if oldProjects.count > projects.count {
                projects = oldProjects
            }
        }
    }
    
    func initProjectPicker() {
        projectPickerTwo.delegate = self
        projectPickerTwo.dataSource = self
        
        var toolbar = UIToolbar(frame: CGRectMake(0, 0, self.view.bounds.size.width, 40))
        var item = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done,
            target: self, action: "doneChooseProject")
        
        toolbar.setItems([item], animated: true)
        projectChosen.delegate = self
        projectChosen.inputView = projectPickerTwo
        projectChosen.inputAccessoryView = toolbar
        projectChosen.text = "\(projects[0])"
    }

    @IBAction func startTime(sender: UIButton) {
        if(controlButton.titleLabel?.text == "Start") {
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateTimeView", userInfo: nil, repeats: true)
            starttime = NSDate()
            controlButton.setTitle("Stop", forState: .Normal)
            controlButton.setTitleColor(UIColor.redColor(), forState: .Normal)
        }else if(controlButton.titleLabel?.text == "Stop") {
            controlButton.setTitle("Start", forState: .Normal)
            timer.invalidate()
            showAlert()
            controlButton.setTitleColor(UIColor.uicolorFromHex(0x2E7D32), forState: .Normal)
        }
    }
    
    @IBAction func addNewProject(sender: AnyObject) {
        var alert = UIAlertController(title: "New Project",
            message: "Please Enter The Project Name",
            preferredStyle: UIAlertControllerStyle.Alert
        )
        
        alert.addTextFieldWithConfigurationHandler { (textField) in
            textField.placeholder = "Project Name"
        }
        
        let saveAction = UIAlertAction(title: "Save",
            style: .Default) { (action: UIAlertAction!) -> Void in
            
            let textField = alert.textFields![0] as UITextField
            if let projectName = textField.text {
                self.projects.append(textField.text)
                NSUserDefaults.standardUserDefaults().setObject(self.projects, forKey: "History")
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
            style: .Default) { (action: UIAlertAction!) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func showAlert() {
        var alert = UIAlertController(title: "Record Time",
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

            timeRecorded = calendar.components(flags, fromDate: starttime, toDate: current, options: nil)//current - starttime
//            println("\(starttime) \(current)")
            
            let hour = timeRecorded.hour
            let hourLabel = formateTime(hour)
            
            let minute = timeRecorded.minute
            let minuteLabel = formateTime(minute)
            
            let second = timeRecorded.second
            let secondLabel = formateTime(second)
            
            timeView.text = "\(hourLabel) : \(minuteLabel) : \(secondLabel)"
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
        projectChosen!.text = "\(projects[row])"
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addNote" {
            if let anvc = segue.destinationViewController.contentViewController as? AddNoteViewController {
                anvc.recordNote = recordNote
            }
        }
    }
    

}
