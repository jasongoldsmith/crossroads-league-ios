//
//  TRActivityModifiersInfo.swift
//  Traveler
//
//  Created by Ashutosh on 8/10/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import SwiftyJSON

class TRActivityModifiersInfo: NSObject {
    
    var aId: String?
    var aModifierName: String?
    var aModifierInfo: String?
    var aIsActive: String?
    
    func parseActivityModifiers (activityModifiers: JSON) {
        
        self.aId = activityModifiers["_id"].stringValue
        self.aModifierName = activityModifiers["aModifierName"].stringValue
        self.aModifierInfo = activityModifiers["aModifierInfo"].stringValue
        self.aIsActive = activityModifiers["isActive"].stringValue
    }
}
