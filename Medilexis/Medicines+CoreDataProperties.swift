//
//  Medicines+CoreDataProperties.swift
//  Medilexis
//
//  Created by iOS Developer on 24/05/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import Foundation
import CoreData


extension Medicines {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Medicines> {
        return NSFetchRequest<Medicines>(entityName: "Medicines");
    }

    @NSManaged public var medicineID: String?
    @NSManaged public var medicineName: String?
    @NSManaged public var patientID: String?
    @NSManaged public var userID: Int32
    @NSManaged public var dose: String?
    @NSManaged public var unit: String?
    @NSManaged public var weight: String?
    @NSManaged public var times: String?
    @NSManaged public var length: String?
    @NSManaged public var dispense: String?
    @NSManaged public var route: String?
    @NSManaged public var endDate: String?
    @NSManaged public var startDate: String?
    @NSManaged public var notes: String?

}
