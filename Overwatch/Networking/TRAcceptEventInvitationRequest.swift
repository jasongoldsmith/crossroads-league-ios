//
//  TRAcceptEventInvitationRequest.swift
//  Traveler
//
//  Created by Ashutosh on 11/5/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation

class TRAcceptEventInvitationRequest: TRRequest {
    
    func acceptInvitationRequest (eventID: String, completion: TREventObjCallBackWithError) {
        let requestURL = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_ACCEPT_INVITATION
        
        let request = TRRequest()
        request.requestURL = requestURL
        
        var params = [String: AnyObject]()
        params["eId"] = eventID
        request.params = params
        
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            
            if let _ = error {
                completion(error: error!, event: nil)
                return
            }
            
            let eventObj = TREventInfo().parseCreateEventInfoObject(swiftyJsonVar)
            completion(error: nil, event: eventObj)
        }
    }
}