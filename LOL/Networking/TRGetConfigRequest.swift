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
            appConfig.regionDict = swiftyJsonVar["LolRegions"].dictionary
            
            
            TRApplicationManager.sharedInstance.appConfiguration = appConfig
            
            completion(didSucceed: true)
        }
    }
}