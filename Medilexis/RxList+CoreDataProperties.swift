//
//  RxList+CoreDataProperties.swift
//  Medilexis
//
//  Created by iOS Developer on 26/05/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import Foundation
import CoreData


extension RxList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RxList> {
        return NSFetchRequest<RxList>(entityName: "RxList");
    }

    @NSManaged public var medicineID: String?
    @NSManaged public var medicineName: String?

}
