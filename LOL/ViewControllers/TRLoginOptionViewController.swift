//
//  TRLoginOptionViewController.swift
//  Traveler
//
//  Created by Rangarajan, Srivatsan on 2/19/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit
import iCarousel
import TTTAttributedLabel


class TRLoginOptionViewController: TRBaseViewController, iCarouselDataSource, iCarouselDelegate, CustomErrorDelegate {
    
    
    var items: [TREventInfo] = TRApplicationManager.sharedInstance.eventsList
    @IBOutlet weak var playerCountLabel: UILabel!
    @IBOutlet weak var carousel : iCarousel!
    @IBOutlet weak var playStationButton: UIButton!
    @IBOutlet weak var xBoxButton: UIButton!
    @IBOutlet weak var crossRdLogo: UIImageView!
    @IBOutlet weak var signInLabel: UILabel!
    @IBOutlet weak var playerCountLabelTopConst: NSLayoutConstraint!
    @IBOutlet weak var crossRdLogoTopConst: NSLayoutConstraint!
    @IBOutlet weak var crossRdLogoWidthConst: NSLayoutConstraint!
    @IBOutlet weak var crossRdLogoHeightConst: NSLayoutConstraint!
    @IBOutlet weak var crossRdLogoCenterConst: NSLayoutConstraint!
    
    @IBOutlet weak var bottomBtnHeightConst: NSLayoutConstraint!
    @IBOutlet weak var signInLebelBottomConst: NSLayoutConstraint!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let countString = TRApplicationManager.sharedInstance.totalUsers?.description
        let stringColorAttribute = [NSForegroundColorAttributeName: UIColor(red: 189/255, green: 178/255, blue: 129/255, alpha: 1)]
        var countAttributedStr = NSAttributedString(string: countString!, attributes: stringColorAttribute)
        let helpAttributedStr = NSAttributedString(string: " summoners searching for teams:", attributes: nil)
        
        if TRApplicationManager.sharedInstance.totalUsers < 1 {
            countAttributedStr = NSAttributedString(string: "", attributes: nil)
        }

        let finalString:NSMutableAttributedString = countAttributedStr.mutableCopy() as! NSMutableAttributedString
        finalString.appendAttributedString(helpAttributedStr)

        self.playerCountLabel.attributedText = finalString
        self.carousel?.autoscroll = -0.1
        
        if DeviceType.IS_IPHONE_4_OR_LESS || DeviceType.IS_IPHONE_5 {
            self.crossRdLogoTopConst?.constant = 90
            self.crossRdLogoWidthConst?.constant = 165
            self.crossRdLogoHeightConst?.constant = 106
            self.playerCountLabelTopConst?.constant  = 6
            self.bottomBtnHeightConst?.constant = 80
            self.signInLebelBottomConst?.constant = 10
            self.crossRdLogoCenterConst?.constant = -1
            
            self.signInLabel.font = UIFont(name:"HelveticaNeue-Medium", size: 11)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func xBoxTapped(sender: AnyObject) {
        
        _ = TRAppTrackingRequest().sendApplicationPushNotiTracking(nil, trackingType: APP_TRACKING_DATA_TYPE.TRACKING_SIGNUP_INIT, completion: {didSucceed in
            if didSucceed == true {
                
            }
        })

        let storyboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
        let registerCrossroads = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_LOGIN) as! TRSignInViewController
        registerCrossroads.isUserRegistering = true
        self.navigationController?.pushViewController(registerCrossroads, animated: true)
    }
    
    @IBAction func playStationTapped(sender: AnyObject) {
    }
    
    
    @IBAction func trUnwindActionToLoginOption(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func showOnBoardingController(sender: AnyObject) {
        if TRApplicationManager.sharedInstance.onBoardingCards.count != 0 {
            let storyboard : UIStoryboard = UIStoryboard(name: K.StoryBoard.StoryBoard_Main, bundle: nil)
            let vc : OnBoardingViewController = storyboard.instantiateViewControllerWithIdentifier(K.VIEWCONTROLLER_IDENTIFIERS.VIEW_CONTROLLER_ON_BOARDING) as! OnBoardingViewController
            self.presentViewController(vc, animated: true, completion: nil)
        }
    }

    //MARK:- carousel
    func numberOfItemsInCarousel(carousel: iCarousel) -> Int {
        return items.count
    }

    func carousel(carousel: iCarousel, viewForItemAtIndex index: Int, reusingView view: UIView?) -> UIView {
       
        var itemView: TRCaroselCellView
        
        //create new view if no view is available for recycling
        if (view == nil) {
            itemView = NSBundle.mainBundle().loadNibNamed("TRCaroselCellView", owner: self, options: nil)[0] as! TRCaroselCellView
        } else {
            itemView = view as! TRCaroselCellView
        }
        
        itemView.updateViewWithActivity(items[index])
        return itemView
    }
    
    func carousel(carousel: iCarousel, valueForOption option: iCarouselOption, withDefault value: CGFloat) -> CGFloat {
        
        switch (option)
        {
        case .Wrap:
            return 1
        case .Spacing:
            if DeviceType.IS_IPHONE_4_OR_LESS || DeviceType.IS_IPHONE_5 {
                return value * 1.018
            }
            return value * 1.04
        case .VisibleItems:
            return 3
        default:
            return value
        }
    }
}


