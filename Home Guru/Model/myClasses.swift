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
    var timeSlotTo: String = ""
    var is_demo: String = ""
    var _id: String = ""
    var classType: String = ""
    var status: String = ""
    init(json: JSON) {
        self.student = studentDetails(sDetails: json["student"])
        self.classType = json["classType"].stringValue
        self.scheduleDate = json["date"].stringValue
        self.status = json["status"].stringValue
        self.is_demo = json["is_demo"].stringValue
        self._id = json["_id"].stringValue
        self.timeSlotTo = json["timeSlotTo"].stringValue
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
    var ratings: String = ""
    var languagesKnown: String = ""
    var facultyPic: facultyProfile
    var subjects = [facultySubjectDetails]()
    init(fJson: JSON){
        for arr in fJson["subjects"].arrayValue{
            self.subjects.append(facultySubjectDetails(facultySubDetails: arr))
        }
        self.facultyPic = facultyProfile(fp: fJson["profilePic"])
        self.ratings = fJson["ratings"].stringValue
        self._id = fJson["_id"].stringValue
        self.name = fJson["name"].stringValue
    }
}

struct facultySubjectDetails{
    var hourlyCompensation = [hourlyCompensationDetails]()
    var profilePic: facultyProfile?
    init(facultySubDetails: JSON){
        //self.profilePic = facultyProfile(fp: facultySubDetails["profilePic"])
        for arr in facultySubDetails["hourlyCompensation"].arrayValue{
            self.hourlyCompensation.append(hourlyCompensationDetails(hourlyFare: arr))
        }
    }
}
struct facultyProfile{
    var image_url: String = ""
    init(fp: JSON){
        self.image_url = fp["image_url"].stringValue
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
