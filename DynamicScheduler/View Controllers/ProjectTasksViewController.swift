//
//  ProjectTasksViewController.swift
//  DynamicScheduler
//
//  Created by Noah Brumfield on 12/1/19.
//  Copyright © 2019 Cameron Stowell. All rights reserved.
//

import UIKit
import CoreData

extension ProjectTasksViewController: NSFetchedResultsControllerDelegate {}

class ProjectTasksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var taskNameHelper:String!
    var currentProject:String = ""
    @IBOutlet var tableView: UITableView!
    @IBOutlet weak var projectLabel:UILabel!
    var projectHelper:Project!
    var managedObjectContext:NSManagedObjectContext!
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Task> = {
        print("Initializing result controller PrjectTasks")
        //Get the project out of the string name first
        
        let projectFetch:NSFetchRequest<Project> = Project.fetchRequest()
        projectFetch.predicate = NSPredicate(format: "%K == %@", "name", currentProject)
        var fetchedProject:[Project]
        do{
            fetchedProject = try managedObjectContext.fetch(projectFetch)
            
        }catch {
            fatalError("Failed to fetch Project")
        }
        //right now were assuming there are no duplicates
        //There shoudlnt be, may want to prevent people from trying
        projectHelper = fetchedProject[0]
        
        let fetchRequest:NSFetchRequest<Task> = Task.fetchRequest()
        //print("Task Fetch request is set")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        fetchRequest.predicate = NSPredicate(format:"%K == %@", "project.name", currentProject)
        //print("predicate is set")
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext,sectionNameKeyPath: nil, cacheName: nil)
        //print("Resulsts Controller is set")
        fetchedResultsController.delegate = self //as! NSFetchedResultsControllerDelegate
        //print("Delegate Set")
        return fetchedResultsController
        //} catch {
        //    fatalError("Failed to fetch Project")
        //}
        
        
    }()
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        print("how bout now")
        if segue.identifier == "AddTasks"{
            if let destinationViewController = segue.destination as? AddTaskViewController{
                destinationViewController.managedObjectContext = managedObjectContext
                destinationViewController.projectHelper = projectHelper
                
            }
        }
        if segue.identifier == "TaskToDetails"{
            //print("Just not taskDetailViewController")
            if let destinationViewController = segue.destination as? TaskDetailViewController {
            //print("Should be here")
            //print("Should DEFINITELY be here")
            destinationViewController.managedObjectContext = managedObjectContext
            //print(objectToPass)
            //print("just printed")
            destinationViewController.objectToPass = taskNameHelper
         
            }
            
        }
        
    }
    
     override func viewDidLoad() {
           print("Before super view did load?")
           super.viewDidLoad()
           print("Just before Label")
           projectLabel.text = currentProject
           print("Just before Perform Fetch")
           
           //self.fetchedResultsController.deleteCacheWithName;:nil
           do {
               try self.fetchedResultsController.performFetch()
           } catch{
               let fetchError = error as NSError
               print("Unable to perform fetch request")
               print("\(fetchError), \(fetchError.localizedDescription)")
           }
           // Do any additional setup after loading the view.
       }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let tasks = fetchedResultsController.fetchedObjects else { return 0 }
        return tasks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProjectTaskCell", for: indexPath) as? ProjectTaskCell else {
            fatalError("Unexpected Index Path")
        }
        
        let task = fetchedResultsController.object(at: indexPath)
        
        cell.nameLabel.text = task.name
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let currentCell = tableView.cellForRow(at: indexPath) as? ProjectTaskCell
        
        
        taskNameHelper = currentCell?.nameLabel.text
        print(taskNameHelper!)
        self.performSegue(withIdentifier: "TaskToDetails", sender: self)
    }
    
    func controllerWillChangeContent(_ controller:NSFetchedResultsController<NSFetchRequestResult>){
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
        
        
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?){
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                print("Adding to Tasks")
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        default:
            print(type)
            
            print("Project Tasks Fetch Change Unknown Type")
        }
    } 
}
