//
//  AddNoteViewController.swift
//  iHourly
//
//  Created by tang on 3/6/15.
//  Copyright (c) 2015 Stanford Univeristy. All rights reserved.
//

import UIKit

class AddNoteViewController: UIViewController, UITextFieldDelegate {
    
    var recordNote: String? { didSet { updateUI() } }

    @IBOutlet weak var noteTextField: UITextField! { didSet { noteTextField.delegate = self } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    func updateUI() {
        noteTextField?.text = recordNote?
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
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
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    private var ntfObserver: NSObjectProtocol?
    
    private func startObservingTextFields()
    {
        let center = NSNotificationCenter.defaultCenter()
        let queue = NSOperationQueue.mainQueue()
        ntfObserver = center.addObserverForName(UITextFieldTextDidChangeNotification, object: noteTextField, queue: queue) { notification in
            if self.recordNote != nil {
                self.recordNote = self.noteTextField.text
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
