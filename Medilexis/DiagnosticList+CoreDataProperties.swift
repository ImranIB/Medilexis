//
//  DiagnosticList+CoreDataProperties.swift
//  Medilexis
//
//  Created by iOS Developer on 08/06/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import Foundation
import CoreData


extension DiagnosticList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<DiagnosticList> {
        return NSFetchRequest<DiagnosticList>(entityName: "DiagnosticList");
    }

    @NSManaged public var code: String?
    @NSManaged public var codeID: String?
    @NSManaged public var name: String?
    @NSManaged public var type: String?

}
