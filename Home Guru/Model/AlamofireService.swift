//
//  AlamofireService.swift
//  Home Guru
//
//  Created by Priya Vernekar on 19/11/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import UIKit
import Alamofire

typealias completionBlock = (_ response: DataResponse<Any,AFError>) -> Void
typealias completionStringBlock = (_ response: DataResponse<String,AFError>) -> Void

class AlamofireService: NSObject {
    
    static let alamofireService : AlamofireService = AlamofireService()
    
    private override init() {
        
    }
    
    func getRequestHeaders() -> HTTPHeaders {
        var header : HTTPHeaders = [:]
        header["secret-key"] = Constants.secretKey
        return header
    }
    
    func headersWithXAuthToken() -> HTTPHeaders {
        var header : HTTPHeaders = [:]
  //        if let token = UserDefaults.standard.string(forKey: Constants.token) {
        //            header["x-auth-token"] = token
        //        }
        if let token = UserDefaults.standard.string(forKey: Constants.token){
               header["x-auth-token"] = token
               }
//                header["x-auth-token"] = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOjYsImlhdCI6MTYwODYyOTA0OH0.ktuO-f_lC9-pmcgKqkZPNBozJVpyafJOPATe6Y2BQKg"
        return header
    }
    
    // get request with headers as content-type
    func getRequestWithContentType(url: String, parameters: [String:AnyObject]?, completion: @escaping completionBlock) {
        var headers = getRequestHeaders()
        headers["Content-Type"] = "application/json"
        print(url)
        print(headers)
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON {
                response in
                completion(response)
        }
    }
    
    // get request with headers
    func getRequest(url: String, parameters: [String:AnyObject]?, completion: @escaping completionBlock) {
        let headers = getRequestHeaders()
        print(url)
        print(headers)
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON {
                response in
                completion(response)
        }
    }
    
    func getRequestWithToken(url: String, parameters: [String:AnyObject]?, completion: @escaping completionBlock) {
        let headers = headersWithXAuthToken()
        print(url)
        print(headers)
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
            .responseJSON {
                response in
                completion(response)
        }
    }
    
    func getRequestWithSecretKey(url: String, parameters: [String:AnyObject]?, completion: @escaping completionBlock) {
          let headers = getRequestHeaders()
          print(url)
          print(headers)
          AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
              .responseJSON {
                  response in
                  completion(response)
          }
      }
       
    // post request with body data as JSON and responseJSON
    func postRequestWithBodyData(url: String, details: [String:Any]?, completion: @escaping completionBlock) {
        print(url)
        print(details)
        var request = URLRequest(url: URL(string:url)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Constants.secretKey, forHTTPHeaderField: "secret-key")
        guard let data = JSONStringify(withJSON: details as AnyObject) else { return }
        print(data)
        print(request.allHTTPHeaderFields!)
        request.httpBody = data
        
        AF.request(request).responseJSON(completionHandler: { response in
                completion(response)
        })
    }
       
    // post request with body data as JSON and responseString
    func postRequestWithBodyDataString(url: String, details: [String:Any]?, completion: @escaping completionStringBlock) {
        print(url)
        print(details)
        var request = URLRequest(url: URL(string:url)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Constants.secretKey, forHTTPHeaderField: "secret-key")
        guard let data = JSONStringify(withJSON: details as AnyObject) else { return }
        print(data)
        print(request.allHTTPHeaderFields!)
        request.httpBody = data
        
        AF.request(request).responseString(completionHandler: { response in
                completion(response)
        })
    }
    
    // post request with body data as JSON and responseJSON
    func postRequestWithBodyDataAndToken(url: String, details: [String:Any], completion: @escaping completionBlock) {
        print(url)
        print(details)
        var request = URLRequest(url: URL(string:url)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = UserDefaults.standard.string(forKey: Constants.token){
            request.addValue(token, forHTTPHeaderField: "x-auth-token")
        }
        
       // request.addValue(UserDefaults.standard.string(forKey: Constants.token)!, forHTTPHeaderField: "x-auth-token")
        guard let data = JSONStringify(withJSON: details as AnyObject) else { return }
        print(data)
        print(request.allHTTPHeaderFields!)
        request.httpBody = data
        
        AF.request(request).responseJSON(completionHandler: { response in
                completion(response)
        })
      
    }
   
    // post request with body data as JSON and responsestring
    func postRequestWithBodyDataAndTokenString(url: String, details: [String:Any], completion: @escaping completionStringBlock) {
        print(url)
        print(details)
        var request = URLRequest(url: URL(string:url)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if let token = UserDefaults.standard.string(forKey: Constants.token){
                   request.addValue(token, forHTTPHeaderField: "x-auth-token")
               }
        
       // request.addValue(UserDefaults.standard.string(forKey: Constants.token)!, forHTTPHeaderField: "x-auth-token")
        guard let data = JSONStringify(withJSON: details as AnyObject) else { return }
        print(data)
        print(request.allHTTPHeaderFields!)
        request.httpBody = data
        
        AF.request(request).responseString(completionHandler: { response in
                completion(response)
        })
      
    }
    
    // post request with body data as JSON and responseString
    func postRequestWithToken(url: String, details: [String:Any]?, completion: @escaping completionStringBlock) {
        print(url)
        print(details)
        var request = URLRequest(url: URL(string:url)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(UserDefaults.standard.string(forKey: Constants.token)!, forHTTPHeaderField: "x-auth-token")
        guard let data = JSONStringify(withJSON: details as AnyObject) else { return }
        print(data)
        print(request.allHTTPHeaderFields)
        request.httpBody = data
        AF.request(request).responseString(completionHandler: { response in
                completion(response)
        })
    }
    
    // post request with body data as JSON and responseString
    func postRequest(url: String, details: [String:Any]?, completion: @escaping completionStringBlock) {
        print(url)
        print(details)
        var request = URLRequest(url: URL(string:url)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue(Constants.secretKey, forHTTPHeaderField: "secret-key")
        guard let data = JSONStringify(withJSON: details as AnyObject) else { return }
        print(data)
        print(request.allHTTPHeaderFields)
        request.httpBody = data
        AF.request(request).responseString(completionHandler: { response in
                completion(response)
        })
    }
    
    // post request with multi-form data
    func postMultiFormRequest(url: String, details: [String:Any], imageDetails: [String:Any], completion: @escaping completionBlock) {
        print(url)
        print(details)
        print(imageDetails)
        var headers = headersWithXAuthToken()
        headers["Content-type"] = "multipart/form-data"
        print(headers)
        AF.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in details {
                multipartFormData.append((("\(value)").data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue)))!, withName: key)
            }
            if !(imageDetails.isEmpty) {
                multipartFormData.append(imageDetails["data"] as! Data, withName: imageDetails["key"] as! String, fileName: (imageDetails["fileName"] as! String), mimeType:  imageDetails["fileType"] as! String)
                }
          
            print("multipartFormData is ...\(multipartFormData)")
            print("imageDetails is ...\(imageDetails)")
        }, to: url , usingThreshold: UInt64.init(), method: HTTPMethod.put, headers: headers).responseJSON(completionHandler: {
            response in
            completion(response)
        })
        
    }
    

    
    
}
