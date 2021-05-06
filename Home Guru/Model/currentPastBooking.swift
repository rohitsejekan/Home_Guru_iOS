//
//  currentPastBooking.swift
//  Home Guru
//
//  Created by Priya Vernekar on 26/04/21.
//  Copyright © 2021 Priya Vernekar. All rights reserved.
//

import Foundation
import SwiftyJSON
struct currentPastBooking{
    var subject = [subjectInfo]()
    var faculty: facultyInformation?
    var date: String = ""
    init(json: JSON){
        self.faculty = facultyInformation(fi: json["faculty"])
        self.date = json["date"].stringValue
        for arr in json["subject"].arrayValue{
            self.subject.append(subjectInfo(sd: arr))
        }
        
    }
}
struct subjectInfo {
    var subjectName: String = ""
    init(sd: JSON) {
        self.subjectName = sd["subjectName"].stringValue
    }
}
struct facultyInformation{
    var name: String = ""
    var profilePic: profilepic?
    init(fi: JSON) {
        self.name = fi["name"].stringValue
        self.profilePic = profilepic(pc: fi["profilePic"])
    }
}
struct profilepic{
    var image_url: String = ""
    init(pc: JSON){
        self.image_url = pc["image_url"].stringValue
    }
}
