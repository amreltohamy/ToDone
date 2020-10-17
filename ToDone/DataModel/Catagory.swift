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
    let items = List<Item>()
    
}
 
