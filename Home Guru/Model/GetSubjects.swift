//
//  GetSubjects.swift
//  Home Guru
//
//  Created by Priya Vernekar on 26/03/21.
//  Copyright © 2021 Priya Vernekar. All rights reserved.
//

import Foundation
import SwiftyJSON
struct GetSubjects {
    var title: String = ""
    //var _id: String = ""
    init(json: JSON) {
        self.title = json["title"].stringValue
    }
}
