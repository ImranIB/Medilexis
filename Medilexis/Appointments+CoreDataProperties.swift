//
//  Appointments+CoreDataProperties.swift
//  Medilexis
//
//  Created by iOS Developer on 24/08/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import Foundation
import CoreData


extension Appointments {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Appointments> {
        return NSFetchRequest<Appointments>(entityName: "Appointments")
    }

    @NSManaged public var address: String?
    @NSManaged public var anotherImage: NSData?
    @NSManaged public var appointmentID: String?
    @NSManaged public var dateBirth: String?
    @NSManaged public var dateSchedule: NSDate?
    @NSManaged public var email: String?
    @NSManaged public var firstName: String?
    @NSManaged public var image: NSData?
    @NSManaged public var isRecording: Bool
    @NSManaged public var isTranscribed: Bool
    @NSManaged public var isUploading: Bool
    @NSManaged public var lastName: String?
    @NSManaged public var phone: String?
    @NSManaged public var recordingStatus: String?
    @NSManaged public var type: String?
    @NSManaged public var userID: Int32
    @NSManaged public var visitType: String?
    @NSManaged public var appointmentTime: String?

}
