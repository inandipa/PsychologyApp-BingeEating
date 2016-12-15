//
//  ProfileImage+CoreDataProperties.swift
//  FinalProject
//
//  Created by Kranthi Chinnakotla on 11/19/16.
//  Copyright © 2016 edu.uncc.cs6010. All rights reserved.
//

import Foundation
import CoreData


extension ProfileImage {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProfileImage> {
        return NSFetchRequest<ProfileImage>(entityName: "ProfileImage");
    }

    @NSManaged public var imageData: NSData?

}
