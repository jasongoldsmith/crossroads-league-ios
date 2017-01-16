//
//  TRRootViewController.swift
//  Traveler
//
//  Created by Rangarajan, Srivatsan on 2/19/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift


class TRRootViewController: TRBaseViewController {
    
    // Push Data
    var pushNotificationData: NSDictionary? = nil
    var branchLinkData: NSDictionary? = nil
    var shouldLoadInitialViewDefault = true
    
    private let ACTIVITY_INDICATOR_TOP_CONSTRAINT: CGFloat = 365.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        let userDefaults = NSUserDefaults.standardUserDefaults()
        let isUserLoggedIn = TRUserInfo.isUserLoggedIn()
        if userDefaults.boolForKey(K.UserDefaultKey.FORCED_LOGOUT_NEW_SIGN_IN) == false && isUserLoggedIn == true {
            _ = TRAuthenticationRequest().logoutTRUser({ (value ) in
                if value == true {
                    self.appLoading()
                }
            })
        } else {
            userDefaults.setBool(true, forKey: K.UserDefaultKey.FORCED_LOGOUT_NEW_SIGN_IN)
            self.appLoading()
        }
        
        //Add Observer to check if the user has been verified
        TRApplicationManager.sharedInstance.fireBaseManager?.addUserObserverWithCompletion({ (didCompelete) in
            
        })
    }

    func appLoading () {
        
        if let _ = self.branchLinkData {
            TRApplicationManager.sharedInstance.bungieVarificationHelper.branchLinkData = self.branchLinkData
        }
        
        TRApplicationManager.sharedInstance.bungieVarificationHelper.shouldShowLoginSceen({ (showLoginScreen, error) in
            
            if showLoginScreen == true {
                _ = TRPublicFeedRequest().getPublicFeed({ (didSucceed) in
                    let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
                    let vc : TRLoginOptionViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEWCONTROLLER_LOGIN_OPTIONS) as! TRLoginOptionViewController
                    let navigationController = UINavigationController(rootViewController: vc)
                    navigationController.navigationBar.hidden = true
                    self.presentViewController(navigationController, animated: true, completion: {
                        
                    })
                })
            } else {
                _ = TRGetEventsList().getEventsListWithClearActivityBackGround(true, clearBG: true, indicatorTopConstraint: self.ACTIVITY_INDICATOR_TOP_CONSTRAINT, completion: { (didSucceed) -> () in
                    
                    var showEventListLandingPage = false
                    
                    if(didSucceed == true) {
                        showEventListLandingPage = true
                        
                        TRApplicationManager.sharedInstance.addSlideMenuController(self, pushData: self.pushNotificationData, branchData: self.branchLinkData, showLandingPage: showEventListLandingPage, showGroups: false)
                        self.pushNotificationData = nil
                    } else {
                        self.appManager.log.debug("Failed")
                    }
                })
            }
            }, clearBackGroundRequest: false)
    }
    
//    func loadAppInitialViewController () {
//
//        //Check if already existing user, log them out for this version
//        let userDefaults = NSUserDefaults.standardUserDefaults()
//        if TRUserInfo.isUserLoggedIn() == true {
//            if userDefaults.boolForKey(K.UserDefaultKey.FORCED_LOGOUT) == false {
//            _ = TRAuthenticationRequest().logoutTRUser({ (value ) in
//                if value == true {
//                    userDefaults.setBool(true, forKey: K.UserDefaultKey.FORCED_LOGOUT)
//                    
//                    let refreshAlert = UIAlertController(title: "Changes to Sign In", message: "Your gamertag now replaces your Crossroads username when logging in (your password is still the same)", preferredStyle: UIAlertControllerStyle.Alert)
//                    refreshAlert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
//                        self.appLoadFlow()
//                    }))
//                    
//                    self.presentViewController(refreshAlert, animated: true, completion: nil)
//                }
//            })
//            } else {
//                self.appLoadFlow()
//            }
//        } else {
//            self.appLoadFlow()
//            userDefaults.setBool(true, forKey: K.UserDefaultKey.FORCED_LOGOUT)
//        }
//    }
//
//    func appLoadFlow () {
//        if (TRUserInfo.isUserLoggedIn()) {
//            
//            //Add Observer to check if the user has been verified
//            if (TRUserInfo.isUserVerified() != ACCOUNT_VERIFICATION.USER_VERIFIED.rawValue) {
//                TRApplicationManager.sharedInstance.fireBaseManager?.addUserObserverWithCompletion({ (didCompelete) in
//                    
//                })
//            }
//
//            let userDefaults = NSUserDefaults.standardUserDefaults()
//            let userInfo = TRUserInfo()
//            userInfo.userName = userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_UserName) as? String
//            userInfo.password = userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_UserPwd) as? String
//            
//            
//            var console = [String: AnyObject]()
//            console["consoleId"] = userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_USER_CONSOLE_ID) as? String
//            console["consoleType"] = userDefaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_USER_CONSOLE_TYPE) as? String
//            
//            let createRequest = TRAuthenticationRequest()
//            createRequest.loginTRUserWithSuccess(console, password: userInfo.password, completion: { (didSucceed) in
//                if didSucceed == true {
//                    _ = TRGetEventsList().getEventsListWithClearActivityBackGround(true, clearBG: true, indicatorTopConstraint: self.ACTIVITY_INDICATOR_TOP_CONSTRAINT, completion: { (didSucceed) -> () in
//                        
//                        var showEventListLandingPage = false
//                        
//                        if(didSucceed == true) {
//                            showEventListLandingPage = true
//                            
//                            TRApplicationManager.sharedInstance.addSlideMenuController(self, pushData: self.pushNotificationData, branchData: self.branchLinkData, showLandingPage: showEventListLandingPage, showGroups: false)
//                            self.pushNotificationData = nil
//                        } else {
//                            self.appManager.log.debug("Failed")
//                        }
//                    })
//                } else {
//                    //Delete the saved Password if sign-in was not successful
//                    userDefaults.setValue(nil, forKey: K.UserDefaultKey.UserAccountInfo.TR_UserPwd)
//                    userDefaults.synchronize()
//                    
//                    // Add Error View
//                    TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("The username and password do not match. Please try again.")
//                }
//            })
//        } else {
//            //loginOptions // Get Public Feed
//            _ = TRPublicFeedRequest().getPublicFeed({ (didSucceed) in
//                let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
//                let vc : TRLoginOptionViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEWCONTROLLER_LOGIN_OPTIONS) as! TRLoginOptionViewController
//                let navigationController = UINavigationController(rootViewController: vc)
//                navigationController.navigationBar.hidden = true
//                self.presentViewController(navigationController, animated: true, completion: {
//                    
//                })
//            })
//        }
//    }
    
    
    @IBAction func trUnwindAction(segue: UIStoryboardSegue) {
        
    }
}

