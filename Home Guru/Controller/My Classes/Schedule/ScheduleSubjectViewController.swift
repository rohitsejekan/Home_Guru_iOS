//
//  ScheduleSubjectViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 20/11/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import JJFloatingActionButton
class ScheduleSubjectViewController: ButtonBarPagerTabStripViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    let actionButton = JJFloatingActionButton()
    override func viewDidLoad() {
        //floating button
        floatingButton()
        configureButtonBar()
        actionButton.buttonDiameter = 65
        actionButton.buttonImageSize = CGSize(width: 35, height: 35)
        //floating button ends
        super.viewDidLoad()
        buttonBarView.backgroundColor = ColorPalette.homeGuruLiteBlueColor
        containerView.backgroundColor = ColorPalette.homeGuruBlueColor
        
        backBtn.layer.cornerRadius = 5
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        configureButtonBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        buttonBarView.backgroundColor = ColorPalette.homeGuruLiteBlueColor
        containerView.backgroundColor = ColorPalette.homeGuruBlueColor
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let child1 = Constants.mainStoryboard.instantiateViewController(withIdentifier: "ScheduleAcademicListViewController") as! ScheduleAcademicListViewController
        child1.childNumber = "  Academic   "
        
        let child2 = Constants.mainStoryboard.instantiateViewController(withIdentifier: "ScheduleNonAcademicListViewController") as! ScheduleNonAcademicListViewController
        child2.childNumber = "   Non-Academic   "
        
        return [child1, child2]
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func configureButtonBar() {
        // Sets the background colour of the pager strip and the pager strip item
        settings.style.buttonBarBackgroundColor = ColorPalette.homeGuruLiteBlueColor
        settings.style.buttonBarItemBackgroundColor = ColorPalette.homeGuruLiteBlueColor
        settings.style.selectedBarBackgroundColor = ColorPalette.homeGuruOrangeColor
        settings.style.selectedBarHeight = 2.0
        
        // Sets the pager strip item font and font color
        settings.style.buttonBarItemFont = UIFont(name: "SourceSansPro-Regular", size: 16.0) ?? UIFont.systemFont(ofSize: 16.0)
        settings.style.buttonBarItemTitleColor = ColorPalette.homeGuruLightGreyColor
        
        // Sets the pager strip item offsets
        settings.style.buttonBarMinimumLineSpacing = 0
//        settings.style.buttonBarItemsShouldFillAvailableWidth = true
        settings.style.buttonBarLeftContentInset = 0
        settings.style.buttonBarRightContentInset = 0
        
        // Sets the height and colour of the slider bar of the selected pager tab
        settings.style.selectedBarHeight = 2.0
        
        // Changing item text color on swipe
        changeCurrentIndexProgressive = { [weak self] (oldCell: ButtonBarViewCell?, newCell: ButtonBarViewCell?, progressPercentage: CGFloat, changeCurrentIndex: Bool, animated: Bool) -> Void in
            guard changeCurrentIndex == true else { return }
            oldCell?.label.textColor = ColorPalette.homeGuruLightGreyColor
            newCell?.label.textColor = ColorPalette.whiteColor
            newCell?.backgroundColor = ColorPalette.homeGuruBlueColor
        }
    }
    
}
extension ScheduleSubjectViewController{
    func floatingButton(){
              actionButton.addItem(title: "", image: UIImage(named: "whatsApp")?.withRenderingMode(.alwaysTemplate)) { item in
              
                         
                         if let whatsappURL = URL(string: "https://api.whatsapp.com/send?phone=+919001990019&text=Invitation"), UIApplication.shared.canOpenURL(whatsappURL) {
                                        if #available(iOS 10, *) {
                                            UIApplication.shared.open(whatsappURL)
                                        } else {
                                            UIApplication.shared.openURL(whatsappURL)
                                        }
                         }
                     }

                     actionButton.addItem(title: "", image: UIImage(named: "mdi_call")?.withRenderingMode(.alwaysTemplate)) { item in
                       // do something
                   if let url = URL(string: "tel://\(Constants.contactUs)"), UIApplication.shared.canOpenURL(url) {
                                      if #available(iOS 10, *) {
                                          UIApplication.shared.open(url)
                                      } else {
                                          UIApplication.shared.openURL(url)
                                      }
                                  }
                     }

                     actionButton.buttonImage = UIImage(named: "customer-service")
                     actionButton.buttonColor = ColorPalette.homeGuruDarkGreyColor
                     view.addSubview(actionButton)
                     actionButton.translatesAutoresizingMaskIntoConstraints = false
                     if #available(iOS 11.0, *) {
                         actionButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16).isActive = true
                     } else {
                         // Fallback on earlier versions
                         actionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16).isActive = true
                     }
                     if #available(iOS 11.0, *) {
                         actionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
                     } else {
                         // Fallback on earlier versions
                         actionButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16).isActive = true
                     }
          }
          
}
