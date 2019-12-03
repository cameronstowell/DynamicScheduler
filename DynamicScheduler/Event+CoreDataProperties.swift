//
//  Event+CoreDataProperties.swift
//  DynamicScheduler
//
//  Created by Cameron Stowell on 12/2/19.
//  Copyright © 2019 Cameron Stowell. All rights reserved.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var startDate: Date?
    @NSManaged public var endDate: Date?
    @NSManaged public var text: String?
    @NSManaged public var task: Task?
    @NSManaged public var constraint: Constraint?

}
