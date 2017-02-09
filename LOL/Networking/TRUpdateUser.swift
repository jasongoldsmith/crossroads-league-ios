//
//  TRUpdateUser.swift
//  Traveler
//
//  Created by Ashutosh on 4/29/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit

class TRUpdateUser: TRRequest {
    
    func updateUserPassoword(newPassword: String?, oldPassword: String?, completion: TRValueCallBack) {
        
        let updateUserUrl = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_UPDATE_PASSWORD
        var params = [String: AnyObject]()
        params["newPassWord"] = newPassword
        params["oldPassWord"] = oldPassword
        
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
    
    func updateUserEmail(password: String?, newEmail: String?, completion: TRValueCallBack) {
        
        let updateUserUrl = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_CHANGE_EMAIL
        var params = [String: AnyObject]()
        params["passWord"] = password
        params["newEmail"] = newEmail
        
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
