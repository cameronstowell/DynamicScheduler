//
//  EventData+CoreDataProperties.swift
//  DynamicScheduler
//
//  Created by Cameron Stowell on 12/5/19.
//  Copyright © 2019 Cameron Stowell. All rights reserved.
//
//

import Foundation
import CoreData


extension EventData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<EventData> {
        return NSFetchRequest<EventData>(entityName: "EventData")
    }

    @NSManaged public var endDate: Date
    @NSManaged public var startDate: Date
    @NSManaged public var text: String
    @NSManaged public var constraint: Constraint?
    @NSManaged public var task: Task?

}
