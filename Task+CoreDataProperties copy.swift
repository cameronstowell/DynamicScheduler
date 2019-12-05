//
//  Task+CoreDataProperties.swift
//  
//
//  Created by Noah Brumfield on 12/1/19.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var end_date: NSDate?
    @NSManaged public var estimated_length: Double
    @NSManaged public var name: String?
    @NSManaged public var start_date: NSDate?
    @NSManaged public var user_notes: String?
    @NSManaged public var project: Project?

}
