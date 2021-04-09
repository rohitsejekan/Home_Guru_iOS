//
//  GetGuruProfile.swift
//  Home Guru
//
//  Created by Priya Vernekar on 02/04/21.
//  Copyright © 2021 Priya Vernekar. All rights reserved.
//

import Foundation
import SwiftyJSON
struct GetGuruProfile{
    var name: String = ""
    var languagesKnown: String = ""
    var aboutGuru: String = ""
    var highQualification: String = ""
    var yearOfExperience: String = ""
    var ratings: String = ""
    var guruSubjectDetails = [guruSubject]()
    init(json: JSON) {
        self.name = json["name"].stringValue
        self.highQualification = json["highQualification"].stringValue
        self.languagesKnown = json["languagesKnown"].stringValue
        self.yearOfExperience = json["yearOfExperience"].stringValue
        self.ratings = json["ratings"].stringValue
        self.aboutGuru = json["aboutGuru"].stringValue
        for arr in json["subjects"].arrayValue{
            self.guruSubjectDetails.append(guruSubject(gSubject: arr))
        }
    }
}

struct guruSubject{
    var guruPreferedSubject: preferedSubject?
    var hourlyFees = [hourlyCompensation]()
    init(gSubject: JSON) {
        self.guruPreferedSubject = preferedSubject(preSubject: gSubject["preferedSubject"])
        for arr in gSubject["hourlyCompensation"].arrayValue{
            self.hourlyFees.append(hourlyCompensation(hourJson: arr))
        }
    }
}
struct hourlyCompensation{
    var facultyCharges: String = ""
    var classType: String = ""
    init(hourJson: JSON) {
        self.facultyCharges = hourJson["facultyCharges"].stringValue
        self.classType = hourJson["classType"].stringValue
    }
}
struct preferedSubject{
    var _id: String = ""
    var subjectName: String = ""
    init(preSubject: JSON){
        self._id = preSubject["_id"].stringValue
        self.subjectName = preSubject["subjectName"].stringValue
        
    }
    
}
