//
//  TaskScheduler.swift
//  DynamicScheduler
//
//  Created by Cameron Stowell on 12/8/19.
//  Copyright © 2019 Cameron Stowell. All rights reserved.
//

import Foundation
import CoreData

class TaskScheduler {
    
    var task : Task
    var managedObjectContext : NSManagedObjectContext
    
    init(task:Task, managedObjectContext:NSManagedObjectContext){
        self.task = task
        self.managedObjectContext  = managedObjectContext
    }
    
    //Creates events that fall within the Task's start and end date while avoiding other events already on the calendar for during that period. Returns false if there is not enough time to complete the task by the due date. 
    func schedule() -> Bool {
        var numOfEventsToSchedule = task.estimated_length / task.attentionSpan
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        var currDay = task.startDate
        let dueDate = task.dueDate
        var earliestTime = Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: currDay)
        
        while(numOfEventsToSchedule >= 0){
            if(currDay >= dueDate){
                return false
            }

            // Get all existing events on currDay
            let dateFrom = Calendar.current.startOfDay(for: currDay) // eg. 2016-10-10 00:00:00
            let dateTo = Calendar.current.date(byAdding: .day, value: 1, to: dateFrom)
            let fromPredicate = NSPredicate(format: "startDate >= %@", dateFrom as NSDate)
            let toPredicate = NSPredicate(format: "endDate <= %@", dateTo! as NSDate)
            let datePredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [fromPredicate, toPredicate])
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "EventData")
            request.predicate = datePredicate
            
            do {
                let result = try managedObjectContext.fetch(request)
                
                var currTime = earliestTime!
                for data in result as! [EventData] {
                    if (data.startDate.hours(from: currTime) > Int(task.attentionSpan)){
                        let event = NSEntityDescription.insertNewObject(forEntityName: "EventData", into: managedObjectContext) as! EventData
                        event.startDate = currTime
                        event.endDate = Calendar.current.date(byAdding: .hour, value: Int(task.attentionSpan), to: currTime)!
                        event.text = task.name
                        task.addToEvents(event)
                        print(currTime)
                        numOfEventsToSchedule -= 1
                        break
                    } else {
                        //lets add an hour too
                        currTime = data.endDate
                    }
                }
                
            } catch {
                print("Failed")
            }
            
            //Increment currDay and earliestTime
            currDay = Calendar.current.date(byAdding: .day, value: 1, to: currDay)!
            earliestTime = Calendar.current.date(byAdding: .day, value: 1, to: earliestTime!)
        }
        
        
        return true
    }
}
