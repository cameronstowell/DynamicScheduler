//
//  AddTaskViewController.swift
//  DynamicScheduler
//
//  Created by Noah Brumfield on 12/2/19.
//  Copyright © 2019 Cameron Stowell. All rights reserved.
//

import UIKit
import CoreData

class AddTaskViewController: UIViewController {
    
    var managedObjectContext:NSManagedObjectContext?
    var timeFormatter:DateFormatter!
    
    var projectHelper:Project!
    
    @IBOutlet weak var nameTextField:UITextField!
    @IBOutlet weak var startDateTextField: UITextField!
    @IBOutlet weak var estimatedTimeField: UITextField!
    @IBOutlet weak var dueDateTextField: UITextField!
    @IBOutlet weak var notesTextView: UITextView!
    
    @IBAction func save(sender: UIBarButtonItem){
        guard let managedObjectContext = managedObjectContext else { return }
        let task = Task(context: managedObjectContext)
        //TODO: fix start date and due date
        //task.startDate = startDateTextField?.text as Date
        //task.endDate = endDateField.date
        task.user_notes = notesTextView.attributedText.string
        task.estimated_length = Double(estimatedTimeField.text!)!// as! Double
       
        task.project = projectHelper
        task.name = nameTextField.text
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    //When users touch down on the startDateTextField, it opens a DatePicker that can be used to select the date. When the user is finished entering their date, the DatePicker disappears.
    @IBAction func openStartDatePicker(_ sender: UITextField) {
        let startDatePicker = UIDatePicker()
        sender.inputView = startDatePicker
        startDatePicker.addTarget(self, action: #selector(startDateChanged), for: .valueChanged)
    }
    
    //same as openStartDatePicker, but for the task's due date
    @IBAction func openDueDatePicker(_ sender: UITextField) {
        let dueDatePicker = UIDatePicker()
        sender.inputView = dueDatePicker
        dueDatePicker.addTarget(self, action: #selector(dueDateChanged), for: .valueChanged)
    }
    
    //These two functions simply take the dates from the date pickers and put them into their respective text fields
    @objc func startDateChanged(_ sender : UIDatePicker){
        startDateTextField.text = self.timeFormatter.string(from: sender.date)
    }
    
    @objc func dueDateChanged(_ sender : UIDatePicker){
        dueDateTextField.text = self.timeFormatter.string(from: sender.date)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "en_US")
        timeFormatter.dateStyle = .medium
        timeFormatter.timeStyle = .medium
        
        //Tapping anywhere on the screen will dismiss the keyboard or date picker
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        //Add border to the text view for notes
        notesTextView.layer.borderWidth = 5.0
        notesTextView.layer.borderColor = UIColor.gray.cgColor
    }
    
    //Used to scroll the Notes TextView to the top of the screen when it is selected
    override func viewWillLayoutSubviews() {
        notesTextView.scrollRangeToVisible(NSRange(location:0, length:0))
    }

}
