//
//  Patients+CoreDataProperties.swift
//  Medilexis
//
//  Created by iOS Developer on 07/07/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import Foundation
import CoreData


extension Patients {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Patients> {
        return NSFetchRequest<Patients>(entityName: "Patients");
    }

    @NSManaged public var id: String?
    @NSManaged public var firstName: String?
    @NSManaged public var lastName: String?
    @NSManaged public var dateBirth: String?
    @NSManaged public var phone: String?
    @NSManaged public var email: String?
    @NSManaged public var address: String?
    @NSManaged public var userID: Int32

}
