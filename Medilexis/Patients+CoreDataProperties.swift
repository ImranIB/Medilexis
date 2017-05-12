//
//  Patients+CoreDataProperties.swift
//  Medilexis
//
//  Created by iOS Developer on 10/05/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import Foundation
import CoreData


extension Patients {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Patients> {
        return NSFetchRequest<Patients>(entityName: "Patients");
    }

    @NSManaged public var dateBirth: String?
    @NSManaged public var dateSchedule: NSDate?
    @NSManaged public var isRecording: Bool
    @NSManaged public var isTranscribed: Bool
    @NSManaged public var patientID: String?
    @NSManaged public var patientName: String?
    @NSManaged public var type: String?
    @NSManaged public var userID: Int32
    @NSManaged public var visitType: String?
    @NSManaged public var recordingStatus: String?
    @NSManaged public var sounds: NSSet?

}

// MARK: Generated accessors for sounds
extension Patients {

    @objc(addSoundsObject:)
    @NSManaged public func addToSounds(_ value: Sounds)

    @objc(removeSoundsObject:)
    @NSManaged public func removeFromSounds(_ value: Sounds)

    @objc(addSounds:)
    @NSManaged public func addToSounds(_ values: NSSet)

    @objc(removeSounds:)
    @NSManaged public func removeFromSounds(_ values: NSSet)

}
