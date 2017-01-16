//
//  TRGetEventRequest.swift
//  Traveler
//
//  Created by Ashutosh on 6/24/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation


class TRGetEventRequest: TRRequest {

    func getEventByID (eventID: String, completion: TREventObjCallBackWithError) {
        self.getEventByID(eventID, viewHandlesError: false, completion: completion)
    }
    
    func getEventByID (eventID: String, viewHandlesError: Bool, completion: TREventObjCallBackWithError) {
        self.getEventByID(eventID, viewHandlesError: viewHandlesError, showActivityIndicator: false, completion: completion)
    }
    
    func getEventByID (eventID: String, viewHandlesError: Bool, showActivityIndicator: Bool, completion: TREventObjCallBackWithError) {
        
        let eventInfoULR = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_GET_EVENT
        var params = [String: AnyObject]()
        params["id"] = eventID
        
        let request = TRRequest()
        request.params = params
        request.requestURL = eventInfoULR
        request.viewHandlesError = viewHandlesError
        request.showActivityIndicator = showActivityIndicator
        
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