//
//  TRGetConfigRequest.swift
//  Traveler
//
//  Created by Ashutosh on 11/2/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation


class TRGetConfigRequest: TRRequest {
    
    func getConfiguration (completion: TRValueCallBack) {
        let configuration = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_CONFIGURATION
        
        let request = TRRequest()
        request.requestURL = configuration
        request.URLMethod = .GET
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            
            if let _ = error {
                completion(didSucceed: false)
                return
            }
            
            let appConfig = TRConfigInfo()
            appConfig.mixPanelToken = swiftyJsonVar["mixpanelToken"].stringValue
            appConfig.playerDetailsUrl = swiftyJsonVar["playerDetailsURL"].stringValue
            appConfig.xBoxLoginUrl = swiftyJsonVar["xboxLoginURL"].stringValue
            appConfig.psnLoginUrl = swiftyJsonVar["psnLoginURL"].stringValue
            
            
            if let _ = appConfig.playerDetailsUrl {
                NSUserDefaults.standardUserDefaults().setObject(appConfig.playerDetailsUrl, forKey: K.UserDefaultKey.APPLICATION_CONFIGURATIONS_PLAYER_DETAIL)
            }
            if let _ = appConfig.xBoxLoginUrl {
                NSUserDefaults.standardUserDefaults().setObject(appConfig.xBoxLoginUrl, forKey: K.UserDefaultKey.APPLICATION_CONFIGURATIONS_PSN_URL)
            }
            if let _ = appConfig.psnLoginUrl {
                NSUserDefaults.standardUserDefaults().setObject(appConfig.psnLoginUrl, forKey: K.UserDefaultKey.APPLICATION_CONFIGURATIONS_XBOX_URL)
            }
            
            
            TRApplicationManager.sharedInstance.appConfiguration = appConfig
            
            completion(didSucceed: true)
        }
    }
}