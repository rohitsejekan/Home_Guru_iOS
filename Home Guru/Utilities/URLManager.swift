//
//  URLManager.swift
//  Home Guru
//
//  Created by Priya Vernekar on 10/10/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import Foundation
import UIKit

class URLManager {
    
    static let sharedUrlManager = URLManager()
    
    var baseURL = "https://api1653.homeguru.cc/api"
    
    var getParentAuth : String {
        get {
            return baseURL + "/parent/auth/login"
        }
    }
    
    var verifyUserExists : String {
        get {
            return baseURL + "/parent/verify"
        }
    }
    
    var getCityStateList : String {
        get {
            return baseURL + "/statecity"
        }
    }
    
    // get program list
    var getProgramList : String {
        get {
            return baseURL + "/parent/program"
        }
    }
    //boards
    var getBoards: String{
        get{
            return baseURL + "/board"
        }
    }
    
    // register parent
    var registerParent : String {
        get {
            return baseURL + "/parent"
        }
    }
    
    // get current points
    var getCurrentPoints : String {
        get {
            return baseURL + "/parent/koalamoney"
        }
    }
    
    // get Parent Profile Details
    var getProfileDetails : String {
        get {
            return baseURL + "/parent/me"
        }
    }
    
    // update Student Profile with parent data
    var updateStudentProfile : String {
        get {
            return baseURL + "/parent/updateParent/"
        }
    }
    
    // update Student Profile Picture
    var updateStudentProfilePicture : String {
        get {
            return baseURL + "/parent/updateAttachments/"
        }
    }
    
    // get Scheduled classes
    var getScheduledClasses : String {
        get {
            return baseURL + "/parent/koalaclass"
        }
    }
    
    // schedule class
    var scheduleClass : String {
        get {
            return baseURL + "/parent/koalaclass/schedule"
        }
    }
    
    // get transaction list
    var getTransactionList : String {
        get {
            return baseURL + "/parent/koalamoney/transaction"
        }
    }
    
    // get point unit
    var getPointUnit : String {
        get {
            return baseURL + "/parent/koalamoney/pointunit"
        }
    }
    
    // create transaction record
    var createTransactionRecord : String {
        get {
            return baseURL + "/parent/koalamoney/transaction"
        }
    }
    
    // get class Types
    var getClassTypes : String {
        get {
            return baseURL + "/parent/classtype"
        }
    }
    
    // get daily temperature
    var getDailyTemperature : String {
       get {
           return "https://apiv2.goqii.com/organization/body_temperature?organizationId=20090808&organizationApiKey=xsqolh6h7ojhd1vadj79ch69c&signature=9ede48aa31aed3ab21d4d209a03d248dc986d07c&nonce=79ch69cxs&mobile=8660940191"
       }
    }
    
    // get weekly temperature
    var getWeeklyTemperature : String {
       get {
           return "https://apiv2.goqii.com/organization/body_temperature_weekly?organizationId=20090808&organizationApiKey=xsqolh6h7ojhd1vadj79ch69c&signature=9ede48aa31aed3ab21d4d209a03d248dc986d07c&nonce=79ch69cxs&mobile=8660940191"
       }
    }
    
    private init() {
        
    }
    
}
