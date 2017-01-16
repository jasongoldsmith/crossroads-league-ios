//
//  TRAdCardInfo.swift
//  Traveler
//
//  Created by Ashutosh on 7/26/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import SwiftyJSON

class TRAdCardInfo: NSObject {
    
    var adCardBaseUrl      : String?
    var adCardImageURL     : String?
    var adCardCardHeader   : String?
    var adCardSubHeader    : String?
    var adCardIsAdCard     : Bool?

    func parseAndCreateActivityObject (swiftyJson: JSON) -> TRAdCardInfo {
        
        self.adCardBaseUrl      = swiftyJson["adCardBaseUrl"].stringValue
        self.adCardImageURL     = swiftyJson["adCardImagePath"].stringValue
        self.adCardCardHeader   = swiftyJson["adCardHeader"].stringValue
        self.adCardSubHeader    = swiftyJson["adCardSubHeader"].stringValue
        self.adCardIsAdCard     = swiftyJson["isAdCard"].boolValue
        
        return self
    }
}