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
    var managedObjectContext: NSManagedObjectContext?
    
    @IBAction func save(sender: UIBarButtonItem){
        //Add project to List and Pop to Project List
        guard let managedObjectContext = managedObjectContext else { return }
        
        let project = Project(context: managedObjectContext)
        
        project.name = nameTextField.text
        
        _ = navigationController?.popViewController(animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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
