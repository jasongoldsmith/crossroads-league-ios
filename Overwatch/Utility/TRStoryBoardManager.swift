//
//  TRStoryBoardManager.swift
//  Traveler
//
//  Created by Ashutosh on 2/25/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit

class TRStoryBoardManager {
    
    func getStroryBoardWithID(storyBoardId: String) -> AnyObject? {
        return UIStoryboard(name: storyBoardId, bundle: nil)
    }
    
    func getViewControllerWithID(viewControllerID: String, storyBoardID: String) -> TRBaseViewController {
        let storyboard: UIStoryboard = UIStoryboard(name: storyBoardID, bundle: nil)
        return storyboard.instantiateViewControllerWithIdentifier(viewControllerID) as! TRBaseViewController
    }
    
    deinit {
        print("de-init")
    }
}