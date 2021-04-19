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
    var student: studentDetails?
    var subject = [subjectDetails]()
    var scheduleDate: String = ""
    var timeSlotFrom: String = ""
    var _id: String = ""
    var classType: String = ""
    init(json: JSON) {
        self.student = studentDetails(sDetails: json["student"])
        self.classType = json["classType"].stringValue
        self.scheduleDate = json["date"].stringValue
        self._id = json["_id"].stringValue
        self.timeSlotFrom = json["timeSlotFrom"].stringValue
        self.faculty = facultyDetails(fJson: json["faculty"])
        for arr in json["subject"].arrayValue{
            self.subject.append(subjectDetails(subDetails: arr))
        }
    }
}
struct studentDetails{
    var _id: String = ""
    init(sDetails: JSON) {
        self._id = sDetails["_id"].stringValue
    }
}
struct facultyDetails{
    var name: String = ""
    var _id: String = ""
    var subjects = [facultySubjectDetails]()
    init(fJson: JSON){
        for arr in fJson["subjects"].arrayValue{
            self.subjects.append(facultySubjectDetails(facultySubDetails: arr))
        }
        self._id = fJson["_id"].stringValue
        self.name = fJson["name"].stringValue
    }
}

struct facultySubjectDetails{
    var hourlyCompensation = [hourlyCompensationDetails]()
    init(facultySubDetails: JSON){
        for arr in facultySubDetails["hourlyCompensation"].arrayValue{
            self.hourlyCompensation.append(hourlyCompensationDetails(hourlyFare: arr))
        }
    }
}
struct hourlyCompensationDetails{
    var facultyCharges: String = ""
    init(hourlyFare: JSON){
        self.facultyCharges = hourlyFare["facultyCharges"].stringValue
    }
}
struct subjectDetails{
    var _id: String = ""
    var subjectName: String = ""
    init(subDetails: JSON){
        self._id = subDetails["_id"].stringValue
        self.subjectName = subDetails["subjectName"].stringValue
    }
}
