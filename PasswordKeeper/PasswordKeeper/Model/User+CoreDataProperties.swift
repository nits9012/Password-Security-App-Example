//
//  User+CoreDataProperties.swift
//  PasswordKeeper
//
//  Created by Nitin Bhatt on 9/21/20.
//  Copyright © 2020 Test. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var id: Int16
    @NSManaged public var password: String?

}
