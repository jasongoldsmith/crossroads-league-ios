//
//  TRUpdateUser.swift
//  Traveler
//
//  Created by Ashutosh on 4/29/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit

class TRUpdateUser: TRRequest {
    
    func updateUserCredentials(newPassword: String?, oldPassword: String?, newEmail: String?, oldEmail: String?, completion: TRValueCallBack) {
        
        let updateUserUrl = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_UPDATE_CREDENTIALS
        var params = [String: AnyObject]()
        params["newPassWord"] = newPassword
        params["oldPassWord"] = oldPassword
        params["newEmail"] = newEmail
        params["oldEmail"] = oldEmail
        
        let request = TRRequest()
        request.params = params
        request.requestURL = updateUserUrl
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            
            if let _ = error {
                TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("response error")
                completion(didSucceed: false)
                
                return
            }
            
            completion(didSucceed: true )
        }
    }
}
