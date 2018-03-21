//
//  Patients+CoreDataProperties.swift
//  Medilexis
//
//  Created by mac on 25/01/2018.
//  Copyright © 2018 NX3. All rights reserved.
//
//

import Foundation
import CoreData


extension Patients {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Patients> {
        return NSFetchRequest<Patients>(entityName: "Patients")
    }

    @NSManaged public var address: String?
    @NSManaged public var dateBirth: String?
    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var id: String?
    @NSManaged public var idCardImage: String?
    @NSManaged public var lastName: String?
    @NSManaged public var medicalNo: String?
    @NSManaged public var phone: String?
    @NSManaged public var profileImage: String?
    @NSManaged public var userID: Int32

}
