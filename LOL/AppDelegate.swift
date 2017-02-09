//
//  AppDelegate.swift
//  Overwatch
//
//  Created by Marin, Jonathan on 1/11/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import UIKit
import Branch
import Mixpanel
import FBSDKCoreKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var faceBookAdLink: Dictionary <String, String>?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        //RootViewController
        let rootViewController = self.window?.rootViewController as! TRRootViewController
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let isInstallInfoSent = userDefaults.boolForKey(K.UserDefaultKey.INSTALL_INFO_SENT)
        if isInstallInfoSent == false {
            rootViewController.shouldLoadInitialViewDefault = false
        }
        
        
        //Initializing Manager
        TRApplicationManager.sharedInstance
        
        //Initialize FireBase Configuration
        TRApplicationManager.sharedInstance.fireBaseManager?.initFireBaseConfig()
        
        //Local Notifications
        let localNotification:UILocalNotification = UILocalNotification()
        localNotification.alertAction = "Testing notifications on iOS8"
        localNotification.fireDate = NSDate(timeIntervalSinceNow: 10)
        UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        
        
        //Status Bar
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        
        
        //MixedPanel Initialized
        let token = K.Tokens.Mix_Panle_Token
        _ = Mixpanel.sharedInstanceWithToken(token)
        
        //Clear Notifications
        application.applicationIconBadgeNumber = 1
        application.applicationIconBadgeNumber = 0

        //Initialize Answers
        Fabric.with([Branch.self, Answers.self, Crashlytics.self])
        
        
        //Facebook Init
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
        //Branch Initialized
        let branch: Branch = Branch.getInstance()
        branch.initSessionWithLaunchOptions(launchOptions, andRegisterDeepLinkHandler: { params, error in
            
            if let isBranchLink = params?["+clicked_branch_link"]?.boolValue where  isBranchLink == true {
                
                // Tracking Open Source
                var mySourceDict = [String: AnyObject]()
                mySourceDict["source"] = K.SharingPlatformType.Platform_Branch
                _ = TRAppTrackingRequest().sendApplicationPushNotiTracking(mySourceDict, trackingType: APP_TRACKING_DATA_TYPE.TRACKING_APP_INIT, completion: {didSucceed in
                    if didSucceed == true {
                        
                    }
                })
                
                let userDefaults = NSUserDefaults.standardUserDefaults()
                let isInstallInfoSent = userDefaults.boolForKey(K.UserDefaultKey.INSTALL_INFO_SENT)
                if isInstallInfoSent.boolValue == false {
                    
                    // App Install Request
                    let myInstallDict = [String: AnyObject]()
                    mySourceDict["ads"] = K.SharingPlatformType.Platform_Branch
                    
                    self.appInstallRequestWithDict(myInstallDict) { (didSucceed) in
                        if didSucceed == true {
                            
                        }
                    }
                } else {
                    var mySourceDict = [String: AnyObject]()
                    mySourceDict["source"] = K.SharingPlatformType.Platform_Branch
                    self.appInitializedRequest(mySourceDict)
                }
                
                
                
                
                if let inviPlayer = params?["invitees"] as? String,
                let eventID = params?["eventId"] as? String,
                let activityName = params?["activityName"] as? String {
                    let invi = TRInvitationInfo()
                    invi.eventID = eventID
                    invi.invitedPlayers = inviPlayer
                    
                    TRApplicationManager.sharedInstance.invitation = invi
                    TRApplicationManager.sharedInstance.addPostActionbranchDeepLink(eventID, activityName: activityName, params: params!)
                }
            }
        })
        
        
        // App Install Reque
        if isInstallInfoSent == false {
            var myInstallDict = [String: AnyObject]()
            myInstallDict["ads"] = K.SharingPlatformType.Platform_Organic
            
            self.appInstallRequestWithDict(myInstallDict) { (didSucceed) in
                if didSucceed == true {
                    
                    //Send FaceBook Install Info, if avalable
                    if let _ = self.faceBookAdLink {
                        self.sendFaceBookAdsInstallInfo()
                    }
                    
                    //Load View
                    //rootViewController.loadAppInitialViewController()
                    rootViewController.shouldLoadInitialViewDefault = true
                    
                    // App Initialized Request
                    var mySourceDict = [String: AnyObject]()
                    mySourceDict["source"] = K.SharingPlatformType.Platform_UnKnown
                    self.appInitializedRequest(mySourceDict)
                } else {
                    //Load View
                    //rootViewController.loadAppInitialViewController()
                    rootViewController.shouldLoadInitialViewDefault = true
                }
            }
        } else {
            
            // App Initialized Request
            var mySourceDict = [String: AnyObject]()
            mySourceDict["source"] = K.SharingPlatformType.Platform_UnKnown
            self.appInitializedRequest(mySourceDict)
        }
        
        // Remote Notification
        if let remoteNotification = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? NSDictionary? {
            rootViewController.pushNotificationData = remoteNotification
        }
        return true
    }

    // MARK:- Branch Deep Linking related methods
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        
        if (Branch.getInstance().handleDeepLink(url)) {
            var mySourceDict = [String: AnyObject]()
            mySourceDict["source"] = K.SharingPlatformType.Platform_Branch
            self.appInitializedRequest(mySourceDict)
        }
        
        
        FBSDKAppLinkUtility.fetchDeferredAppLink({ (URL, error) -> Void in
            if error != nil {
            }
            if URL != nil {
                
                let urlString = URL.absoluteString
                let deepLinkObj = TRDeepLinkObject(link: urlString)
                let deepLinkAnalyticsDict = deepLinkObj.createLinkInfoAndPassToBackEnd()
                
                if let _ = deepLinkAnalyticsDict {
                    self.faceBookAdLink = deepLinkAnalyticsDict
                }
            }
        })
        
        return true
    }
    
    func application(application: UIApplication, continueUserActivity userActivity: NSUserActivity, restorationHandler: ([AnyObject]?) -> Void) -> Bool {
        Branch.getInstance().continueUserActivity(userActivity);
        
        if userActivity.activityType == NSUserActivityTypeBrowsingWeb {
            //let url = userActivity.webpageURL!
        }
        
        return true
    }
    
    
    // MARK:- Notifications
    func addNotificationsPermission () {
        if UIApplication.sharedApplication().respondsToSelector(#selector(UIApplication.registerUserNotificationSettings(_:))) {
            
            let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: [])
            
            UIApplication.sharedApplication().registerUserNotificationSettings(settings)
            UIApplication.sharedApplication().registerForRemoteNotifications()
        } else {
            UIApplication.sharedApplication().registerForRemoteNotifications()
        }
    }
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
        
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        for i in 0 ..< deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        
        _ = TRDeviceTokenRequest().sendDeviceToken(tokenString, completion: { (value) -> () in
            if (value == true) {
                print("Device token registration Success")
            } else {
                print("Device token registration failed")
            }
        })
    }
    
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: NSError) {
        if error.code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    func application(application: UIApplication, didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings) {
        
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
        
        if application.applicationState == UIApplicationState.Active {
            NSNotificationCenter.defaultCenter().postNotificationName(K.NOTIFICATION_TYPE.REMOTE_NOTIFICATION_WITH_ACTIVE_SESSION, object: self, userInfo: userInfo)
        }
        if application.applicationState != UIApplicationState.Active {
            NSNotificationCenter.defaultCenter().postNotificationName(K.NOTIFICATION_TYPE.APPLICATION_DID_RECEIVE_REMOTE_NOTIFICATION, object: self, userInfo: userInfo)
        }
    }
    
    
    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        // Tracking App Init
        _ = TRAppTrackingRequest().sendApplicationPushNotiTracking(nil, trackingType: APP_TRACKING_DATA_TYPE.TRACKING_APP_RESUME, completion: {didSucceed in
            if didSucceed == true {
                
            }
        })
    }
    
    func applicationDidBecomeActive(application: UIApplication) {
        //FBSDKAppEvents.activateApp()
    }
    
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    //MARK:- App Data Requests
    func appInitializedRequest (initInfo: Dictionary<String, AnyObject>) {
        _ = TRAppTrackingRequest().sendApplicationPushNotiTracking(initInfo, trackingType: APP_TRACKING_DATA_TYPE.TRACKING_APP_INIT, completion: {didSucceed in
            
            if didSucceed == true {
                
            }
        })
    }
    
    func appInstallRequestWithDict (installInfo: Dictionary<String, AnyObject>, completion: TRValueCallBack) {
        
        _ = TRAppTrackingRequest().sendApplicationPushNotiTracking(installInfo, trackingType: APP_TRACKING_DATA_TYPE.TRACKING_APP_INSTALL, completion: {didSucceed in
            if didSucceed == true {
                let userDefaults = NSUserDefaults.standardUserDefaults()
                userDefaults.setBool(true, forKey: K.UserDefaultKey.INSTALL_INFO_SENT)
                userDefaults.synchronize()
                
                completion(didSucceed: true)
            }
        })
    }
    
    func sendFaceBookAdsInstallInfo () {
        
        if let _ = self.faceBookAdLink {
            self.appInstallRequestWithDict(self.faceBookAdLink!) { (didSucceed) in
                if didSucceed == true {
                    
                }
            }
        }
    }
}

