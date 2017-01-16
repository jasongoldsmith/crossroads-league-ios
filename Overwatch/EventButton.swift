//
//  EventButton.swift
//  Traveler
//
//  Created by Ashutosh on 2/29/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit

class EventButton: UIButton {
    
    var buttonEventInfo     : TREventInfo?
    var buttonActivityInfo  : TRActivityInfo?
    var buttonPlayerInfo    : TRPlayerInfo?
    var buttonGroupInfo     : TRBungieGroupInfo?
    var activityTypeString  : Activity_Type?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
