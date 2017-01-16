//
//  TRSendPushMessage.swift
//  Traveler
//
//  Created by Ashutosh on 3/29/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//


class TRSendPushMessage: TRRequest {
    
    func sendEventMessage (eventId: String, messageString: String, completion: TRValueCallBack) {
        
        let pushMessage = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_SEND_MESSAGE
        var params = [String: AnyObject]()
        params["eId"]       = eventId
        params["text"]   = messageString
        
        let request = TRRequest()
        request.params = params
        request.requestURL = pushMessage
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            
            if let _ = error {
                TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("response error")
                completion(didSucceed: false)
                
                return
            }
            
            completion(didSucceed: true )
        }
    }
}

