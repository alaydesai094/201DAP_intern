//
//  RestorePrctice+CoreDataProperties.swift
//  CTC
//
//  Created by Aesha Patel on 2019-06-16.
//  Copyright © 2019 Nirav Bavishi. All rights reserved.
//

import Foundation
import CoreData

extension RestorePractice{
    @nonobjc public class func fetchRequest() -> NSFetchRequest<RestorePractice> {
        return NSFetchRequest<RestorePractice>(entityName: "RestorePractice")
    }
    
    @NSManaged public var practice_name: String?
    @NSManaged public var td: Int32
    @NSManaged public var dss: Int32
    @NSManaged public var date: NSDate?
    @NSManaged public var com_del_flag: Bool
}
