//
//  Constraint+CoreDataProperties.swift
//  DynamicScheduler
//
//  Created by Cameron Stowell on 11/27/19.
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
    
}
