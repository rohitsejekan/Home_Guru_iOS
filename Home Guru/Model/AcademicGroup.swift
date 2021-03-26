//
//  AcademicGroup.swift
//  Home Guru
//
//  Created by Priya Vernekar on 26/03/21.
//  Copyright © 2021 Priya Vernekar. All rights reserved.
//

import Foundation
import SwiftyJSON
struct AcademicGroup {
    var groupName: String = ""
    var has_board: String = ""
    var _id: String = ""
    init(json: JSON) {
        self.groupName = json["groupName"].stringValue
        self._id = json["_id"].stringValue
        self.has_board = json["has_board"].stringValue
    }
}

