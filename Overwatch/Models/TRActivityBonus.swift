//
//  TRActivityBonus.swift
//  Traveler
//
//  Created by Ashutosh on 8/10/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import SwiftyJSON

class TRActivityBonus: NSObject {
    
    var aId: String?
    var aBonusName: String?
    var aBonusInfo: String?
    var aIsActive: String?
    
    func parseActivityBonus (activityBonus: JSON) {
     
        self.aId = activityBonus["_id"].stringValue
        self.aIsActive = activityBonus["isActive"].stringValue
        self.aBonusName = activityBonus["aBonusName"].stringValue
        self.aBonusInfo = activityBonus["aBonusInfo"].stringValue
    }
}