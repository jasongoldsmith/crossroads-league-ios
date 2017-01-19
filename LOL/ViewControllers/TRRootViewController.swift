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

        _ = TRGetConfigRequest().getConfiguration({ (didSucceed) in
            let isUserLoggedIn = TRUserInfo.isUserLoggedIn()
            self.appLoading()
            
            //Add Observer to check if the user has been verified
            TRApplicationManager.sharedInstance.fireBaseManager?.addUserObserverWithCompletion({ (didCompelete) in
                
            })
        })
    }

    func appLoading () {
        
        if let _ = self.branchLinkData {
            //TRApplicationManager.sharedInstance.bungieVarificationHelper.branchLinkData = self.branchLinkData
        }
        
        
        if TRUserInfo.isUserLoggedIn() == false {
            _ = TRPublicFeedRequest().getPublicFeed({ (didSucceed) in
                let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
                let vc : TRLoginOptionViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEWCONTROLLER_LOGIN_OPTIONS) as! TRLoginOptionViewController
                let navigationController = UINavigationController(rootViewController: vc)
                navigationController.navigationBar.hidden = true
                self.presentViewController(navigationController, animated: true, completion: {
                    
                })
            })
        } else {
            
            let defaults = NSUserDefaults.standardUserDefaults()
            var console = [String: AnyObject]()
            let userName = defaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_UserName) as? String
            let userPW   = defaults.objectForKey(K.UserDefaultKey.UserAccountInfo.TR_UserPwd) as? String
            console["userName"] = userName
            console["passWord"] = userPW
            
            let createRequest = TRAuthenticationRequest()
            createRequest.showActivityIndicator = false
            createRequest.showActivityIndicatorBgClear = true
            
            createRequest.loginTRUserWith(console, password: userName, invitationDict: nil) { (error, responseObject) in
                if let _ = error {
                    //Delete the saved Password if sign-in was not successful
                    defaults.setValue(nil, forKey: K.UserDefaultKey.UserAccountInfo.TR_UserPwd)
                    defaults.synchronize()
                    
                    // Add Error View
                    let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
                    let vc : TRSignInErrorViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_SIGNIN_ERROR) as! TRSignInErrorViewController
                    vc.userName = userName
                    vc.signInError = error
                    
                    self.navigationController?.pushViewController(vc, animated: true)
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
            }
        }
    }
    
    
    @IBAction func trUnwindAction(segue: UIStoryboardSegue) {
        
    }
}

