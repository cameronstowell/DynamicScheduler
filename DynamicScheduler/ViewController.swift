//
//  ViewController.swift
//  DynamicScheduler
//
//  Created by Cameron Stowell on 11/22/19.
//  Copyright © 2019 Cameron Stowell. All rights reserved.
//

import UIKit
import CoreData

extension ViewController:NSFetchedResultsControllerDelegate{}
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    @IBAction func back(sender: UIBarButtonItem){
        //Pop back one controller, to root
        print("Should pop here")
        _ = navigationController?.popViewController(animated: false)
    }
    var managedObjectContext:NSManagedObjectContext!
    var objectToPass:String!
    private let SegueAddProjectViewController = "SegueAddProjectViewController"

    /*var projects = [Project](){
        didSet {
            updateView()
        }
    }*/
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Project> = {
        print("Initializing results controller view controller")
        let fetchRequest:NSFetchRequest<Project> = Project.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext,sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    
    private func updateView() {
        /*let hasProjects = projects.count > 0
        tableView.isHidden = !hasProjects
        //messageLabel.isHidden = hasProjects*/
        
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
                tableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        case .update:
            print("Object Updated")
        default:
            print("View Controller Fetch Change Unknown Type")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == SegueAddProjectViewController {
            if let destinationViewController = segue.destination as? AddProjectViewController{
                destinationViewController.managedObjectContext = managedObjectContext
            }
        }
        if segue.identifier == "ProjectsToTasks" {
            if let destinationViewController = segue.destination as? ProjectTasksViewController {
                destinationViewController.managedObjectContext = managedObjectContext
                
                destinationViewController.currentProject = objectToPass
                
            }
        }
    }
    override func viewDidLoad() {
        print("Loading View View Controller")
        super.viewDidLoad()
        //Navigation Controller pop and push should make this only happen once
        //When alltogether, an object context should probs be pushed here
        //in a segway, rather than made here
        do {
            try self.fetchedResultsController.performFetch()
        } catch{
            let fetchError = error as NSError
            print("Unable to perform fetch request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
    // Do any additional setup after loading the view.
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1 //may need changing
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let projects = fetchedResultsController.fetchedObjects else { return 0 }
        return projects.count
        //return 0
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath) as? TableViewCell else {
            fatalError("Unexpected Index Path")
        }
        
        let project = fetchedResultsController.object(at: indexPath)
        
        cell.nameLabel.text = project.name
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        let currentCell = tableView.cellForRow(at: indexPath) as? TableViewCell
        
        
        objectToPass = currentCell?.nameLabel.text
        print(objectToPass!)
        self.performSegue(withIdentifier: "ProjectsToTasks", sender: self)
    }

}

