//
//  TRValidateUserRequest.swift
//  LOL
//
//  Created by Ashutosh on 1/17/17.
//  Copyright © 2017 Catalyst Foundry LLC. All rights reserved.
//

import Foundation

class TRValidateUserRequest: TRRequest {
    
    func validateUser(summonerName: String, region: String, completion: TRValueCallBack) {
        
        let validateUserUrl = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_Validate_User
        var params = [String: AnyObject]()
        params["consoleId"] = summonerName
        params["region"] = region
        params["_comments"] = "for a list of possible values use /api/v1/config"
        
        let request = TRRequest()
        request.params = params
        request.URLMethod = .GET
        request.requestURL = validateUserUrl
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            
            if let _ = error {
                print("Error Happened")
            }
            
            let userData = TRUserInfo()
            userData.parseUserResponse(swiftyJsonVar)
            TRUserInfo.saveUserData(userData)

            if let _ = userData.userID where userData.userID != "" {
                completion(didSucceed: true)
            }
            
            completion(didSucceed: false)
        }
    }
}

