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
class addProfileViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate {
    
    //for datepicker
    var studentDates: String = ""
    // for date picker ends
    @IBOutlet weak var backBtn: UIButton!
    var imageData: Data?
    weak var userFrontImage: UIImage!
    var frontImage: UIImageView!
    @IBOutlet weak var addProfileTV: UITableView!
    
    var studentDetails : [String: String] = [:]
    var imageDetails : [String:Any] = [:]
    @IBOutlet weak var outerClassView: UIView!
    @IBOutlet weak var outerBoardView: UIView!
    @IBOutlet weak var classPickerView: UIPickerView!
    @IBOutlet weak var boardPickerView: UIPickerView!
    var datePickerView : DatePickerView?
    var attachmentDetails: [String:Any] = [:]
    var studentInfo: [String: String] = [:]
    var studentId: String = ""
    var ImageName: String = ""
    var selectedClass: String = ""
    var selectedBoard: String = ""
    private var manager : ImageManager?
    //date picker
    var datePickerView1 : DatePickerView?
    var classes: [String] = ["class 1","class 2","class 3","class 4","class 5","class 6","class 7","class 8","class 9"]
    var boards: [String] = ["CBSE","STATE"]
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    // datepicker implementation
    func showDatePicker() {
         datePickerView1 = Bundle.main.loadNibNamed("DatePickerView", owner: self, options: nil)?.first as! DatePickerView
         datePickerView1?.delegate = self
         datePickerView1?.showDatePickerView(onView: self.addProfileTV)
         addProfileTV.isScrollEnabled = true
         addProfileTV.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.none, animated: false)
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
        var fileName = "Profile_pic\(Int.random(in: 1...1000))"
        var fileType = ""
        let theInfo:NSDictionary = info as NSDictionary
        let cell = addProfileTV.cellForRow(at: IndexPath.init(row: 0, section: 0)) as! addProfileTableViewCell
//        let imgTemp = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        
        if let img:UIImage = theInfo.object(forKey: UIImagePickerController.InfoKey.originalImage) as? UIImage {
          //  self.userFrontImage.image = img
            self.userFrontImage = img
            print("received image....\(self.userFrontImage)")
            cell.avatar.image = img
            imageData = img.lowestQualityJPEGNSData
            DispatchQueue.main.async {
                self.addProfileTV.reloadData()
            }
            let data = userFrontImage?.jpegData(compressionQuality: 1)!
            fileType = "image/jpeg"
            imageDetails["data"] = data
            imageDetails["fileType"] = fileType
            imageDetails["fileName"] = fileName + ".jpeg"
            imageDetails["key"] = "profilePic"
           print("imageDetails is ..\(imageDetails)")
            
//            //get filename
//            if let asset = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerPHAsset")] as? PHAsset{
//              if let fileName = asset.value(forKey: "filename") as? String{
//                ImageName = fileName
//              print(fileName)
//              }
//          }
            
        }else{
            print("Error getting image")
        }
        
        
        self.dismiss(animated: true, completion: nil)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "addProfile", for: indexPath) as! addProfileTableViewCell
            cell.editName.delegate = self
            cell.editName.tag = 0
            cell.dobBtn.setTitle(studentDates, for: .normal)
            cell.dobBtn.contentHorizontalAlignment = .left
          //  cell.boardEdit.setTitle(selectedBoard, for: .normal)
          //  cell.classEdit.setTitle(selectedClass, for: .normal)
            if userFrontImage != nil{
                cell.avatar.image = userFrontImage
            }else{
                cell.avatar.image = UIImage(named: "Avatar 2")
            }
            
            print("image name..\(frontImage)")
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
        //back button
        backBtn.layer.cornerRadius = 5
        // instance of ImageManager
        manager = ImageManager()
        // add custom button
      
        addProfileTV.register(UINib(nibName: "customButtonTableViewCell", bundle: nil), forCellReuseIdentifier: "customButton")
        
        classPickerView.delegate = self
        classPickerView.dataSource = self
        boardPickerView.dataSource = self
        boardPickerView.delegate = self
        //hide pickers
        outerBoardView.isHidden = true
        outerClassView.isHidden = true
        
    
    }
    
    private func addStudent(){
        if(self.userFrontImage != nil){
            studentInfo["name"] = studentDetails["name"]
//            studentInfo["stdClass"] = studentDetails["stdClass"]
//            studentInfo["board"] = studentDetails["board"]
            studentInfo["stdClass"] = ""
            studentInfo["board"] = ""
            studentInfo["dob"] = ""
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
        }else{
            print("image empty")
        }
             
    }
    
    private func uploadImage(stuId: String){
        
        attachmentDetails["studentId"] = stuId
        attachmentDetails["profilePic"] = "ImageName"
        print("attachment...\(attachmentDetails)")
        AlamofireService.alamofireService.postMultiFormRequest(url: URLManager.sharedUrlManager.addAttachment, details: attachmentDetails,imageDetails:imageDetails) {
        response in
           switch response.result {
           case .success(let value):
               if let status =  response.response?.statusCode {
               print("status issw ..\(status)")
                print("value...\(value)")
                   if status == 200 || status == 201 {
                let val = JSON(value)

                    print("success upload...")

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
//        print("image..\(userFrontImage)")
//        //self.frontImage.image = userFrontImage.
//        if(self.userFrontImage != nil)
//              {
//                  //self.activityIndicator.isHidden = false
//                  manager?.uploadImage(data: (self.userFrontImage?.pngData())!,stuId: stuId, completionHandler: { (response) in
//
//                      if(response.path.isEmpty == false)
//                      {
//
//                          DispatchQueue.main.async {
//                             // self.activityIndicator.isHidden = true
//                              let alert = UIAlertController(title: "Image", message: "Image uploaded successfully", preferredStyle: .alert)
//                              let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                              alert.addAction(okAction)
//                              self.present(alert, animated: true)
//                          }
//                      }else{
//                        DispatchQueue.main.async {
//                        // self.activityIndicator.isHidden = true
//                        let alert = UIAlertController(title: "Image", message: "Image uploaded unsuccessfully", preferredStyle: .alert)
//                        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
//                        alert.addAction(okAction)
//                                self.present(alert, animated: true)
//                                                 }
//                    }
//                  })
//              }
    }

    @IBAction func goBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func boardAction(_ sender: UIButton) {
        if outerBoardView.isHidden{
                   outerBoardView.isHidden = false
               }
    }
    
    @IBAction func classAction(_ sender: UIButton) {
        if outerClassView.isHidden{
                          outerClassView.isHidden = false
        }
    }
    @IBAction func dismissClassPV(_ sender: UIBarButtonItem) {
        addProfileTV.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
                      hideUnhidePickerView(view: self.outerClassView, value: true)
               reload(tableView: self.addProfileTV)
    }
    
    @IBAction func dismissBoardPV(_ sender: UIBarButtonItem) {
        addProfileTV.reloadRows(at: [IndexPath(row: 0, section: 0)], with: .none)
        hideUnhidePickerView(view: self.outerBoardView, value: true)
        reload(tableView: self.addProfileTV)
    }
    func reload(tableView: UITableView) {

          let contentOffset = tableView.contentOffset
          tableView.reloadData()
          tableView.layoutIfNeeded()
          tableView.setContentOffset(contentOffset, animated: false)

      }
    //datepicker
    @IBAction func showDatePicker(_ sender: UIButton) {
        showDatePicker()
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
extension addProfileViewController: DatePickerProtocol {
    
    func dismiss() {
        addProfileTV.isScrollEnabled = true
        addProfileTV.scrollToRow(at: IndexPath(row: 0, section: 0), at: UITableView.ScrollPosition.none, animated: false)
        datePickerView?.removeFromSuperview()
    }
    
    func getSelectedDate(date: String) {
        let dateObj = getDateFromString(format: "dd/MM/yyyy", dateString: date)
        studentDates = getDateString(format: "yyyy-MM-dd", date:  dateObj)
        //getProgram(months: Date().months(from: dateObj))
        addProfileTV.reloadData()
    }
    
   
    }
    
    
    


extension addProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == classPickerView{
            return classes.count
            

        }else{
            return boards.count
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        if pickerView == classPickerView{
             return classes[row]
        }else{
            
            return boards[row]
        }
        
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == classPickerView{
                 selectedClass = classes[row]
            }else{
                selectedBoard = boards[row]
                
            }
    }
}
extension NSLayoutConstraint {

    override public var description: String {
        let id = identifier ?? ""
        return "id: \(id), constant: \(constant)" //you may print whatever you want here
    }
}

