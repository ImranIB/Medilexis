//
//  Diagnostics+CoreDataProperties.swift
//  Medilexis
//
//  Created by iOS Developer on 31/05/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import Foundation
import CoreData


extension Diagnostics {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Diagnostics> {
        return NSFetchRequest<Diagnostics>(entityName: "Diagnostics");
    }

    @NSManaged public var code: String?
    @NSManaged public var diagnosticID: String?
    @NSManaged public var discription: String?
    @NSManaged public var patientID: String?
    @NSManaged public var type: String?
    @NSManaged public var userID: Int32

}
