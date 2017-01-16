//
//  TRGetUserRequest.swift
//  Traveler
//
//  Created by Ashutosh on 7/31/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation

class TRGetUserRequest: TRRequest {
    
    typealias TRUserObjectCompletion = (userObject: TRUserInfo?) -> ()
    
    func getUserByID (userId: String, completion: TRUserObjectCompletion) {
        let userInfoULR = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_GET_USER
        var params = [String: AnyObject]()
        params["id"] = userId
        
        
        let request = TRRequest()
        request.params = params
        request.requestURL = userInfoULR
        request.viewHandlesError = viewHandlesError
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            
            if let _ = error {
                completion(userObject: nil)
                return
            }
            
            let userObject = TRUserInfo()
            userObject.parseUserResponse(swiftyJsonVar)
            
            for console in userObject.consoles {
                if console.isPrimary == true {
                    TRUserInfo.saveConsolesObject(console)
                }
            }
            
            TRUserInfo.saveUserData(userObject)
            completion(userObject: userObject)
        }
    }
}