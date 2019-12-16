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
        var earliestTime = Calendar.current.date(bySettingHour: task.earliestTime.component(.hour), minute: task.earliestTime.component(.minute), second: 0, of: currDay)
        
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
            let sort = NSSortDescriptor(key: #keyPath(EventData.startDate), ascending: true)
            request.sortDescriptors = [sort]
            
            do {
                let result = try managedObjectContext.fetch(request)
                var currTime = earliestTime!
                
                //Free day! schedule as early as possible
                if(result.isEmpty){
                    buildEvent(currTime: currTime)
                    numOfEventsToSchedule -= 1
                    break
                }
                
                for data in result as! [EventData] {
                    if (data.startDate.hours(from: currTime) > Int(task.attentionSpan)){
                        buildEvent(currTime: currTime)
                        numOfEventsToSchedule -= 1
                        break
                    } else {
                        currTime = Calendar.current.date(byAdding: .minute, value: 15, to: data.endDate)!
                    }
                }
                
                //out of events, check how much free time until midnight
                let midnight = Calendar.current.startOfDay(for: Calendar.current.date(byAdding: .day, value: 1, to: currDay)!)
                if (midnight.hoursLater(than: currTime) >= Int(task.attentionSpan)){
                    buildEvent(currTime: currTime)
                    numOfEventsToSchedule -= 1
                    break
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
    
    func buildEvent(currTime : Date){
        let event = NSEntityDescription.insertNewObject(forEntityName: "EventData", into: managedObjectContext) as! EventData
        event.startDate = currTime
        event.endDate = Calendar.current.date(byAdding: .hour, value: Int(task.attentionSpan), to: currTime)!
        event.text = task.name
        task.addToEvents(event)
    }
}
