//
//  Users+CoreDataProperties.swift
//  Medilexis
//
//  Created by iOS Developer on 04/08/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import Foundation
import CoreData


extension Users {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Users> {
        return NSFetchRequest<Users>(entityName: "Users")
    }

    @NSManaged public var footer: String?
    @NSManaged public var heading: String?
    @NSManaged public var logo: NSData?
    @NSManaged public var subHeading: String?
    @NSManaged public var userID: Int32
    @NSManaged public var encounters: Int32

}
