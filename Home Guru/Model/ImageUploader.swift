////
////  ImageUploader.swift
////  OpenMinds
////
////  Created by Priya Vernekar on 16/07/19.
////  Copyright © 2019 Priya Vernekar. All rights reserved.
////
//
//import Foundation
//import UIKit
//import Alamofire
//
////protocol ImageUploaderDelegate {
////    func completedWithStatus(_ code: Int, id: Int?, name: String?)
////}
//
//class ImageUploader {
//
//    var image: UIImage?
////    var delegate: ImageUploaderDelegate?
//    var id: Int!
//    var link: String!
//    var name : String?
//    var album = ""
//
//    init(image: UIImage) {
//        self.image = image
//        getSignedUrl()
//    }
//
//    init(image: UIImage, name: String) {
//        self.image = image
//        self.album = name
//        getSignedUrl()
//    }
//
//    deinit {
//        self.image = nil
//        print("data deinitialized")
//    }
//
//    func getSignedUrl() {
//        let imageName = "image_" + "\(Date().convertToFormat(withFormat: "yyyy_MM_dd_hh_mm_ss_SSS")).jpg"
//        var parameter: [String : Any] = [:]
//        var url = ""
//
//        if UserDefaults.standard.bool(forKey: "GalleryUpload") {
//            parameter = [
//                "image_list": [imageName],
//                "album": album
//            ]
//            url = "https://app.openmindsworld.org/get_signed_url/"
//        } else {
//            parameter = [
//                "image_list": [imageName]
//            ]
//            url = "https://app.openmindsworld.org/get_signed_url/"
//        }
//
//        middleware.getSignedUrl(withParameter: parameter, url: url) { (data, error) in
//            if let _ = error {
////                self.delegate?.completedWithStatus(2, id: nil, name: self.name)
//                return
//            }
//
//            //            guard let data = data as? [String : AnyObject] else { self.delegate?.completedWithStatus(4, id: nil); return }
//            guard let urls = data as? [[String : AnyObject]] else {
////                self.delegate?.completedWithStatus(4, id: nil, name: self.name);
//                return }
//            if urls.isEmpty {
////                self.delegate?.completedWithStatus(4, id: nil, name: self.name);
//                return }
//            let entry = urls.first!
//
//            guard let link = entry["url"] as? String,
//                let id = entry["id"] as? Int else {
////                    self.delegate?.completedWithStatus(4, id: nil, name: self.name);
//                    return }
//
//            // Set retreived info!
//            self.link = link
//            self.id = id
//            self.name = imageName
//            self.upload()
//        }
//
//
//    }
//
//    func upload() {
//        guard var data = image?.toData() else {
////            self.delegate?.completedWithStatus(1, id: nil, name: name);
//            return }
//        middleware.upload(image: data,
//                          toUrl: link) { (data, error) in
//
//                            if let _ = error {
////                                self.delegate?.completedWithStatus(2, id: nil, name: self.name)
//                                return
//                            }
//
//                            // Upload was successful, return the id.
//                            print("upload success")
////                            self.delegate?.completedWithStatus(0, id: self.id, name: self.name)
//        }
//        data.removeAll()
//    }
//
//
//
//
//}
//
