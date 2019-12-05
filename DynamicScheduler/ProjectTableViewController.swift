//
//  ProjectTableViewController.swift
//  DynamicScheduler
//
//  Created by Noah Brumfield on 12/1/19.
//  Copyright © 2019 Cameron Stowell. All rights reserved.
//

import UIKit
import CoreData

//extension ViewController: NSFetchedResultsControllerDelegate {}
class ProjectTableViewController: UITableViewController {
    
    private let SegueAddProjectViewController = "SegueAddProjectViewController"
    private let persistentContainer = NSPersistentContainer(name: "Projects")
    var projects = [Project](){
        didSet {
            updateView()
        }
    }
    //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //var fetchRequestProject = NSFetchRequest<NSFetchRequestResult>(entityName: "Project")
    
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Project> = {
        let fetchRequest:NSFetchRequest<Project> = Project.fetchRequest()
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext,sectionNameKeyPath: nil, cacheName: nil)
        
        fetchedResultsController.delegate = self as! NSFetchedResultsControllerDelegate
        return fetchedResultsController
    }()
    private func updateView() {
        let hasProjects = projects.count > 0
        tableView.isHidden = !hasProjects
        //messageLabel.isHidden = hasProjects
        
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
        default:
            print("...")
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == SegueAddProjectViewController {
            if let destinationViewController = segue.destination as? AddProjectViewController{
                destinationViewController.managedObjectContext = persistentContainer.viewContext
            }
        }
    }
    override func viewDidLoad() {
        /*do {
            let results = try context.fetch(fetchRequestProject)
        }catch let error as NSError {
            print("Could not fetch \(error)")
        }*/
        //let projects = results as! [Project]
        
        
        super.viewDidLoad()
        persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
            if let error = error {
                print("unable to Load Persistent Store")
                print("\(error), \(error.localizedDescription)")
            } else {
                do {
                    try self.fetchedResultsController.performFetch()
                } catch{
                    let fetchError = error as NSError
                    print("Unable to perform fetch request")
                    print("\(fetchError), \(fetchError.localizedDescription)")
                }
            }
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1 //may need changing
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let projects = fetchedResultsController.fetchedObjects else { return 0 }
        return projects.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath) as? TableViewCell else {
            fatalError("Unexpected Index Path")
        }

        let project = fetchedResultsController.object(at: indexPath)
        
        cell.nameLabel.text = project.name
        

        return cell
    }
 
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
