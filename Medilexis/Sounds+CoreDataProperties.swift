//
//  Sounds+CoreDataProperties.swift
//  Medilexis
//
//  Created by iOS Developer on 02/08/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import Foundation
import CoreData


extension Sounds {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sounds> {
        return NSFetchRequest<Sounds>(entityName: "Sounds")
    }

    @NSManaged public var appointmentID: String?
    @NSManaged public var recordingName: String?
    @NSManaged public var recordingURL: String?
    @NSManaged public var transcription: String?
    @NSManaged public var type: String?

}
