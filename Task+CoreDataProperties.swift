//
//  Task+CoreDataProperties.swift
//  DynamicScheduler
//
//  Created by Cameron Stowell on 12/2/19.
//  Copyright © 2019 Cameron Stowell. All rights reserved.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var endDate: Date?
    @NSManaged public var estimated_length: Double
    @NSManaged public var name: String?
    @NSManaged public var startDate: Date?
    @NSManaged public var user_notes: String?
    @NSManaged public var events: NSSet?
    @NSManaged public var project: Project?

}

// MARK: Generated accessors for events
extension Task {

    @objc(addEventsObject:)
    @NSManaged public func addToEvents(_ value: EventData)

    @objc(removeEventsObject:)
    @NSManaged public func removeFromEvents(_ value: EventData)

    @objc(addEvents:)
    @NSManaged public func addToEvents(_ values: NSSet)

    @objc(removeEvents:)
    @NSManaged public func removeFromEvents(_ values: NSSet)

}
