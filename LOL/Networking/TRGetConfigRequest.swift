//
//  TRGetConfigRequest.swift
//  Traveler
//
//  Created by Ashutosh on 11/2/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import SwiftyJSON

class TRGetConfigRequest: TRRequest {
    
    func getConfiguration (completion: TRValueCallBack) {
        let configuration = K.TRUrls.TR_BaseUrl + K.TRUrls.TR_CONFIGURATION
        
        let request = TRRequest()
        request.requestURL = configuration
        request.URLMethod = .GET
        request.showActivityIndicator = false
        request.sendRequestWithCompletion { (error, swiftyJsonVar) -> () in
            
            if let _ = error {
                completion(didSucceed: false)
                return
            }
            
            let appConfig = TRConfigInfo()
            appConfig.mixPanelToken = swiftyJsonVar["mixpanelToken"].stringValue
            appConfig.regionDict = swiftyJsonVar["LolRegions"].dictionary
            
            
            TRApplicationManager.sharedInstance.appConfiguration = appConfig
            if let onBoardingScreens = swiftyJsonVar["onBoardingScreens"] as JSON? {
                self.parseAndSaveOnBoardingScreens(onBoardingScreens)
            } else {
                self.addDefaultCards()
            }

            completion(didSucceed: true)
        }
    }

    private func parseAndSaveOnBoardingScreens(onBoardingScreens:JSON) {
        if let requiredOnboardingScreens = onBoardingScreens["required"].array {
            var requiredCards = [OnBoardingCard]()
            for requiredOnboardingScreen in requiredOnboardingScreens {
                let newCard = OnBoardingCard()
                newCard.parse(requiredOnboardingScreen)
                requiredCards.append(newCard)
            }
            requiredCards.sortInPlace { $0.order < $1.order}
            TRApplicationManager.sharedInstance.onBoardingCards.appendContentsOf(requiredCards)
        }
        if let optionalOnboardingScreens = onBoardingScreens["optional"].array {
            var optionalCards = [OnBoardingCard]()
            for optionalOnboardingScreen in optionalOnboardingScreens {
                let newCard = OnBoardingCard()
                newCard.parse(optionalOnboardingScreen)
                optionalCards.append(newCard)
            }
            optionalCards.sortInPlace { $0.order < $1.order}
            TRApplicationManager.sharedInstance.onBoardingCards.appendContentsOf(optionalCards)
        }
    }
    
    private func addDefaultCards() {
        for i in 1...4 {
            let newCard = OnBoardingCard()
            let fakeview = UIView(frame:CGRect(x:0, y:0, width:10, height:10))
            var color:UIColor!
            switch i {
            case 2:
                color = UIColor.blueColor()
            case 3:
                color = UIColor.greenColor()
            default:
                color = UIColor.orangeColor()
            }
            fakeview.backgroundColor = color
            newCard.backgroundImage.image = fakeview.createImageFromView()
            newCard.heroImage.image = UIImage(named:"imgHero0\(i)")
            newCard.textImage.image = UIImage(named:"imgTextCard0\(i)")
            TRApplicationManager.sharedInstance.onBoardingCards.append(newCard)
        }
    }
}