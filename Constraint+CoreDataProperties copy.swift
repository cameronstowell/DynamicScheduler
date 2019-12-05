//
//  Constraint+CoreDataProperties.swift
//  
//
//  Created by Noah Brumfield on 12/1/19.
//
//

import Foundation
import CoreData


extension Constraint {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Constraint> {
        return NSFetchRequest<Constraint>(entityName: "Constraint")
    }

    @NSManaged public var name: String?

}
