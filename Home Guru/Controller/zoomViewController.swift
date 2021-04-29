//
//  zoomViewController.swift
//  Home Guru
//
//  Created by Priya Vernekar on 24/03/21.
//  Copyright © 2021 Priya Vernekar. All rights reserved.
//

import UIKit
import MobileRTC
class zoomViewController: UIViewController {

    @IBOutlet weak var backBtn: UIButton!
    var meetPassword: String = ""
    var meetId: String = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        //back button
        backBtn.layer.cornerRadius = 7
        // Do any additional setup after loading the view.
        MobileRTC.shared().setMobileRTCRootController(self.navigationController)
        
        // 2. Listen for user login notification and call the userLoggedIn method if the login is successful.
        NotificationCenter.default.addObserver(self, selector: #selector(userLoggedIn), name: NSNotification.Name(rawValue: "userLoggedIn"), object: nil)
    }
    

    @IBAction func joinAMeeting(_ sender: Any) {
      


        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let rootVc = storyboard.instantiateViewController(withIdentifier: "zoomViewController") as! zoomViewController

        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)

        appDelegate.window?.rootViewController = rootVc
        self.presentJoinMeetingAlert()
        
    }
    
    // 1. Function to create an alert dialog where users can enter meeting details.
    func presentJoinMeetingAlert() {
        let alertController = UIAlertController(title: "Join meeting", message: "", preferredStyle: .alert)

        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Meeting number"
            textField.text = "\(self.meetId)"
            textField.keyboardType = .phonePad
        }
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Meeting password"
            textField.text = "\(self.meetPassword)"
            textField.keyboardType = .asciiCapable
            textField.isSecureTextEntry = true
        }

        let joinMeetingAction = UIAlertAction(title: "Join meeting", style: .default, handler: { [weak self] alert -> Void in
            let numberTextField = alertController.textFields![0] as UITextField
            let passwordTextField = alertController.textFields![1] as UITextField
            
            if let meetingNumber = numberTextField.text{
                self?.joinMeeting(meetingNumber: meetingNumber, meetingPassword: self!.meetPassword)
            }
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { [weak self] (action : UIAlertAction!) -> Void in })

        alertController.addAction(joinMeetingAction)
        alertController.addAction(cancelAction)
        // used below code to get alert for second time
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
               while let presentedViewController = topController.presentedViewController {
                   topController = presentedViewController
               }
               topController.present(alertController, animated: true, completion: nil)
        }
        // uncommented below code to get alert for second time
        //self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func backBtnaction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func joinAnInstantMeeting(_ sender: Any) {
              // Obtain the MobileRTCAuthService from the Zoom SDK, and check if the user is logged into Zoom.
                if let authorizationService = MobileRTC.shared().getAuthService(), authorizationService.isLoggedIn() {
        // 3. Call the userLoggedIn method to start a meeting if login is successful
                    startMeeting()
                } else {
                    presentLogInAlert()
                }
    }
        func presentLogInAlert() {
            let alertController = UIAlertController(title: "Log in", message: "", preferredStyle: .alert)

            alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Email"
                textField.keyboardType = .emailAddress
            }
            alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Password"
                textField.keyboardType = .asciiCapable
                textField.isSecureTextEntry = true
            }

            let logInAction = UIAlertAction(title: "Log in", style: .default, handler: { alert -> Void in
                let emailTextField = alertController.textFields![0] as UITextField
                let passwordTextField = alertController.textFields![1] as UITextField

                if let email = emailTextField.text, let password = passwordTextField.text {
                    self.logIn(email: email, password: password)
                }
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: { (action : UIAlertAction!) -> Void in })

            alertController.addAction(logInAction)
            alertController.addAction(cancelAction)

            self.present(alertController, animated: true, completion: nil)
        }

        // MARK: - Internal
        
    // 2. Add a selector for the userLoggedIn function that invokes startMeeting function for a logged in user.
        @objc func userLoggedIn() {
            startMeeting()
        }
    
    func joinMeeting(meetingNumber: String, meetingPassword: String) {
        // Obtain the MobileRTCMeetingService from the Zoom SDK, this service can start meetings, join meetings, leave meetings, etc.
        if let meetingService = MobileRTC.shared().getMeetingService() {


            // Create a MobileRTCMeetingJoinParam to provide the MobileRTCMeetingService with the necessary info to join a meeting.
            // In this case, we will only need to provide a meeting number and password.
            let joinMeetingParameters = MobileRTCMeetingJoinParam()
            joinMeetingParameters.meetingNumber = meetingNumber
            joinMeetingParameters.password = meetingPassword

            // Call the joinMeeting function in MobileRTCMeetingService. The Zoom SDK will handle the UI for you, unless told otherwise.
            // If the meeting number and meeting password are valid, the user will be put into the meeting. A waiting room UI will be presented or the meeting UI will be presented.
            meetingService.joinMeeting(with: joinMeetingParameters)
        }
    }
    // 1. Create the login method
        func logIn(email: String, password: String) {
            // 2. Obtain the MobileRTCAuthService from the Zoom SDK, this service can log in a Zoom user, log out a Zoom user, authorize the Zoom SDK etc.
            if let authorizationService = MobileRTC.shared().getAuthService() {
                 // 3. Call the login function in MobileRTCAuthService. This will attempt to log in the user.
                authorizationService.login(withEmail: email, password: password, rememberMe: false)
            }
        }

    // 4. Write the startMeeting method.
        func startMeeting() {
            // 5. Obtain the MobileRTCMeetingService from the Zoom SDK, this service can start meetings, join meetings, leave meetings, etc.
            if let meetingService = MobileRTC.shared().getMeetingService() {
                //6. Set the ViewContoller to be the MobileRTCMeetingServiceDelegate
                meetingService.delegate = self

                /*** 5. Create a MobileRTCMeetingStartParam to provide the MobileRTCMeetingService with the necessary info to start an instant meeting. In this case we will use MobileRTCMeetingStartParam4LoginlUser(), since the user has logged into Zoom. ***/
                let startMeetingParameters = MobileRTCMeetingStartParam4LoginlUser()

                // 6. Call the startMeeting function in MobileRTCMeetingService. The Zoom SDK will handle the UI for you, unless told otherwise.
                meetingService.startMeeting(with: startMeetingParameters)
            }
        }
    
}

// 1. Extend the ViewController class to adopt and conform to MobileRTCMeetingServiceDelegate. The delegate methods will listen for updates from the SDK about meeting connections and meeting states.
extension zoomViewController: MobileRTCMeetingServiceDelegate {

    // Is called upon in-meeting errors, join meeting errors, start meeting errors, meeting connection errors, etc.
    func onMeetingError(_ error: MobileRTCMeetError, message: String?) {
//        switch error {
//        case MobileRTCMeetError_PasswordError:
//            print("Could not join or start meeting because the meeting password was incorrect.")
//        default:
//            print("Could not join or start meeting with MobileRTCMeetError: \(error) \(message ?? "")")
//        }
    }

    // Is called when the user joins a meeting.
    func onJoinMeetingConfirmed() {
        print("Join meeting confirmed.")
    }

    // Is called upon meeting state changes.
    func onMeetingStateChange(_ state: MobileRTCMeetingState) {
        print("Current meeting state: \(state)")
    }
}
