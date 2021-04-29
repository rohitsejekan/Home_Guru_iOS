//
//  getGuruSubject.swift
//  Home Guru
//
//  Created by Priya Vernekar on 01/04/21.
//  Copyright © 2021 Priya Vernekar. All rights reserved.
//

import Foundation
import SwiftyJSON

struct getGurusubject{
    var _id : String = ""
    var name: String = ""
    var languages: String = ""
    var guruSubjectDetail = [guruSubjectDetails]()
    var profilePic: facultyImage?
    init(json: JSON) {
        self.profilePic = facultyImage(fi: json["profilePic"])
        self._id = json["_id"].stringValue
        self.name = json["name"].stringValue
        self.languages = json["languagesKnown"].stringValue
        for arr in json["subjects"].arrayValue{
            self.guruSubjectDetail.append(guruSubjectDetails(gSub: arr))
        }
    }
}

struct facultyImage{
    var profile: String = ""
    init(fi: JSON){
        self.profile = fi["image_url"].stringValue
    }
}

struct guruSubjectDetails{
    var preferedSubjectData = [preferedSubjectDetails]()
    var hourlyFees = [hourlyCompensationSubject]()
    init(gSub: JSON) {
        for arr1 in gSub["preferedSubjectData"].arrayValue{
            self.preferedSubjectData.append(preferedSubjectDetails(preSubject: arr1))
        }
        for arr in gSub["hourlyCompensation"].arrayValue{
            self.hourlyFees.append(hourlyCompensationSubject(hourJson: arr))
        }
    }
}
struct hourlyCompensationSubject{
    var facultyCharges: String = ""
    var classType: String = ""
    init(hourJson: JSON) {
        self.facultyCharges = hourJson["facultyCharges"].stringValue
        self.classType = hourJson["classType"].stringValue
    }
}
struct preferedSubjectDetails{
    var _id: String = ""
    var subjectName: String = ""
    init(preSubject: JSON){
        self._id = preSubject["_id"].stringValue
        self.subjectName = preSubject["subjectName"].stringValue
        
    }
    
}
