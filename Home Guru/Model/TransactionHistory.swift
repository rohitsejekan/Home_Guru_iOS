//
//  TransactionHistory.swift
//  Home Guru
//
//  Created by Priya Vernekar on 23/04/21.
//  Copyright © 2021 Priya Vernekar. All rights reserved.
//

import Foundation
import SwiftyJSON

struct TransactionHistory{
    var dates: String = ""
    var _id: String = ""
    var points: String = ""
    init(json: JSON){
        self._id = json["_id"].stringValue
        self.dates = json["date"].stringValue
        self.points = json["points"].stringValue
        
    }
}
