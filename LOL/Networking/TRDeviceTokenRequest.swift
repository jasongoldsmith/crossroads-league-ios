//
//  TRDeviceTokenRequest.swift
//  Traveler
//
//  Created by Ashutosh on 3/11/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//


class TRDeviceTokenRequest: TRRequest {
    
    func sendDeviceToken (deviceToken: String, completion: TRValueCallBack) {
        
        let registerDevice = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_REGISTER_DEVICE
        var params = [String: AnyObject]()
        params["deviceToken"]      = deviceToken
        
        let request = TRRequest()
        request.params = params
        request.requestURL = registerDevice
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

