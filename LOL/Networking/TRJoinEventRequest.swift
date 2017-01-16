//
//  TRJoinEventRequest.swift
//  Traveler
//
//  Created by Ashutosh on 3/2/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//


class TRJoinEventRequest: TRRequest {
    
    func joinEventWithUserForEvent (userId: String, eventInfo: TREventInfo, completion: TREventObjCallBack) {
        
        let joinEventUrl = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_JoinEventUrl
        
        var params         = [String: AnyObject]()
        params["eId"]      = eventInfo.eventID
        params["player"]   = userId
        
        let request = TRRequest()
        request.params = params
        request.requestURL = joinEventUrl
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            
            if let _ = error {
                TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("response error")
                completion(event: nil)
                
                return
            }
            
            if let _ = swiftyJsonVar["_id"].string {
                // Creating Event Objects from Events List
                let existingEvent = TRApplicationManager.sharedInstance.getEventById(swiftyJsonVar["_id"].string!)
                
                if let _ = existingEvent {
                    existingEvent?.parseCreateEventInfoObject(swiftyJsonVar)
                }
                            
                completion(event: existingEvent)
            }
        }
    }
}

