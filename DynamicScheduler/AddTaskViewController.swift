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
    
    var projectHelper:Project!
    
    @IBOutlet weak var nameTextField:UITextField!
    @IBOutlet weak var startDateField: UIDatePicker!
    @IBOutlet weak var estimatedTimeField: UITextField!
    @IBOutlet weak var endDateField: UIDatePicker!
    @IBOutlet weak var additionalNotes: UITextField!
    
    @IBAction func save(sender: UIBarButtonItem){
        guard let managedObjectContext = managedObjectContext else { return }
        print("project when going to add")
        print(projectHelper.name)
        let task = Task(context: managedObjectContext)
        task.startDate = startDateField.date
        task.estimated_length = Double(estimatedTimeField.text!)!// as! Double
        task.endDate = endDateField.date
        task.user_notes = additionalNotes.text
        
        task.project = projectHelper
        task.name = nameTextField.text
        
        _ = navigationController?.popViewController(animated: true)
    }
    
    @IBAction func back(sender: UIBarButtonItem){
        _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
