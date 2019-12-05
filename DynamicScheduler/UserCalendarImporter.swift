//
//  UserCalendarImporter.swift
//  DynamicScheduler
//
//  Created by Cameron Stowell on 12/3/19.
//  Copyright © 2019 Cameron Stowell. All rights reserved.
//

import Foundation
import CoreData

public class UserCalendarImporter {
    
    var container: NSPersistentContainer!
    
    init(container: NSPersistentContainer){
        self.container = container
    }
}
