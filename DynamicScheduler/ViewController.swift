//
//  ViewController.swift
//  DynamicScheduler
//
//  Created by Cameron Stowell on 11/22/19.
//  Copyright © 2019 Cameron Stowell. All rights reserved.
//  The main calendar screen

import UIKit
import Neon
import CalendarKit
import CoreData

class ViewController: DayViewController {
    
    var container: NSPersistentContainer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard container != nil else {
            fatalError("This view needs a persistent container.")
        }
        
        title = "Dynamic Scheduler"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Dark", style: .done, target: self, action: .none)
        navigationController?.navigationBar.isTranslucent = false
        dayView.autoScrollToFirstEvent = true
        reloadData()
        
        //adds test data
        var managedObjectContext: NSManagedObjectContext
        managedObjectContext = container.viewContext
        
        //let entity = NSEntityDescription.entity(forEntityName: "EventData", in: managedObjectContext)!
        //let event  = NSManagedObject(entity: entity, insertInto: managedObjectContext)
        //event.setValue("test", forKey: "text")
        //event.setValue(Date(), forKey: "startDate")
        //event.setValue(calendar.date(byAdding: .hour, value: 1, to: Date()), forKey: "endDate")
        /*
        guard let entityProj1 = NSEntityDescription.entity(forEntityName: "Project", in: managedObjectContext) else{
            fatalError("Could not find entity description")
        }
        entityProj1.setValue("Basic Algorithms", forKey: "name")
        guard let entityProj2 = NSEntityDescription.entity(forEntityName: "Project", in: managedObjectContext) else {
            fatalError("Could not find entity description")
        }
        entityProj2.setValue("IOS Programming", forKey: "name")
        guard let entityProj3 = NSEntityDescription.entity(forEntityName: "Project", in: managedObjectContext) else{
            fatalError("Could not find entity description")
        }
        entityProj3.setValue("SocioLingusitics", forKey: "name")
        guard let entityProj4 = NSEntityDescription.entity(forEntityName: "Project", in: managedObjectContext) else{
            fatalError("Could not find entity description")
        }
        entityProj4.setValue("How Things Work", forKey: "name")
        guard let entity = NSEntityDescription.entity(forEntityName: "Project", in: managedObjectContext) else{
            fatalError("Could not find entity description")
        }
        
        for i in 1...16 {
            if(i < 5){
                let task = NSManagedObject(entity: entity, insertInto: managedObjectContext)
                task.setValue("Test", forKey: "name")
                task.setValue(Date.init(year: 2019, month: 11, day: 30), forKey: "startDate")
                task.setValue(i, forKey: "estimated_length")
            }
            else if(i < 9){
                let task = NSManagedObject(entity: entity, insertInto: managedObjectContext)
                task.setValue("Test", forKey: "name")
                task.setValue(i, forKey: "estimated_length")            }
            else if(i < 13){
                let task = NSManagedObject(entity: entity, insertInto: managedObjectContext)
                task.setValue("Test", forKey: "name")
                task.setValue(i, forKey: "estimated_length")                }
            else{
                let task = NSManagedObject(entity: entity, insertInto: managedObjectContext)
                task.setValue("Test", forKey: "name")
                task.setValue(i, forKey: "estimated_length")                }
        }
        */
        do {
            try managedObjectContext.save()

        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
        
    }

    override func eventsForDate(_ date: Date) -> [EventDescriptor] {
        var events = [Event]();
        
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

}

