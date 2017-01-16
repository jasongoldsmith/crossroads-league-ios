//
//  TRPublicFeedRequest.swift
//  Traveler
//
//  Created by Ashutosh on 9/13/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation

class TRPublicFeedRequest: TRRequest {
   
    func getPublicFeed (completion: TRValueCallBack) {
        let publicFeed = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_PUBLIC_FEED
        
        let request = TRRequest()
        request.requestURL = publicFeed
        request.URLMethod = .GET
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            
            if let _ = error {
                completion(didSucceed: false)
                
                return
            }
            
            //Clear the array before fetting
            TRApplicationManager.sharedInstance.eventsList.removeAll()
            TRApplicationManager.sharedInstance.eventsListActivity.removeAll()
            
            for events in swiftyJsonVar["currentEvents"].arrayValue {
                let eventInfo = TREventInfo().parseCreateEventInfoObject(events)
                if  eventInfo.eventStatus != EVENT_STATUS.FULL.rawValue {
                    TRApplicationManager.sharedInstance.eventsList.append(eventInfo)
                }
            }
            
            for events in swiftyJsonVar["futureEvents"].arrayValue {
                let eventInfo = TREventInfo().parseCreateEventInfoObject(events)
                TRApplicationManager.sharedInstance.eventsList.append(eventInfo)
            }
            
            for events in swiftyJsonVar["adActivities"].arrayValue {
                let activityInfo = TRActivityInfo().parseAndCreateActivityObject(events)
                TRApplicationManager.sharedInstance.eventsListActivity.append(activityInfo)
            }

            TRApplicationManager.sharedInstance.totalUsers = swiftyJsonVar["totalUsers"].intValue
                
            completion(didSucceed: true )
        }
    }

}