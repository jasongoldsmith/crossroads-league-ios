//
//  TRRequestUpdateLegalRequest.swift
//  Traveler
//
//  Created by Ashutosh on 8/3/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation


class TRRequestUpdateLegalRequest: TRRequest {
    
    func updateLegalAcceptance (completion: TRValueCallBack) {
        let addLegalUpdate = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_LEGAL_ACCEPTED
        
        let request = TRRequest()
        request.params = params
        request.requestURL = addLegalUpdate
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            
            if let _ = error {
                completion(didSucceed: false)
                
                return
            }
            
            let userData = TRUserInfo()
            userData.parseUserResponse(swiftyJsonVar)
            TRUserInfo.saveUserData(userData)
            
            completion(didSucceed: true )
        }
    }
}