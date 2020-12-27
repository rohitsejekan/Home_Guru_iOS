//
//  ParentDetails.swift
//  Home Guru
//
//  Created by Priya Vernekar on 16/12/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import Foundation

struct PictureDetails {
    var image_url : String
    var image_name : String
    var image_type : String
    var image_timestamp : Int64
}

struct Student {
    var _id : String
    var name : String
    var program : String
    var dob : String
    var profilePic : PictureDetails?
    var birthCertificate : PictureDetails?
}

struct Location {
    var coordinates : [Double]
}

struct ResidentialAddress {
    var _id : String
    var location : Location
    var pincode : Int
    var houseNo : String
    var area : String
    var city : String
    var state : String
    var landmark : String
    
    mutating func saveData(data: [String:Any]) {
        
    }
}

class ParentDetails {
    
    static var parentDetails : ParentDetails = ParentDetails()
    
    var token : String
    var approvalStatus : Bool
    var currentPoints: Int
    var _id : String
    var name : String
    var mobileNo : String
    var email : String
    var residentalAddress : ResidentialAddress
    var student : [Student]
    var createdAt : String
    var updatedAt : String
    var password : String
    var __v : Int
    
    private init(){
        self.token = ""
        self.approvalStatus = false
        self._id = ""
        self.name = ""
        self.mobileNo = ""
        self.email = ""
        self.residentalAddress = ResidentialAddress(_id: "", location: Location(coordinates: []), pincode: 0, houseNo: "", area: "", city: "", state: "", landmark: "")
        self.student = []
        self.createdAt = ""
        self.updatedAt = ""
        self.password = ""
        self.currentPoints = 0
        self.__v = 0
    }
    
    func saveData(data: [String:Any], token: String) {
        ParentDetails.parentDetails.token = token
        
        if let approval_status = data["approval_status"] as? Bool, let _id = data["_id"] as? String, let name = data["name"] as? String, let mobileNo = data["mobileNo"] as? String, let email = data["email"] as? String, let currentPoints = data["currentPoints"] as? Int {
            ParentDetails.parentDetails.approvalStatus = approval_status
            ParentDetails.parentDetails._id = _id
            ParentDetails.parentDetails.name = name
            ParentDetails.parentDetails.mobileNo = mobileNo
            ParentDetails.parentDetails.email = email
            ParentDetails.parentDetails.currentPoints = currentPoints
            UserDefaults.standard.set(name, forKey: Constants.parentName)
        }
        
        if let createdAt = data["createdAt"] as? String, let updatedAt = data["updatedAt"] as? String, let password = data["password"] as? String, let __v = data["__v"] as? Int {
            ParentDetails.parentDetails.createdAt = createdAt
            ParentDetails.parentDetails.updatedAt = updatedAt
            ParentDetails.parentDetails.password = password
            ParentDetails.parentDetails.__v = __v
        }
        
        if let residentialAddress = data["residentalAddress"] as? [String:Any] {
            var locationObj = Location(coordinates: [])
            if let location = residentialAddress["location"] as? [String:Any] {
                if let coordinates = location["coordinates"] as? [Double] {
                    locationObj.coordinates = coordinates
                }
            }
            if let _id = residentialAddress["_id"] as? String, let pincode = residentialAddress["pincode"] as? Int, let house_no = residentialAddress["house_no"] as? String, let area = residentialAddress["area"] as? String, let city = residentialAddress["city"] as? String, let state = residentialAddress["state"] as? String, let landmark = residentialAddress["landmark"] as? String {
                ParentDetails.parentDetails.residentalAddress = ResidentialAddress(_id: _id, location: locationObj, pincode: pincode, houseNo: house_no, area: area, city: city, state: state, landmark: landmark)
            }
        }
        
        if let student = data["student"] as? [[String:Any]] {
            UserDefaults.standard.set(student, forKey: Constants.studentInfo)
            ParentDetails.parentDetails.student.removeAll()
            for item in student {
                var studentObj = Student(_id: "", name: "", program: "", dob: "", profilePic: nil, birthCertificate: nil)
                if let _id = item["_id"] as? String, let name = item["name"] as? String, let dob = item["dob"] as? String, let program = item["program"] as? String {
                    studentObj._id = _id
                    studentObj.name = name
                    studentObj.dob = dob
                    studentObj.program = program
                    
                    if let profilePic = item["profilePic"] as? [String:Any] {
                        if let image_url = profilePic["image_url"] as? String, let image_name = profilePic["image_name"] as? String, let image_type = profilePic["image_type"] as? String, let image_timestamp = profilePic["image_timestamp"] as? Int64 {
                            studentObj.profilePic = PictureDetails(image_url: image_url, image_name: image_name, image_type: image_type, image_timestamp: image_timestamp)
                        }
                    }
                    
                    if let birthCertificate = item["birthCertificate"] as? [String:Any] {
                        if let image_url = birthCertificate["image_url"] as? String, let image_name = birthCertificate["image_name"] as? String, let image_type = birthCertificate["image_type"] as? String, let image_timestamp = birthCertificate["image_timestamp"] as? Int64 {
                            studentObj.birthCertificate = PictureDetails(image_url: image_url, image_name: image_name, image_type: image_type, image_timestamp: image_timestamp)
                        }
                    }
                    
                    ParentDetails.parentDetails.student.append(studentObj)
                }
            }
        }
    }
    
}
