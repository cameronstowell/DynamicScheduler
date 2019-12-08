//
//  CalendarImporter.swift
//  DynamicScheduler
//
//  Created by Cameron Stowell on 12/6/19.
//  Copyright © 2019 Cameron Stowell. All rights reserved.
//

import Foundation
import CoreData
import EventKit

class CalendarImporter {
    
    var hasAccess : Bool
    var container : NSPersistentContainer
    
    init(container:NSPersistentContainer) {
        self.hasAccess = false
        self.container = container
    }
    
    func importCalendar() {
        
        while(EKEventStore.authorizationStatus(for: .event) != .authorized){
            self.requestCalendarAccess()
        }

        let eventStore = EKEventStore()
        let calendars = eventStore.calendars(for: .event)
        
        //Pulls events within the surrounding month from Classes calendar
        for calendar in calendars {
            print("here")
            if calendar.title == "Classes"{
                let oneMonthAgo = NSDate(timeIntervalSinceNow: -30*24*3600)
                let oneMonthAfter = NSDate(timeIntervalSinceNow: +30*24*3600)

                let predicate = eventStore.predicateForEvents(withStart: oneMonthAgo as Date, end: oneMonthAfter as Date, calendars: [calendar])

                let events = eventStore.events(matching: predicate)

                for event in events {
                    print(event)
                    print("hows that event above me")
                    let eventData = NSEntityDescription.insertNewObject(forEntityName: "EventData", into: container.viewContext) as! EventData
                    eventData.text = event.title
                    eventData.startDate = event.startDate
                    eventData.endDate = event.endDate
                }
            }
        }
        
        //Save after adding all those events
        do {
            try container.viewContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }

    }
    
    //Prompts user for access to their calendar and sets hasAccess to reflect the app's current access level
    func requestCalendarAccess() {
        let eventStore = EKEventStore()
        switch EKEventStore.authorizationStatus(for: .event){
            
            case .authorized:
                self.hasAccess = true;
            
            case .notDetermined:
                eventStore.requestAccess(to: .event, completion: {
                    (granted: Bool, error: Error?) -> Void in
                    if granted {
                        self.hasAccess = true;
                    } else {
                        self.hasAccess = false;
                    }
                })
                
            default:
                print("Access already determined.")
        }
    }
    
}
