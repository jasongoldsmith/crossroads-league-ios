//
//  ExSlideMenuController.swift
//  SlideMenuControllerSwift
//
//  Created by Yuji Hato on 11/11/15.
//  Copyright © 2015 Yuji Hato. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class ExSlideMenuController : SlideMenuController {

    override func isTagetViewController() -> Bool {
        if let vc = self.topViewController() {
            if vc is TRProfileViewController ||
            vc is TRChooseGroupViewController  {
                return true
            }
        }
        return false
    }
    
    override func track(trackAction: TrackAction) {
        switch trackAction {
        case .LeftTapOpen:
            print("TrackAction: left tap open.")
        case .LeftTapClose:
            print("TrackAction: left tap close.")
        case .LeftFlickOpen:
            print("TrackAction: left flick open.")
        case .LeftFlickClose:
            print("TrackAction: left flick close.")
        case .RightTapOpen:
            print("TrackAction: right tap open.")
        case .RightTapClose:
            print("TrackAction: right tap close.")
        case .RightFlickOpen:
            print("TrackAction: right flick open.")
        case .RightFlickClose:
            print("TrackAction: right flick close.")
        }   
    }
    
    func topViewController(viewController: UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController) -> UIViewController? {
        if let nav = viewController as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }
        if let tab = viewController as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let presented = viewController?.presentedViewController {
            return topViewController(presented)
        }
        
        if let slide = viewController as? SlideMenuController {
            return topViewController(slide.mainViewController)
        }
        return viewController
    }
}
