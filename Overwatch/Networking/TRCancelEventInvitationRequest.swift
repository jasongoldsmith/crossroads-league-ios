//
//  TRCancelEventInvitationRequest.swift
//  Traveler
//
//  Created by Ashutosh on 11/5/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation

class TRCancelEventInvitationRequest: TRRequest {
    
    func cancelInvitationRequest (eventID: String, playerID: String, completion: TRResponseCallBack) {
        let requestURL = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_CANCEL_INVITATION
        
        let request = TRRequest()
        request.requestURL = requestURL
        
        var params = [String: AnyObject]()
        params["eId"] = eventID
        params["userId"] = playerID
        request.params = params
        
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            
            if let _ = error {
                completion(error: error, responseObject: nil)
                return
            }
            
            completion(error: nil, responseObject: swiftyJsonVar)
        }
    }
}