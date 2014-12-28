//
//  MyVacationTracker.swift
//  MyVacationTracker
//
//  Created by Kimberly Barnes on 12/27/14.
//  Copyright (c) 2014 DKMMBarnes, LLC. All rights reserved.
//

import Foundation
import CoreData

class MyVacationTracker: NSManagedObject {

    @NSManaged var date: NSDate
    @NSManaged var hours: NSDecimalNumber
    @NSManaged var comments: String

}
