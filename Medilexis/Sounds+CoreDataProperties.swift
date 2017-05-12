//
//  Sounds+CoreDataProperties.swift
//  Medilexis
//
//  Created by iOS Developer on 10/05/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import Foundation
import CoreData


extension Sounds {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Sounds> {
        return NSFetchRequest<Sounds>(entityName: "Sounds");
    }

    @NSManaged public var patientID: String?
    @NSManaged public var recordingName: String?
    @NSManaged public var recordingURL: String?
    @NSManaged public var transcription: String?
    @NSManaged public var type: String?
    @NSManaged public var patients: Patients?

}
