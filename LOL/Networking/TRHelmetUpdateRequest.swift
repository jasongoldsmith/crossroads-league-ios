//
//  TRHelmetUpdateRequest.swift
//  Traveler
//
//  Created by Ashutosh on 7/8/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation


class TRHelmetUpdateRequest: TRRequest {
    
    typealias TRStringValueCallBack = (imageStringUrl: String?) -> ()
    
    func updateHelmetForUser (completion: TRStringValueCallBack) {
        let helmetURL = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_HELMET_UPDATE
        
        let request = TRRequest()
        request.requestURL = helmetURL
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            
            if let _ = error {
                completion(imageStringUrl: nil)
                
                return
            }
            
            let hamletImage = swiftyJsonVar["helmetUrl"].stringValue
            
            //Update User Object with the new image
            if hamletImage != "" {
                TRUserInfo.setUserImageString(hamletImage)
            }
            
            completion(imageStringUrl: hamletImage)
        }
    }
    
}