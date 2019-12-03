//
//  Constraint+CoreDataProperties.swift
//  DynamicScheduler
//
//  Created by Cameron Stowell on 12/2/19.
//  Copyright © 2019 Cameron Stowell. All rights reserved.
//
//

import Foundation
import CoreData


extension Constraint {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Constraint> {
        return NSFetchRequest<Constraint>(entityName: "Constraint")
    }

    @NSManaged public var name: String?
    @NSManaged public var events: NSSet?

}

// MARK: Generated accessors for events
extension Constraint {

    @objc(addEventsObject:)
    @NSManaged public func addToEvents(_ value: Event)

    @objc(removeEventsObject:)
    @NSManaged public func removeFromEvents(_ value: Event)

    @objc(addEvents:)
    @NSManaged public func addToEvents(_ values: NSSet)

    @objc(removeEvents:)
    @NSManaged public func removeFromEvents(_ values: NSSet)

}
