//
//  Item+CoreDataProperties.swift
//  ToDone
//
//  Created by MacBook on 10/13/20.
//
//

import Foundation
import CoreData


extension Item {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Item> {
        return NSFetchRequest<Item>(entityName: "Item")
    }

    @NSManaged public var done: Bool
    @NSManaged public var title: String?
    @NSManaged public var parentCatagory: Categories?

}

extension Item : Identifiable {

}
