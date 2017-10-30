//
//  Encounter+CoreDataProperties.swift
//  Medilexis
//
//  Created by iOS Developer on 15/08/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import Foundation
import CoreData


extension Encounter {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Encounter> {
        return NSFetchRequest<Encounter>(entityName: "Encounter")
    }

    @NSManaged public var appointmentID: String?
    @NSManaged public var ccRecordingName: String?
    @NSManaged public var ccRecordingURL: String?
    @NSManaged public var ccServerURL: String?
    @NSManaged public var ccTranscription: String?
    @NSManaged public var cptCode: String?
    @NSManaged public var cptDescription: String?
    @NSManaged public var dispense: String?
    @NSManaged public var dose: String?
    @NSManaged public var dxCode: String?
    @NSManaged public var dxDescription: String?
    @NSManaged public var endDate: String?
    @NSManaged public var hpiRecordingName: String?
    @NSManaged public var hpiRecordingURL: String?
    @NSManaged public var hpiServerURL: String?
    @NSManaged public var hpiTranscription: String?
    @NSManaged public var hxRecordingName: String?
    @NSManaged public var hxRecordingURL: String?
    @NSManaged public var hxServerURL: String?
    @NSManaged public var hxTranscription: String?
    @NSManaged public var image1: NSData?
    @NSManaged public var image2: NSData?
    @NSManaged public var length: String?
    @NSManaged public var letterRecordingName: String?
    @NSManaged public var letterRecordingURL: String?
    @NSManaged public var letterServerURL: String?
    @NSManaged public var letterTranscription: String?
    @NSManaged public var medicineName: String?
    @NSManaged public var planRecordingName: String?
    @NSManaged public var planRecordingURL: String?
    @NSManaged public var planServerURL: String?
    @NSManaged public var planTranscription: String?
    @NSManaged public var recordingType1: String?
    @NSManaged public var recordingType2: String?
    @NSManaged public var recordingType3: String?
    @NSManaged public var recordingType4: String?
    @NSManaged public var recordingType5: String?
    @NSManaged public var recordingTypeLetter: String?
    @NSManaged public var rosRecordingName: String?
    @NSManaged public var rosRecordingURL: String?
    @NSManaged public var rosServerURL: String?
    @NSManaged public var rosTranscription: String?
    @NSManaged public var route: String?
    @NSManaged public var serverImage1: String?
    @NSManaged public var serverImage2: String?
    @NSManaged public var startDate: String?
    @NSManaged public var times: String?
    @NSManaged public var total: String?
    @NSManaged public var type1: String?
    @NSManaged public var type2: String?
    @NSManaged public var unit: String?
    @NSManaged public var userID: Int32
    @NSManaged public var weight: String?

}
