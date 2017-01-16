//
//  TRBungieLoginValidation.swift
//  Traveler
//
//  Created by Ashutosh on 10/28/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


@objc protocol TRBungieLoginValidationProtocol {
    optional func userObjResponseReceived(shouldDismiss: Bool)
}

class TRBungieLoginValidation {
    
    var selectedConsoleType: String?
    var bungieID: String?
    var bungieCookies: [NSHTTPCookie]? = []
    var alamoFireManager : Alamofire.Manager?
    var branchLinkData: NSDictionary? = nil
    
    
    func shouldShowLoginSceen (completion: TRSignInCallBack, clearBackGroundRequest: Bool) {
        
        _ = TRGetConfigRequest().getConfiguration({ (didSucceed) in
            let cookies = NSHTTPCookieStorage.sharedHTTPCookieStorage().cookies
            if let _ = cookies {
                for cookie in cookies! {
                    if cookie.name == "bungleatk" || cookie.name == "bungledid" {
                        self.bungieCookies?.append(cookie)
                    } else if cookie.name == "bungled" {
                        self.bungieID = cookie.value
                        self.bungieCookies?.append(cookie)
                    }
                }
            }
            
            self.getUserFromTravelerBackEndWithSuccess({ (showLoginScreen, error) in
                completion(showLoginScreen: showLoginScreen, error: error)
                }, clearBackGroundRequest: true)
            
        })
    }
    
    func getUserFromTravelerBackEndWithSuccess (completion: TRSignInCallBack, clearBackGroundRequest: Bool) {
        
        var p: Dictionary <String, AnyObject> = Dictionary()
        p["x-api-key"] = "f091c8d36c3c4a17b559c21cd489bec0" as AnyObject?
        p["x-csrf"] = self.bungieID as AnyObject?
        p["cookie"] = self.bungieCookies as AnyObject?
        
        var playerDetUrl = ""
        let appConfig = NSUserDefaults.standardUserDefaults().objectForKey(K.UserDefaultKey.APPLICATION_CONFIGURATIONS_PLAYER_DETAIL) as? String
        if let _ = appConfig {
            playerDetUrl = appConfig!
        }
        if let detailUrl = TRApplicationManager.sharedInstance.appConfiguration!.playerDetailsUrl {
            playerDetUrl = detailUrl
        }
        
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        configuration.HTTPAdditionalHeaders = p
        TRApplicationManager.sharedInstance.bungieAlamoFireManager = Alamofire.Manager(configuration: configuration)
        TRApplicationManager.sharedInstance.bungieAlamoFireManager!.request(.GET, NSURL(string: playerDetUrl)!, parameters: nil)
            .responseJSON { response in
                
                if let responseValue = response.result.value {
                    
                    if responseValue["Message"]!!.description == "Please sign-in to continue." {
                        completion(showLoginScreen: true, error: nil)
                        return
                    }
                    
                    var console = ""
                    if let selectedConsole = TRApplicationManager.sharedInstance.bungieVarificationHelper.selectedConsoleType {
                        console = selectedConsole
                    } else {
                        if let _ = TRUserInfo.getConsoleType() {
                            console = TRUserInfo.getConsoleType()!
                        }
                    }
                    
                    _ = TRFetchBungieUser().getBungieUserWith(response.result.value!, clearBackGroundRequest: clearBackGroundRequest, consoleType: console, bungieUrl: playerDetUrl, invitationDict: self.branchLinkData, completion: { (error, responseObject) in
                        
                        if let  _ = error {
                            completion(showLoginScreen: false, error: error)
                            
                            return
                        }
                        
                        let userData = TRUserInfo()
                        userData.parseUserResponse(responseObject)
                        
                        for console in userData.consoles {
                            if console.isPrimary == true {
                                TRUserInfo.saveConsolesObject(console)
                            }
                        }
                        
                        TRUserInfo.saveUserData(userData)
                        NSNotificationCenter.defaultCenter().postNotificationName(K.NOTIFICATION_TYPE.USER_DATA_RECEIVED_CLOSE_WEBVIEW, object: nil)
                        
                        completion(showLoginScreen: false, error: nil)
                    })
                }
        }
    }
}