//
//  Task.swift
//  REST API Sails.js
//
//  Created by admin on 1/8/21.
//

import Foundation

struct Task : Decodable {
    
    var id : Int
    var title : String
    var description : String
}
