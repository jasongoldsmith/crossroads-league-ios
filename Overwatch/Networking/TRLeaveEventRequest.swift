//
//  TRLeaveEventRequest.swift
//  Traveler
//
//  Created by Ashutosh on 3/5/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//


class TRLeaveEventRequest: TRRequest {
    
    func leaveAnEvent (eventInfo: TREventInfo, completion: TREventObjCallBack) {
        
        let leaveEventtUrl = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_LeaveEventUrl
        
        var params = [String: AnyObject]()
        params["eId"]    = eventInfo.eventID
        params["player"] = TRUserInfo.getUserID()
        
        
        
        let request = TRRequest()
        request.params = params
        request.requestURL = leaveEventtUrl
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            
            if let _ = error {
                TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("response error")
                completion(event: nil)
                
                return
            }
            
            guard let _ = swiftyJsonVar["_id"].string else {
                TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("No Event Received")
    
                return
            }
            
            // Creating Event Objects from Events List
            let existingEvent = TRApplicationManager.sharedInstance.getEventById(swiftyJsonVar["_id"].string!)
            
            
            // If there's no creator info in the JSON feed then it means you were the last person in the event and since you left
            // the whole event has been deleted.
            let creatorDict = swiftyJsonVar["creator"].dictionary
            if (creatorDict == nil) {
                if existingEvent != nil {
                    TRApplicationManager.sharedInstance.eventsList.removeAtIndex(TRApplicationManager.sharedInstance.eventsList.indexOf(existingEvent!)!)
                }
                completion(event: existingEvent)
                
                return
            }
            
            if let _ = existingEvent {
                existingEvent?.parseCreateEventInfoObject(swiftyJsonVar)
            }
            
            completion(event: existingEvent)
        }
    }
}