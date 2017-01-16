//
//  TRCreateEventRequest.swift
//  Traveler
//
//  Created by Ashutosh on 3/1/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Alamofire
import SwiftyJSON


class TRCreateEventRequest: TRRequest {
    
    func createAnEventWithActivity (activity: TRActivityInfo, selectedTime: NSDate?, completion: TREventObjCallBack) {
        
        let createEventUrl = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_EventCreationUrl
        
        // Current Player
        let player = TRUserInfo.getUserID()
        
        //Add Parameters
        var params = [String: AnyObject]()
        params["eType"] = activity.activityID!
        params["minPlayers"] = activity.activityMinPlayers!
        params["maxPlayers"] = activity.activityMaxPlayers!
        params["creator"] = TRUserInfo.getUserID()
        params["players"] = ["\(player!)"]
        
        if let hasSelectedTime = selectedTime {
            let formatter = NSDateFormatter();
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ";
            formatter.timeZone = NSTimeZone(abbreviation: "UTC");
            let utcTimeZoneStr = formatter.stringFromDate(hasSelectedTime);
            
            params["launchDate"] = utcTimeZoneStr
        }
        
        // Create Request
        let request = TRRequest()
        request.requestURL = createEventUrl
        request.params = params
        
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            if let _ = error {
                TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("response error")
                completion(event: nil)
                
                return
            }
            
            // Creating Event Objects from Events List
            let eventInfo = TREventInfo().parseCreateEventInfoObject(swiftyJsonVar)
            if let hasEventID = eventInfo.eventID {
                if let eventToUpdate = TRApplicationManager.sharedInstance.getEventById(hasEventID) {
                    let eventIndex = TRApplicationManager.sharedInstance.eventsList.indexOf(eventToUpdate)
                    TRApplicationManager.sharedInstance.eventsList.removeAtIndex(eventIndex!)
                }
            }
            
            TRApplicationManager.sharedInstance.eventsList.insert(eventInfo, atIndex: 0)

            
            completion(event: eventInfo)
        }
    }
}