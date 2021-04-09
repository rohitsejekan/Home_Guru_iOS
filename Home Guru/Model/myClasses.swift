//
//  myClasses.swift
//  Home Guru
//
//  Created by Priya Vernekar on 08/04/21.
//  Copyright © 2021 Priya Vernekar. All rights reserved.
//

import Foundation
import SwiftyJSON

struct myClasses{
    var faculty: facultyDetails?
    var subject = [subjectDetails]()
    var scheduleDate: String = ""
    var timeSlotFrom: String = ""
    init(json: JSON) {
        self.scheduleDate = json["date"].stringValue
        self.timeSlotFrom = json["timeSlotFrom"].stringValue
        self.faculty = facultyDetails(fJson: json["faculty"])
        for arr in json["subject"].arrayValue{
            self.subject.append(subjectDetails(subDetails: arr))
        }
    }
}

struct facultyDetails{
    var name: String = ""
    init(fJson: JSON){
        self.name = fJson["name"].stringValue
    }
}

struct subjectDetails{
    var subjectName: String = ""
    init(subDetails: JSON){
        self.subjectName = subDetails["subjectName"].stringValue
    }
}
