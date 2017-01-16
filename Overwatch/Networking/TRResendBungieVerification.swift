//
//  TRResendBungieVerification.swift
//  Traveler
//
//  Created by Ashutosh on 5/31/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation

class TRResendBungieVerification: TRRequest {
    
    func resendVerificationRequest (groupID: String, completion: TRValueCallBack) {
        let resendVerification = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_RESEND_VERIFICATION
        
        let request = TRRequest()
        request.params = params
        request.requestURL = resendVerification
        request.URLMethod = .GET
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