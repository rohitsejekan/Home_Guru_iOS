//
//  RegisterParentViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 10/10/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
import CoreLocation
import IQKeyboardManagerSwift
import GoogleMaps

class RegisterParentViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var outerPickerView: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var locationManager = CLLocationManager()
    var pickerType : StateCityPickerType = .state
    var userDetails : [String:Any] = [:]
    var cityStateList : [String:[String]] = [:]
//    var address : [String:Any] = ["location": ["coordinates" : [0.0,0.0],"type": "point"],"landmark":""]
    var address : [String:Any] = ["location": ["coordinates" : [0.0,0.0]],"landmark":""]
    var tag = 1
    var noOfStudents = 1
    var isAddressSet = false
    var hud : MBProgressHUD = MBProgressHUD()
//    var fromSideMenu : Bool = false
//    var navigateDelegate : RegisterNavigateProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        getCityStateList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if g_lat != nil && g_long != nil {
            getAddressFromLatLong(latitude: g_lat!, longitude: g_long!)
        }
//        if fromSideMenu {
//            setSideMenuNavigationBar()
//        }
    }
    
//    func setSideMenuNavigationBar() {
//        guard let navigationController = self.navigationController else { return }
//        navigationController.navigationBar.tintColor = ColorPalette.koalaPinkTextColor
//        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
//        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.backgroundColor = UIColor.white
//        self.navigationController?.navigationBar.layer.masksToBounds = false
//        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
//        self.navigationController?.navigationBar.layer.shadowOpacity = 0.8
//        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
//        self.navigationController?.navigationBar.layer.shadowRadius = 2
//        let customBtn = UIButton(type: .custom)
//        customBtn.setImage(UIImage(named: "Back"), for: .normal)
//        customBtn.frame = CGRect(x: 0, y: 0, width: 120, height: 30)
//        customBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
//        customBtn.setTitle(" Register",for: .normal)
//        customBtn.setTitleColor(ColorPalette.koalaPinkTextColor, for: .normal)
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: customBtn)
//    }
    
//    @objc func backAction() {
//        navigateDelegate?.navigateToHomeVC()
//    }
    
    @IBAction func changeLocationAction(_ sender: UIButton) {
        let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "SearchLocationViewController") as? SearchLocationViewController
        vc!.modalPresentationStyle = .overCurrentContext
        self.present(vc!, animated: true, completion: nil)
    }
    
    @IBAction func selectStateORCityAction(_ sender: UIButton) {
        endEditing()
        pickerType = (sender.tag == 1) ? .state : .city
        pickerView.selectedRow(inComponent: 0)
        pickerView.reloadAllComponents()
        hideUnhidePickerView(view: self.outerPickerView, value: false)
    }
    
    @IBAction func dismissPickerView(_ sender: UIBarButtonItem) {
        address[(pickerType == .state) ? "state" : "city"] = (pickerType == .state) ? (Array(cityStateList.keys)[pickerView.selectedRow(inComponent: 0)] ) : !cityStateList.isEmpty ? (cityStateList[address["state"] as! String]?[pickerView.selectedRow(inComponent: 0)]) : ""
        tableView.reloadRows(at: [IndexPath(row: 8, section: 0)], with: .none)
        hideUnhidePickerView(view: self.outerPickerView, value: true)
    }
    
    @IBAction func useLocationAction(_ sender: UIButton) {
        getCurrentLocationCordinates()
    }
    
    @IBAction func nextBtnAction(_ sender: UIButton) {
        userDetails["residentalAddress"] = [address]
        print("userDetails is ..\(userDetails)")
        let vc = Constants.mainStoryboard.instantiateViewController(withIdentifier: "RegisterStudentViewController") as? RegisterStudentViewController
        vc!.parentDetails = userDetails
        vc!.numberOfStudents = noOfStudents
        vc!.studentDetails = [[String:Any]](repeating: [String : Any](), count: noOfStudents)
        vc!.setNavigationBackTitle(title: "Register")
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 11
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 190.0
        case 1,2,5,6,7,9,8:
            return 80.0
        case 3:
            return 160.0
        case 4:
            return 200.0
        default:
            return 100.0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "registerParentHeaderCell", for: indexPath) as? RegisterParentTableViewCell
            cell?.selectionStyle = .none
            return cell!
        case 1,2,5,6,7,9:
            let cell = tableView.dequeueReusableCell(withIdentifier: "registerParentInput1Cell", for: indexPath) as? RegisterParentTableViewCell
            cell?.inputType1TextField.tag = indexPath.row
            cell?.setTextFieldPlaceholder(index: indexPath.row)
            cell?.inputType1TextField.text = ""
            cell?.setValue(index: indexPath.row, userDetails: userDetails, address: address)
            cell?.selectionStyle = .none
            return cell!
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "registerParentNoOfStudentInputCell", for: indexPath) as? RegisterParentTableViewCell
            cell?.setSelectedState(btn1State: (cell?.oneStudentRadioBtn)!.isSelected,btn2State: (cell?.twoStudentRadioBtn)!.isSelected,btn3State: (cell?.threeStudentRadioBtn)!.isSelected, btn4State: (cell?.fourStudentRadioBtn)!.isSelected)
            cell?.delegate = self
            cell?.selectionStyle = .none
            return cell!
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "registerParentAddressInputCell", for: indexPath) as? RegisterParentTableViewCell
            if isAddressSet {
                cell?.selectLocationOuterView.isHidden = true
                cell?.selectedLocationOuterView.isHidden = false
                cell?.addressLabel.text = g_address
            } else {
                cell?.selectLocationOuterView.isHidden = false
                cell?.selectedLocationOuterView.isHidden = true
            }
            cell?.selectionStyle = .none
            return cell!
        case 8:
            let cell = tableView.dequeueReusableCell(withIdentifier: "registerParentInput2Cell", for: indexPath) as? RegisterParentTableViewCell
            cell?.setCityStateAttributes()
            cell?.inputType2TextField.text = address["state"] as? String
            cell?.inputType3TextField.text = address["city"] as? String
            cell?.selectionStyle = .none
            return cell!
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "registerParentActionCell", for: indexPath) as? RegisterParentTableViewCell
            cell?.selectionStyle = .none
            return cell!
        }
    }
}

