//
//  WebsiteDetails+CoreDataProperties.swift
//  PasswordKeeper
//
//  Created by Nitin Bhatt on 9/13/20.
//  Copyright © 2020 Test. All rights reserved.
//
//

import Foundation
import CoreData


extension WebsiteDetails {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WebsiteDetails> {
        return NSFetchRequest<WebsiteDetails>(entityName: "WebsiteDetails")
    }

    @NSManaged public var name: String?
    @NSManaged public var url: String?
    @NSManaged public var username: String?
    @NSManaged public var password: String?

}
