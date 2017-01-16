//
//  TRBungieInvitationCompletionRequest.swift
//  Traveler
//
//  Created by Ashutosh on 11/5/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation


class TRBungieInvitationCompletionRequest: TRRequest {
    
    func sendInvitationCompletionRequest (bungieResponse: Dictionary<String, AnyObject>, pendingEventInvitationId: String, completion: TRValueCallBack) {
        let requestURL = K.TRUrls.TR_BaseUrl + K.TRUrls.BUNGIE_INVI_COMPLETION
        
        let request = TRRequest()
        request.requestURL = requestURL
        
        var params = [String: AnyObject]()
        params["responseType"] = "sendBungieMessage"
        params["gatewayResponse"] = bungieResponse
        params["responseParams"] = pendingEventInvitationId
        request.params = params
        
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            
            if let _ = error {
                completion(didSucceed: false)
                return
            }
            
            
            completion(didSucceed: true)
        }
    }
}