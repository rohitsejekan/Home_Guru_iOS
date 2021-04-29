//
//  NonAcademic.swift
//  Home Guru
//
//  Created by Priya Vernekar on 21/04/21.
//  Copyright © 2021 Priya Vernekar. All rights reserved.
//

import Foundation
import SwiftyJSON
struct NonAcademic {
    var groupName: String = ""
    var programType: String = ""
    var _id: String = ""
    var has_board: String = ""
    init(json: JSON) {
        self.groupName = json["groupName"].stringValue
        self._id = json["_id"].stringValue
        self.programType = json["programType"].stringValue
        self.has_board = json["has_board"].stringValue
    }
}
