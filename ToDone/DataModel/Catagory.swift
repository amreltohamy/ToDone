//
//  Catagory.swift
//  ToDone
//
//  Created by MacBook on 10/16/20.
//

import Foundation
import RealmSwift

class Categories: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color : String = "FFFFFF"
    let items = List<Item>()
    
}
 
