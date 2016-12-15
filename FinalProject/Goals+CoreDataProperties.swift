//
//  Goals+CoreDataProperties.swift
//  FinalProject
//
//  Created by Kranthi Chinnakotla on 11/27/16.
//  Copyright © 2016 edu.uncc.cs6010. All rights reserved.
//

import Foundation
import CoreData


extension Goals {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Goals> {
        return NSFetchRequest<Goals>(entityName: "Goals");
    }

    @NSManaged public var userName: String?
    @NSManaged public var goal: String?

}
