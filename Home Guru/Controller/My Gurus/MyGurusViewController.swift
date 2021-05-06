//
//  MyGurusViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 10/11/20.
//  Copyright © 2020 Priya Vernekar. All rights reserved.
//

import UIKit
import XLPagerTabStrip
class MyGurusViewController: ButtonBarPagerTabStripViewController {
    

    
    @IBOutlet weak var backBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureButtonBar()
               super.viewDidLoad()
               buttonBarView.backgroundColor = ColorPalette.homeGuruLiteBlueColor
               containerView.backgroundColor = ColorPalette.homeGuruBlueColor
        //back buton
        backBtn.layer.cornerRadius = 3
        
    }
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let hide = (viewController is NotificationsViewController)
        navigationController.setNavigationBarHidden(hide, animated: animated)
    }
    override func viewWillAppear(_ animated: Bool) {
          super.viewWillAppear(true)
          buttonBarView.backgroundColor = ColorPalette.homeGuruLiteBlueColor
          containerView.backgroundColor = ColorPalette.homeGuruBlueColor
      }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        configureButtonBar()
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
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        
        let child1 = Constants.mainStoryboard.instantiateViewController(withIdentifier: "currentBookingViewController") as! currentBookingViewController
        child1.childNumber = "  CURRENT BOOKINGS   "
        
        let child2 = Constants.mainStoryboard.instantiateViewController(withIdentifier: "pastBookingViewController") as! pastBookingViewController
        child2.childNumber = "   PAST BOOKINGS   "
        
        return [child1, child2]
    }
    
    
    @IBAction func goBack(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 0
    }
    
}

