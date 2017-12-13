//
//  FilterAppointments+CoreDataProperties.swift
//  Medilexis
//
//  Created by iOS Developer on 18/08/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import Foundation
import CoreData


extension FilterAppointments {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FilterAppointments> {
        return NSFetchRequest<FilterAppointments>(entityName: "FilterAppointments")
    }

    @NSManaged public var firstname: String?
    @NSManaged public var lastName: String?
    @NSManaged public var endDate: NSDate?
    @NSManaged public var startDate: NSDate?
    @NSManaged public var userID: Int32

}
