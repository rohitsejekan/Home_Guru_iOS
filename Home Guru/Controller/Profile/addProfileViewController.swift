//
//  addProfileViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 16/03/21.
//  Copyright © 2021 Priya Vernekar. All rights reserved.
//


import UIKit
import Photos
import SwiftyJSON
class addProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var imageData: Data?
    var userFrontImage: UIImage!
    @IBOutlet weak var addProfileTV: UITableView!
    var studentDetails: [String: String] = [:]
    var attachmentDetails: [String:Any] = [:]
    var studentInfo: [String: String] = [:]
    var studentId: String = ""
    var ImageName: String = ""
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    @IBAction func uploadImage(_ sender: UIButton) {
        
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera){
               let imagePicker = UIImagePickerController()
               imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
               imagePicker.allowsEditing = false
               self.present(imagePicker, animated: true, completion: nil)
               
               
           }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let theInfo:NSDictionary = info as NSDictionary
        let cell = addProfileTV.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! addProfileTableViewCell
        let imgTemp = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        cell.avatar.image = imgTemp
        userFrontImage = imgTemp
        if let img:UIImage = theInfo.object(forKey: UIImagePickerController.InfoKey.originalImage) as? UIImage {
            userFrontImage = img
            DispatchQueue.main.async {
                self.addProfileTV.reloadData()
            }
            if let asset = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerPHAsset")] as? PHAsset{
              if let fileName = asset.value(forKey: "filename") as? String{
                ImageName = fileName
              print(fileName)
              }
          }
            
        }else{
            print("Error getting image")
        }
        
        
        imageData = imgTemp?.lowestQualityJPEGNSData
        self.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "addProfile", for: indexPath) as! addProfileTableViewCell
            cell.editName.delegate = self
            cell.editName.tag = 0
            cell.dateEdit.delegate = self
            cell.dateEdit.tag = 1
            cell.monthEdit.delegate = self
            cell.monthEdit.tag = 2
            cell.yearEdit.delegate = self
            cell.yearEdit.tag = 3
            cell.classEdit.delegate = self
            cell.classEdit.tag = 4
            cell.boardEdit.delegate = self
            cell.boardEdit.tag = 5
            cell.avatar.image = userFrontImage
            print("image name..\(userFrontImage)")
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "customButton", for: indexPath) as! customButtonTableViewCell
            cell.goToDelegate = self
            return cell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 1{
            return 70
        }else{
            return UITableView.automaticDimension
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        addProfileTV.estimatedRowHeight = UITableView.automaticDimension
        addProfileTV.rowHeight = 300
        
        // add custom button
      

        addProfileTV.register(UINib(nibName: "customButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "customButton")
        
    
    }
    
    private func addStudent(){
             studentInfo["name"] = studentDetails["name"]
             studentInfo["stdClass"] = studentDetails["stdClass"]
             studentInfo["board"] = studentDetails["board"]
             studentInfo["dob"] = "2020-02-03"
                AlamofireService.alamofireService.postRequestWithBodyDataAndToken(url: URLManager.sharedUrlManager.addProfile, details: studentInfo) {
                response in
                   switch response.result {
                   case .success(let value):
                       if let status =  response.response?.statusCode {
                       print("status issw ..\(status)")
                        print("value...\(value)")
                           if status == 200 || status == 201 {
                        let val = JSON(value)
                            self.studentId = val["_id"].stringValue
                            print("val...\(val["_id"].stringValue)")
                                                  
                        DispatchQueue.main.async {
                            self.uploadImage(stuId: self.studentId)
                         }
                    }
                       }
                   case .failure( _):
                       print("failure")
                            return
                        }
                   }
    }
    
    private func uploadImage(stuId: String){
        
        
        attachmentDetails["studentId"] = stuId
        attachmentDetails["profilePic"] = ImageName
        print("attachment...\(attachmentDetails)")
        AlamofireService.alamofireService.imageUpload(url: URLManager.sharedUrlManager.addProfile, details: attachmentDetails) {
        response in
           switch response.result {
           case .success(let value):
               if let status =  response.response?.statusCode {
               print("status issw ..\(status)")
                print("value...\(value)")
                   if status == 200 || status == 201 {
                let val = JSON(value)
                    self.studentId = val["_id"].stringValue
                    print("val...\(val["_id"].stringValue)")
                                          
                DispatchQueue.main.async {
                    self.addProfileTV.reloadData()
                 }
            }
               }
           case .failure( _):
               print("failure")
                    return
                }
           }
    }

    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
extension addProfileViewController: nextScreen{
    func gotoScreen() {
    print("button pressed")
            addStudent()
    }
}

extension addProfileViewController: UITextFieldDelegate{
    func textFieldDidEndEditing(_ textField: UITextField) {
        switch textField.tag{
        case 0:
            studentDetails["name"] = textField.text ?? ""
            print("st 1...\(studentDetails["name"])")
        case 1:
            studentDetails["dateEdit"] = textField.text ?? ""
            print("st 2...\(studentDetails["dateEdit"])")
        case 2:
            studentDetails["monthEdit"]  = textField.text ?? ""
            print("st 3...\(studentDetails["monthEdit"])")
        case 3:
            studentDetails["yearEdit"] = textField.text ?? ""
            print("st 4...\(studentDetails["yearEdit"])")
        case 4:
            studentDetails["stdClass"] = textField.text ?? ""
            print("st 5...\(studentDetails["classEdit"])")
            
        case 5: studentDetails["board"] = textField.text ?? ""
            print("st 6...\(studentDetails["boardEdit"])")
            
        default:
            print("default")
        }
    }
}
extension UIImage {
    
    var highestQualityJPEGNSData: Data { return self.jpegData(compressionQuality: 1.0)! }
    var highQualityJPEGNSData: Data    { return self.jpegData(compressionQuality: 0.75)!}
    var mediumQualityJPEGNSData: Data  { return self.jpegData(compressionQuality: 0.5)! }
    var lowQualityJPEGNSData: Data     { return self.jpegData(compressionQuality: 0.25)!}
    var lowestQualityJPEGNSData: Data  { return self.jpegData(compressionQuality: 0.0)! }
    
}
