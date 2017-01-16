//
//  TRFetchBungieUser.swift
//  Traveler
//
//  Created by Ashutosh on 10/26/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import SwiftyJSON

class TRFetchBungieUser: TRRequest {
    func getBungieUserWith (bungieResponse: AnyObject, clearBackGroundRequest: Bool, consoleType: String, bungieUrl: String, invitationDict: NSDictionary?, completion: TRResponseCallBack) {
        
        let bungieUser = K.TRUrls.TR_BaseUrl + K.TRUrls.BUNGIE_FETCH_USER
        
        let request = TRRequest()
        var params = [String: AnyObject]()
        params["requestType"] = "login"
        params["bungieResponse"] = bungieResponse
        params["consoleType"] = consoleType
        params["bungieURL"] = bungieUrl
        
        if let _ = invitationDict {
            params["invitation"] = invitationDict
        }
        
        request.params = params
        request.showActivityIndicatorBgClear = clearBackGroundRequest
        request.requestURL = bungieUser
        request.viewHandlesError = true
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            
            if let _ = error {
                completion(error: error, responseObject: nil)
                
                return
            }
            
            completion(error: nil, responseObject: swiftyJsonVar)
        }
    }
}