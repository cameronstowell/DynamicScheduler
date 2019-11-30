//
//  Task+CoreDataProperties.swift
//  DynamicScheduler
//
//  Created by Cameron Stowell on 11/27/19.
//  Copyright © 2019 Cameron Stowell. All rights reserved.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var name: String?
    @NSManaged public var start_date: Date?
    @NSManaged public var end_date: Date?
    @NSManaged public var user_notes: String?
    @NSManaged public var estimated_length: Double
    @NSManaged public var project: Project?

}
