//
//  TaskDetailViewController.swift
//  
//
//  Created by Noah on 9/19/1398 AP.
//

import UIKit
import CoreData
import CalendarKit

class TaskDetailViewController: UIViewController {
    
    var managedObjectContext:NSManagedObjectContext!
    var objectToPass:String?
    var taskHelper:Task!
    var timeFormatter:DateFormatter!
    
    @IBOutlet weak var EditProjectName: UILabel!
    @IBOutlet weak var EditTaskName: UILabel!
    @IBOutlet weak var EditStartDate: UILabel!
    @IBOutlet weak var EditDueDate: UILabel!
    @IBOutlet weak var EditEstimatedHours: UILabel!
    @IBOutlet weak var EditAdditionalNotes: UITextView!
    
    
    @IBAction func back(sender: UIBarButtonItem){
        _ = navigationController?.popViewController(animated: true)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //objectToPass = objectToPass
        
        print(objectToPass!)
        timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "en_US")
        timeFormatter.dateStyle = .medium
        timeFormatter.timeStyle = .medium
        
        //When segueing from the calendar view, we only have access to the task name,
        //So rather than sending the object itself, we send the name
        //And fetch the task itself from that name, which we do here.
        let taskFetch:NSFetchRequest<Task> = Task.fetchRequest()
        taskFetch.predicate = NSPredicate(format: "%K == %@", "name", objectToPass!)
        var fetchedTask:[Task]
        do{
            fetchedTask = try managedObjectContext.fetch(taskFetch)
            
        }catch {
            fatalError("Failed to fetch Task")
        }
        
        taskHelper = fetchedTask[0]
        //Now that we have the task, use its values to set the outlets        EditProjectName.text = taskHelper.project?.name
        EditTaskName.text = taskHelper.name
        EditStartDate.text = timeFormatter.string(from: taskHelper.startDate)
        EditDueDate.text = timeFormatter.string(from :taskHelper.dueDate)
        EditEstimatedHours.text = String(taskHelper.estimated_length)
        EditAdditionalNotes.text = taskHelper.user_notes
        
        
        
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
