//
//  TRInviteRequestToBungie.swift
//  Traveler
//
//  Created by Ashutosh on 11/3/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import SwiftyJSON

class TRInviteRequestToBungie: NSObject {
    
    func inviteFriendRequestToBungie (bungieUrl: String, requestBody: JSON, completion: TRBungieResponseStringCallBack) {
        
        let bodyDict = requestBody.dictionaryObject
        let data = try! NSJSONSerialization.dataWithJSONObject(bodyDict!, options: [])
        let jsons = NSString(data: data, encoding: NSUTF8StringEncoding)
        
        TRApplicationManager.sharedInstance.bungieAlamoFireManager?.request(.POST, bungieUrl, parameters: [:], encoding: .Custom({
            (convertible, params) in
            let mutableRequest = convertible.URLRequest.copy() as! NSMutableURLRequest
            mutableRequest.HTTPBody = jsons!.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            return (mutableRequest, nil)
        }))
            .response { request, response, data, error in
                if let _ = data {
                    let json = JSON(data: data!).dictionaryObject
                    completion(responseObject: nil, responseDict: json)
                }
        }
    }
}