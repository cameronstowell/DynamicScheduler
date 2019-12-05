//
//  GenericTaskViewController.swift
//  DynamicScheduler
//
//  Created by Noah Brumfield on 12/4/19.
//  Copyright © 2019 Cameron Stowell. All rights reserved.
//

import UIKit
import CoreData

extension GenericTaskViewController: NSFetchedResultsControllerDelegate {}
class GenericTaskViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    @IBOutlet var tableView: UITableView!
    @IBAction func back(sender: UIBarButtonItem){
        //Pop back one controller, to root
        print("Should pop here")
        _ = navigationController?.popViewController(animated: true)
    }
    var managedObjectContext:NSManagedObjectContext!
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Task> = {
        print("Initializing result controller GenericTasks")
        //right now were assuming there are no duplicates
        //There shoudlnt be, may want to prevent people from trying
        
        let fetchRequest:NSFetchRequest<Task> = Task.fetchRequest()
        //print("Task Fetch request is set")
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        //print("predicate is set")
        if(managedObjectContext == nil){
            print("context is nil (Problem)")
        }
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext,sectionNameKeyPath: nil, cacheName: nil)
        //print("Resulsts Controller is set")
        fetchedResultsController.delegate = self //as! NSFetchedResultsControllerDelegate
        //print("Delegate Set")
        return fetchedResultsController
        //} catch {
        //    fatalError("Failed to fetch Project")
        //}
        
        
    }()
    
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: GenericTaskViewCell.reuseIdentifier, for: indexPath) as? GenericTaskViewCell else {
            fatalError("Unexpected Index Path")
        }
        
        let project = fetchedResultsController.object(at: indexPath)
        
        cell.nameLabel.text = project.name
        
        
        return cell
    }
    
    override func viewDidLoad() {
        print("Do i even make it here?")
        super.viewDidLoad()
        do {
            try self.fetchedResultsController.performFetch()
        } catch{
            let fetchError = error as NSError
            print("Unable to perform fetch request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
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
