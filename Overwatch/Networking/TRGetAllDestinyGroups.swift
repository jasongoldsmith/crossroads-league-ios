//
//  TRGetAllDestinyGroups.swift
//  Traveler
//
//  Created by Ashutosh on 5/18/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit
import Alamofire

class TRGetAllDestinyGroups: TRRequest {

    func getAllGroups (completion: TRValueCallBack) {
        let appGetGroups = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_GET_GROUPS
        
        let request = TRRequest()
        request.params = params
        request.requestURL = appGetGroups
        request.URLMethod = .GET
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            
            if let _ = error {
                completion(didSucceed: false)
            }
            
            //Remove all pre-saved groups
            TRApplicationManager.sharedInstance.bungieGroups.removeAll()
            
            for group in swiftyJsonVar.arrayValue {
                let bungieGroup = TRBungieGroupInfo()
                bungieGroup.parseAndCreateObj(group)
                TRApplicationManager.sharedInstance.bungieGroups.append(bungieGroup)
            }
            
            completion(didSucceed: true)
        }
    }
}
