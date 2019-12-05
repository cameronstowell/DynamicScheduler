//
//  AddProjectViewController.swift
//  DynamicScheduler
//
//  Created by Noah Brumfield on 12/1/19.
//  Copyright © 2019 Cameron Stowell. All rights reserved.
//

import UIKit
import CoreData

class AddProjectViewController: UIViewController {

    @IBOutlet var nameTextField: UITextField! 
    
    @IBAction func save(sender: UIBarButtonItem){
        //Add project to List and Pop to Project List
        guard let managedObjectContext = managedObjectContext else { return }
        
        let project = Project(context: managedObjectContext)
        
        project.name = nameTextField.text
        
        _ = navigationController?.popViewController(animated: false)
    }
    
    @IBAction func back(sender: UIBarButtonItem){
        //Pop back one controller, to Project List
        print("Should pop here")
        _ = navigationController?.popViewController(animated: false)
    }
    var managedObjectContext: NSManagedObjectContext?
    
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
