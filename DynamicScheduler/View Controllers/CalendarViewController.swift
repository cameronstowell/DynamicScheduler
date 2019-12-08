//
//  ViewController.swift
//  DynamicScheduler
//
//  Created by Cameron Stowell on 11/22/19.
//  Copyright © 2019 Cameron Stowell. All rights reserved.
//  The main calendar screen

import UIKit
import CalendarKit
import CoreData

class CalendarViewController: DayViewController {
    
    var container: NSPersistentContainer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard container != nil else {
            fatalError("This view needs a persistent container.")
        }
        
        //Build navigation bar with title and buttons
        title = "Dynamic Scheduler"
        let addProjectOrTasksButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToAddTask))
        let goToTaskListButton = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(goToProjects))
        
        //currently not needed for prototype, button for stats/settings
        //let goToSettingsButton = UIBarButtonItem(barButtonSystemItem: .s, target: <#T##Any?#>, action: <#T##Selector?#>)
        
        navigationItem.setRightBarButtonItems([addProjectOrTasksButton, goToTaskListButton], animated: false)
        navigationController?.navigationBar.isTranslucent = false
        dayView.autoScrollToFirstEvent = true
        reloadData()
        
        //Alerts user if first time launching app to ask to import their iOS calendar
        if !(self.hasBeenPromptedForImport()){
            self.promptForImport()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isToolbarHidden = true
    }

    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        
        guard container != nil else {
            fatalError("This view needs a persistent container.")
        }
        
        var events = [Event]()
        
        // Get the current calendar with local time zone
        var calendar = Calendar.current
        calendar.timeZone = NSTimeZone.local

        // Get today's beginning & end
        let dateFrom = calendar.startOfDay(for: date) // eg. 2016-10-10 00:00:00
        let dateTo = calendar.date(byAdding: .day, value: 1, to: dateFrom)

        // Set predicate as date being today's date
        let fromPredicate = NSPredicate(format: "startDate >= %@", dateFrom as NSDate)
        let toPredicate = NSPredicate(format: "endDate <= %@", dateTo! as NSDate)
        let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
        
        //date formatter
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm"
        
        //Get Tasks
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "EventData")
        
        request.predicate = datePredicate
        do {
            let result = try container.viewContext.fetch(request)
            for data in result as! [EventData] {
               // Create new EventView
               let event = Event()
               // Specify StartDate and EndDate
               event.startDate = data.startDate
               event.endDate = data.endDate
               // Add info: event title, subtitle, location to the array of Strings
               var info = [data.text, " "]
                info.append("\(formatter.string(from: data.startDate)) - \(formatter.string(from: data.endDate))")
               // Set "text" value of event by formatting all the information needed for display
               event.text = info.reduce("", {$0 + $1 + "\n"})
               events.append(event)
          }
            
        } catch {
            print("Failed")
        }
        
        return events;
    }
    
    @objc func goToAddTask () {
        let addTaskView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddTaskView") as! AddTaskViewController
        addTaskView.managedObjectContext = container.viewContext;
        self.navigationController?.pushViewController(addTaskView, animated: true)
    }
    
    @objc func goToProjects () {
        let projectsView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ProjectsView") as! ProjectTableViewController
        projectsView.managedObjectContext = container.viewContext;
        self.navigationController?.pushViewController(projectsView, animated: true)
    }
    
    //TODO: Make selecting event bring you to task details page for that event
    /*
    override func dayViewDidSelectEventView(_ eventView: EventView) {
        let taskDetailView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TaskDetailView") as! GenericTaskViewController
        taskDetailView.managedObjectContext = container.viewContext;
        self.navigationController?.pushViewController(taskDetailView, animated: true)
    }
    */
    
    //Used to know whether or not to prompt for Calendar Import
    func hasBeenPromptedForImport()->Bool{
        let defaults = UserDefaults.standard
        if let _ = defaults.string(forKey: "hasBeenPromptedForImport"){
            print("App already launched")
            return true
        }else{
            defaults.set(true, forKey: "hasBeenPromptedForImport")
            print("Prompting for import first time")
            return false
        }
    }
    
    //Creates alert that starts calendar import when "Yes" is selected
    func promptForImport(){
        let alert = UIAlertController(title: "Import Your iOS Calendar", message: "Fill that calendar up!", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "No", style: .default) {
            UIAlertAction in
            print("No calendar import requested")
            })
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default) {
            UIAlertAction in
            print("Import requested.")
            let importer = CalendarImporter(container: self.container)
            importer.importCalendar()
            self.reloadData()
        })
        
        navigationController?.present(alert, animated: true, completion: nil)
    }
}

