//
//  Weights+CoreDataProperties.swift
//  
//
//  Created by Kranthi Chinnakotla on 12/15/16.
//
//

import Foundation
import CoreData


extension Weights {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Weights> {
        return NSFetchRequest<Weights>(entityName: "Weights");
    }

    @NSManaged public var weights: String?

}
