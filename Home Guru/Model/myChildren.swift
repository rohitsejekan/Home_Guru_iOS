//
//  myChildren.swift
//  Home Guru
//
//  Created by Priya Vernekar on 19/04/21.
//  Copyright © 2021 Priya Vernekar. All rights reserved.
//

import Foundation
import SwiftyJSON
struct myChildren{
    var _id: String = ""
    var name: String = ""
    var dob: String = ""
    var board: String = ""
    var stdClass: String = ""
    init(json: JSON) {
        self._id = json["_id"].stringValue
        self.name = json["name"].stringValue
        self.dob = json["dob"].stringValue
        self.board = json["board"].stringValue
        self.stdClass = json["stdClass"].stringValue
    }
}
