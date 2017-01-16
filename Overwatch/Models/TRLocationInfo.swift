//
//  TRLocationInfo.swift
//  Traveler
//
//  Created by Ashutosh on 8/17/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import SwiftyJSON


class TRLocationInfo: NSObject {

    var aSubLocation: String?
    var aDirectorLocation: String?
    
    func parseLocationDict (locationDict: JSON) {
        self.aSubLocation = locationDict["aSubLocation"].stringValue
        self.aDirectorLocation = locationDict["aDirectorLocation"].stringValue
    }
}