extension RegisterParentViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return (pickerType == .state) ? cityStateList.count : !cityStateList.isEmpty ? (cityStateList[address["state"] as! String])!.count : 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (pickerType == .state) ? (Array(cityStateList.keys)[row] ) : !cityStateList.isEmpty ? (cityStateList[(address["state"] as! String) ?? "" ]?[row]) : ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        address[(pickerType == .state) ? "state" : "city"] = (pickerType == .state) ? (Array(cityStateList.keys)[row] ) : !cityStateList.isEmpty ? (cityStateList[address["state"] as! String]?[row]) : ""
    }
}

extension RegisterParentViewController {
    
    func getCurrentLocationCordinates() {
        hud = showLoader(onView: tableView)
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        //        if CLLocationManager.locationServicesEnabled() {
        //             switch CLLocationManager.authorizationStatus() {
        //                case .notDetermined, .restricted, .denied:
        //                    let alert = UIAlertController(title: "Allow Location Access", message: "App needs access to your location. Turn on Location Services in your device settings.", preferredStyle: UIAlertController.Style.alert)
        //
        //                    alert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: { action in
        //                        if let url = URL(string: "App-Prefs:root=Privacy&path=LOCATION")
        //                        {
        //                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        //                        }
        //                    }))
        //                    alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        //                    self.present(alert, animated: true, completion: nil)
        //                case .authorizedAlways, .authorizedWhenInUse:
        //                    print("Access")
        //                    locationManager.startUpdatingLocation()
        //                }
        //            } else {
        //                print("Location services are not enabled")
        //        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("locations is ..\(locations)")
        if let userLocation :CLLocation = locations[0] as? CLLocation {
            print("user latitude = \(userLocation.coordinate.latitude)")
            print("user longitude = \(userLocation.coordinate.longitude)")
            UserDefaults.standard.set(["latitude": userLocation.coordinate.latitude, "longitude":userLocation.coordinate.longitude],forKey:Constants.parentLocationCordinates)
            address["location"] = ["coordinates":[userLocation.coordinate.latitude, userLocation.coordinate.longitude]]
            g_lat = "\(userLocation.coordinate.latitude)"
            g_long = "\(userLocation.coordinate.longitude)"
            getAddressFromLatLong(latitude: g_lat, longitude: g_long)
            g_address = ""
            if let parentLocation = UserDefaults.standard.dictionary(forKey:Constants.parentLocationCordinates) {
                print("parentLocation is ...\(parentLocation)")
            }
            locationManager.stopUpdatingLocation()
        } else {
            print("no locations..")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error fetching location \(error)")
    }
    
    func getAddressFromLatLong(latitude: String, longitude : String) {
        let lat = Double(latitude)
        let long = Double(longitude)
        GMSGeocoder.init().reverseGeocodeCoordinate(CLLocationCoordinate2D(latitude: lat ?? 0.0, longitude: long ?? 0.0)) { (response, error) in
            if let _ = error {
                print("Check Network Connection...")
                return
            }
            guard let response = response, let address = response.firstResult()
                else { return }
            print("address in register parent ..\(address)")
            g_address = address.lines![0]
            g_addressDetails = address
            if var locationCordinates = self.address["location"] as? [String:Any] {
                if var cordinates = locationCordinates["coordinates"] as? [Double] {
                    cordinates[0] = lat!
                    cordinates[1] = long!
                    locationCordinates["coordinates"] = cordinates
                    self.address["location"] = locationCordinates
                }
            }
            var addressString = (address.lines![0] as! String).components(separatedBy: ",")
            self.address["pincode"] =  address.postalCode
            var houseAddress = ""
            for item in addressString {
                if item != address.postalCode
                    && item != address.administrativeArea && item != address.subLocality
                    && item != address.country && item != address.locality {
                    houseAddress = houseAddress + (houseAddress.isEmpty ? "" : ",") + item
                }
            
            }
            self.address["house_no"] = houseAddress
            self.address["area"] = address.subLocality
            self.address["state"] = address.administrativeArea
            self.address["city"] = address.locality
            DispatchQueue.main.async {
                self.hideLoader(loader: self.hud)
                self.isAddressSet = true
                self.tableView.reloadRows(at: [IndexPath(row: 4, section: 0),IndexPath(row: 5, section: 0),IndexPath(row: 6, section: 0),IndexPath(row: 7, section: 0),IndexPath(row: 8, section: 0)], with: .none)
            }
        }
    }
    
    func getCityStateList() {
        if !isNetConnectionAvailable() {
            self.showAlert(title: "Message", message: "Please Check Your Internet Connection!")
            return
        }
        AlamofireService.alamofireService.getRequest(url: URLManager.sharedUrlManager.getCityStateList, parameters: nil) { response
            in
            switch response.result {
            case .success(let value):
                if let status =  response.response?.statusCode {
                    print("status is ..\(status)")
                    if status == 200 || status == 201 {
                        if let result = value as? [String:Any] {
                            if let cityStateList = result["statecity"] as? [String:[String]] {
                                self.cityStateList = cityStateList
                            }
                        }
                        DispatchQueue.main.async {
                            self.pickerView.reloadAllComponents()
                        }
                    }
                }
            case .failure( _):
                self.showAlert(title: Constants.unknownTitle, message: Constants.unknownMsg)
            }
        }
    }
    
}

extension RegisterParentViewController : UITextFieldDelegate, StudentSelectionProtocol {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let keyboardManager = IQKeyboardManager.shared
        if keyboardManager.canGoNext { keyboardManager.goNext(); } else  { view.endEditing(true) ; }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != nil {
            switch textField.tag {
            case 1:
                userDetails["name"] = textField.text
            case 2:
                userDetails["email"] = textField.text
            case 5:
                address["pincode"] = textField.text
            case 6:
                address["house_no"] = textField.text
            case 7:
                address["area"] = textField.text
            default:
                address["landmark"] = textField.text
            }
        }
        tableView.reloadRows(at: [IndexPath(row: textField.tag, section: 0)], with: .none)
    }
    
    func getNoOfStudents(noOfStudents: Int) {
        tag = noOfStudents
        self.noOfStudents = noOfStudents
        tableView.reloadRows(at: [IndexPath(row: 3, section: 0)], with: .none)
    }

}

