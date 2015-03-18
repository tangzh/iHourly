//
//  TimerViewController.swift
//  iHourly
//
//  Created by tang on 3/1/15.
//  Copyright (c) 2015 Stanford Univeristy. All rights reserved.
//
// Citation: Inspiration for timer from http://rshankar.com/simple-stopwatch-app-in-swift/
// Citation: How to use pickerview as the input for textFiled http://stackoverflow.com/questions/14597902/bringing-up-a-uipickerview-rather-than-keyboard-input-ios

import UIKit
import CoreData
import MobileCoreServices

class TimerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var timeView: UILabel!
    @IBOutlet weak var projectChosen: UITextField!
    @IBOutlet weak var controlButton: UIButton!
    @IBOutlet weak var addNoteButton: UIButton!
    @IBOutlet weak var addPhotoButton: UIButton!
    
    var projectPickerTwo = UIPickerView()
    var record: Record?
    
    private var timer = NSTimer()
    private var starttime = NSDate()
    private var stoptime = NSDate()
    var timeRecorded = NSDateComponents()
    var projects = ["Study", "Work", "Eat", "Transportation"]
    
    // MARK: -Init
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshProjects()
        initProjectPicker()
        controlButton.setTitleColor(UIColor.uicolorFromHex(0x01d1cd), forState: .Normal)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        controlButton.layer.cornerRadius = 0.5 * controlButton.bounds.size.width
        addNoteButton.layer.cornerRadius = 0.5 * addNoteButton.bounds.size.width
        addPhotoButton.layer.cornerRadius = 0.5 * addPhotoButton.bounds.size.width
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

    // MARK: - Timer
    @IBAction func startTime(sender: UIButton) {
        if(controlButton.titleLabel?.text == "Start") {
            timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "updateTimeView", userInfo: nil, repeats: true)
            starttime = NSDate()
            controlButton.setTitle("Stop", forState: .Normal)
            controlButton.setTitleColor(UIColor.redColor(), forState: .Normal)
            record = Record(data: nil)
        }else if(controlButton.titleLabel?.text == "Stop") {
            controlButton.setTitle("Start", forState: .Normal)
            stoptime = NSDate()
            timer.invalidate()
            showAlert()
            controlButton.setTitleColor(UIColor.uicolorFromHex(0x01d1cd), forState: .Normal)
        }
    }
    
    func updateTimeView() {
        if timeView != nil {
            var current = NSDate()
            let calendar = NSCalendar.currentCalendar()
            let flags: NSCalendarUnit = .HourCalendarUnit | .MinuteCalendarUnit | .SecondCalendarUnit
            
            timeRecorded = calendar.components(flags, fromDate: starttime, toDate: current, options: nil)//current - starttime
            
            let hour = timeRecorded.hour
            let hourLabel = formateTime(hour)
            
            let minute = timeRecorded.minute
            let minuteLabel = formateTime(minute)
            
            let second = timeRecorded.second
            let secondLabel = formateTime(second)
            
            timeView.text = "\(hourLabel) : \(minuteLabel) : \(secondLabel)"
        }
    }
    
    func resetTimeView() {
        if timeView != nil {
             timeView.text = "00 : 00 : 00"
        }
    }
    
    private func formateTime(inputTime: Int) -> String {
        if( inputTime < 10 ) {
            return "0\(inputTime)"
        }else {
            return "\(inputTime)"
        }
    }

    func showAlert() {
        var alert = UIAlertController(title: "Record Time",
            message: "Do you want to save \n \(timeView.text!) \n to \(projectChosen.text!)?",
            preferredStyle: UIAlertControllerStyle.Alert
        )
        
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default)
            { (action: UIAlertAction!) -> Void in
                self.saveToCoreData()
                self.record = nil
                self.resetTimeView()
            }
        )
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Default)
            { (action: UIAlertAction!) -> Void in
                self.resetTimeView()
            }
        )
        
        presentViewController(alert, animated: true, completion: nil)
    }

    // MARK: - Project picker
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
                if projectName != "" {
                    self.projects.append(projectName)
                    NSUserDefaults.standardUserDefaults().setObject(self.projects, forKey: "History")
                    self.projectChosen.text = "\(projectName)"
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
            style: .Default) { (action: UIAlertAction!) -> Void in
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    func doneChooseProject() {
        projectChosen.resignFirstResponder()
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
    
    // MARK: - Save to CoreData
    
    func saveToCoreData() {
        record?.projectName = projectChosen.text
        record?.starttime = starttime
        record?.stoptime = stoptime
        record?.saveToCoreData(UIApplication.sharedApplication().delegate as AppDelegate)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "addNote" {
            if let anvc = segue.destinationViewController.contentViewController as? AddNoteViewController {
                anvc.record = record
            }
        }else if segue.identifier == "addPhoto" {
            if let apvc = segue.destinationViewController.contentViewController as? AddPhotoViewController {
                apvc.record = record
            }
        }
    }
}

extension UIViewController {
    var contentViewController: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController
        } else {
            return self
        }
    }
}
