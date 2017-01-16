//
//  TRGetEventsList.swift
//  Traveler
//
//  Created by Ashutosh on 2/26/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

class TRGetEventsList: TRRequest {
    
    func getEventsListWithClearActivityBackGround (showActivity: Bool, clearBG: Bool, indicatorTopConstraint: CGFloat?, completion: TRValueCallBack) {
        
        let eventListingUrl = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_EventListUrl
        
        let request = TRRequest()
        request.requestURL = eventListingUrl
        request.URLMethod = .GET
        request.showActivityIndicatorBgClear = clearBG
        request.showActivityIndicator = showActivity
        
        var params = [String: AnyObject]()
        params["myEvents"] = "false"

        request.params = params
        
        if let topConstraint = indicatorTopConstraint {
            request.activityIndicatorTopConstraint = topConstraint
        }

        
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            
            if let _ = error {
                TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("response error")
                completion(didSucceed: false)
                
                return
            }

            //Clear the array before fetting
            TRApplicationManager.sharedInstance.eventsList.removeAll()
            TRApplicationManager.sharedInstance.eventsListActivity.removeAll()
            TRApplicationManager.sharedInstance.myCurrentEvents.removeAll()
            TRApplicationManager.sharedInstance.myFutureEvents.removeAll()
            
            
            for events in swiftyJsonVar["currentEvents"].arrayValue {
                let eventInfo = TREventInfo().parseCreateEventInfoObject(events)
                TRApplicationManager.sharedInstance.eventsList.append(eventInfo)
            }

            for events in swiftyJsonVar["futureEvents"].arrayValue {
                let eventInfo = TREventInfo().parseCreateEventInfoObject(events)
                TRApplicationManager.sharedInstance.eventsList.append(eventInfo)
            }

            for events in swiftyJsonVar["adActivities"].arrayValue {
                let activityInfo = TRActivityInfo().parseAndCreateActivityObject(events)
                TRApplicationManager.sharedInstance.eventsListActivity.append(activityInfo)
            }
        
            for events in swiftyJsonVar["myFutureEvents"].arrayValue {
                let activityInfo = TRActivityInfo().parseAndCreateActivityObject(events)
                TRApplicationManager.sharedInstance.myFutureEvents.append(activityInfo)
            }
            
            for events in swiftyJsonVar["myCurrentEvents"].arrayValue {
                let activityInfo = TRActivityInfo().parseAndCreateActivityObject(events)
                TRApplicationManager.sharedInstance.myCurrentEvents.append(activityInfo)
            }
            
            TRApplicationManager.sharedInstance.totalUsers = swiftyJsonVar["totalUsers"].intValue
            
            
            completion(didSucceed: true)
        }
    }
}