//
//  Item.swift
//  ToDone
//
//  Created by MacBook on 10/12/20.
//

import Foundation

class Item :Encodable ,Decodable {
    var title:String = ""
    var done:Bool = false
    
}
