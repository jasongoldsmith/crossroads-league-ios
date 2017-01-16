//
//  NSBundleExtension.swift
//  Traveler
//
//  Created by Ashutosh on 4/18/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit

extension NSBundle {
    
    var releaseVersionNumber: String? {
        return self.infoDictionary?["CFBundleShortVersionString"] as? String
    }
    
    var buildVersionNumber: String? {
        return self.infoDictionary?["CFBundleVersion"] as? String
    }
    
}