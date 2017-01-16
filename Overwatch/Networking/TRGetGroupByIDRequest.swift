//
//  TRGetGroupByIDRequest.swift
//  Traveler
//
//  Created by Ashutosh on 5/20/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import SwiftyJSON

class TRGetGroupByIDRequest: TRRequest {

    func getGroupByID (groupID: String, completion: TRValueCallBack) {
        
        let getGroupUrl = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_GET_GROUP_BY_ID + groupID

        let request = TRRequest()
        request.URLMethod = .GET
        request.requestURL = getGroupUrl
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            
            if let _ = error {
                TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("response error")
                completion(didSucceed: false)
                
                return
            }
            
            let bungieGroup = TRBungieGroupInfo()
            bungieGroup.parseAndCreateObj(swiftyJsonVar)
            
            completion(didSucceed: true )
        }
    }
}
