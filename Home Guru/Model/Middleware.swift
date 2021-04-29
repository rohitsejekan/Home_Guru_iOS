//
//  Middleware.swift
//  OpenMinds
//
//  Created by Priya Vernekar on 16/07/19.
//  Copyright © 2019 Priya Vernekar. All rights reserved.
//

import Foundation
import UIKit

let middleware: Middleware = Middleware()

class Middleware {
    func getSignedUrl(withParameter parameter: [String : Any], url: String,  andCompletion handler: @escaping(AnyObject, String?) -> Void) {
        HttpUtility().HTTPPutJSON(withUrl: url,
                                  andParameter: parameter as AnyObject,
                                  andCompletion: handler)
        print(parameter)
    }
    
    func upload(image: Data, toUrl url: String, withCompletion handler: @escaping(AnyObject, String?) -> Void) {
        HttpUtility().HTTPPutData(withUrl: url,
                                  andData: image,
                                  andCompletion: handler)
    }
}
