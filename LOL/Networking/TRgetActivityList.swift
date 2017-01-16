//
//  TRgetActivityList.swift
//  Traveler
//
//  Created by Ashutosh on 3/1/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//


class TRgetActivityList: TRRequest {
    
    func getActivityListofType (aType: String, completion: TRValueCallBack) {
        
        let activityListUrl = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_ActivityListUrl
        
        var params = [String: AnyObject]()
        params["aType"] = aType
        params["includeTags"] = true
        
        let request = TRRequest()
        request.requestURL = activityListUrl
        request.URLMethod = .GET
        request.params = params
        
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            if let _ = error {
                TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("response error")
                completion(didSucceed: false)
                
                return
            }
            
            // Remove all pre-fetched and saved activities
            TRApplicationManager.sharedInstance.activityList.removeAll()
            
            for activity in swiftyJsonVar.arrayValue {
                
                let activityInfo = TRActivityInfo().parseAndCreateActivityObject(activity)
                TRApplicationManager.sharedInstance.activityList.append(activityInfo)
            }
            
            completion(didSucceed: true )
        }
    }
}

