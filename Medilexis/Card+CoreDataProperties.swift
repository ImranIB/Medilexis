//
//  Card+CoreDataProperties.swift
//  Medilexis
//
//  Created by iOS Developer on 04/08/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import Foundation
import CoreData


extension Card {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Card> {
        return NSFetchRequest<Card>(entityName: "Card")
    }

    @NSManaged public var cardNumber: String?
    @NSManaged public var month: String?
    @NSManaged public var year: String?
    @NSManaged public var cvv: String?
    @NSManaged public var userID: Int32

}
