//
//  BaseViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 10/10/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import UIKit
import MBProgressHUD
import SlideMenuControllerSwift

class BaseViewController:  UIViewController,UINavigationControllerDelegate {

    override func viewDidLoad() { super.viewDidLoad() }
    
    override func didReceiveMemoryWarning() { super.didReceiveMemoryWarning() }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
        let statusBar : UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
        statusBar.backgroundColor = ColorPalette.homeGuruBlueColor
    }

    func onInit() {
        //setNavigationBar()
    }
    
    func setNavigationBar() {
        guard let navigationController = self.navigationController else { return }
        navigationController.navigationBar.tintColor = ColorPalette.homeGuruOrangeColor
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.backgroundColor = ColorPalette.homeGuruBlueColor
        self.navigationController?.navigationBar.layer.masksToBounds = false
        self.navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        self.navigationController?.navigationBar.layer.shadowOpacity = 0.8
        self.navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        self.navigationController?.navigationBar.layer.shadowRadius = 2
        let logo = UIImageView(frame: CGRect(x: 0.0, y: 0.0, width: 85.0, height: 22.0))
        logo.image = UIImage(named: "LOGO")
        logo.contentMode = .scaleAspectFit
        logo.heightAnchor.constraint(equalToConstant: 22).isActive = true
        self.navigationItem.titleView = logo
    }


    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        endEditing()
    }
    
    @objc func endEditing() {
        view.endEditing(true)
    }
    
    func setupStatusBar() {
        if #available(iOS 13.0, *) {
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            
            let statusbarView = UIView()
            statusbarView.backgroundColor = ColorPalette.homeGuruBlueColor
            view.addSubview(statusbarView)
          
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true
          
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = ColorPalette.homeGuruBlueColor
        }
    }
    
    func addTapGesture(view: UIView) {
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(dismissKeyboard))
        tapGesture.numberOfTapsRequired = 1
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func toggleDrawer() {
        guard let drawer = self.slideMenuController() else { return }
        drawer.isLeftOpen() ? drawer.closeLeft() : drawer.openLeft()
    }
    
    
    
    func setNavigationBackTitle(title: String) {
        let backBarButton = UIBarButtonItem()
        backBarButton.title = title
        backBarButton.tintColor = ColorPalette.homeGuruBlueColor
        navigationItem.backBarButtonItem = backBarButton
    }
    
    func showLoader(onView: UITableView) -> MBProgressHUD {
        let hud = MBProgressHUD()
        onView.addSubview(hud)
        hud.show(animated: true)
        return hud
    }
    
    func hideLoader(loader: MBProgressHUD){
        loader.hide(animated: true)
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
        self.present(alert,animated: true,completion: nil)
    }
    
    func isNetConnectionAvailable() -> Bool {
        if !Connectivity.isConnectedToInternet || !isNetworkReachable() {
            return false
        }
        return true
    }
    
    func hideUnhideView(view: UIView, status: Bool) {
        UIView.animate(withDuration: 1.0) {
            view.isHidden = status
        }
    }
    
    func datePickerAction(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: date)
    }
    
}

extension BaseViewController {
    
    // Show Navigationbar on page.
    func showNavbar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    // Hide Navigationbar on page.
    func hideNavbar() {
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func hideUnhidePickerView(view: UIView, value: Bool) {
        UIView.animate(withDuration: 1.0) {
            view.isHidden = value
        }
    }
    
    func hideUnhideDateOrPickerView(datePicker: UIDatePicker, datePickerState: Bool, pickerView: UIPickerView, pickerState: Bool) {
        datePicker.isHidden = datePickerState
        pickerView.isHidden = pickerState
    }
    
}

