//
//  TempRootViewController.swift
//  DynamicScheduler
//
//  Created by Noah Brumfield on 12/4/19.
//  Copyright © 2019 Cameron Stowell. All rights reserved.
//

import UIKit
import CoreData
class TempRootViewController: UIViewController {

    private let persistentContainer = NSPersistentContainer(name: "Model")
    
    override func viewDidLoad() {
        super.viewDidLoad()
    persistentContainer.loadPersistentStores { (persistentStoreDescription, error) in
        print("BUTTSBUTTSBUTSS")
        if let error = error {
            print("unable to Load Persistent Store")
            print("\(error), \(error.localizedDescription)")
        }
        }        // Do any additional setup after loading the view.
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "RootToProjects" {
            if let destinationViewController = segue.destination as? ProjectTableViewController{
                destinationViewController.managedObjectContext = persistentContainer.viewContext
            }
        }
        if segue.identifier == "RootToGeneric" {
            print("Using Proper Segway")
            if let destinationViewController = segue.destination as? ProjectTableViewController{
                destinationViewController.managedObjectContext = persistentContainer.viewContext
            }
        }
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
