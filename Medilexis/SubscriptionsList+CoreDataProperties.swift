//
//  SubscriptionsList+CoreDataProperties.swift
//  Medilexis
//
//  Created by iOS Developer on 04/08/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import Foundation
import CoreData


extension SubscriptionsList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SubscriptionsList> {
        return NSFetchRequest<SubscriptionsList>(entityName: "SubscriptionsList")
    }

    @NSManaged public var amount: String?
    @NSManaged public var completed: Bool
    @NSManaged public var noOfEncounters: String?
    @NSManaged public var section: String?
    @NSManaged public var subscriptionID: String?

}
