//
//  TRLegalInfo.swift
//  Traveler
//
//  Created by Ashutosh on 8/3/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import SwiftyJSON

class TRLegalInfo: NSObject {
    
    var privacyVersion      : String?
    var termsVersion        : String?
    var termsNeedsUpdate    : Bool?
    var privacyNeedsUpdate  : Bool?
    
    func parseLegalObjectDictionary (responseObject: JSON) {
        
        self.privacyVersion = responseObject["privacyVersion"].stringValue
        self.termsVersion = responseObject["termsVersion"].stringValue
        self.termsNeedsUpdate = responseObject["termsNeedsUpdate"].boolValue
        self.privacyNeedsUpdate = responseObject["privacyNeedsUpdate"].boolValue
    }
}