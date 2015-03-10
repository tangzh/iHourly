//
//  AddNoteViewController.swift
//  iHourly
//
//  Created by tang on 3/6/15.
//  Copyright (c) 2015 Stanford Univeristy. All rights reserved.
//

import UIKit
import CoreData

class AddNoteViewController: UIViewController, UITextViewDelegate {
    
    var record: Record? { didSet { updateUI() } }

    @IBOutlet weak var noteTextField: UITextView! {
        didSet {
            noteTextField.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
        noteTextField.becomeFirstResponder()
    }
    
    func updateUI() {
        noteTextField?.text = record?.note
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        textView.resignFirstResponder()
        return true
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        startObservingTextFields()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        stopObservingTextFields()
    }
    
    @IBAction func doneEditing(sender: UIBarButtonItem) {
//        record?.saveToCoreData(UIApplication.sharedApplication().delegate as AppDelegate)
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private var ntfObserver: NSObjectProtocol?
    
    private func startObservingTextFields()
    {
        let center = NSNotificationCenter.defaultCenter()
        let queue = NSOperationQueue.mainQueue()
        ntfObserver = center.addObserverForName(UITextViewTextDidChangeNotification, object: noteTextField, queue: queue) { notification in
            if self.record != nil {
                self.record?.note = self.noteTextField.text
            }
        }
    }
    
    private func stopObservingTextFields()
    {
        if let observer = ntfObserver {
            NSNotificationCenter.defaultCenter().removeObserver(observer)
        }
    }
}
