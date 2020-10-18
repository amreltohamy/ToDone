//
//  Item.swift
//  ToDone
//
//  Created by MacBook on 10/16/20.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var color : String = "FFFFFF"
    @objc dynamic var done:Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCatagory = LinkingObjects(fromType: Categories.self, property: "items")
}
