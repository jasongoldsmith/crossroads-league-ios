//
//  TRVerificationPromptView.swift
//  Traveler
//
//  Created by Ashutosh on 9/14/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import TTTAttributedLabel


@objc protocol VerificationPopUpProtocol {
    optional func showGroups ()
}


class TRVerificationPromptView: UIView, TTTAttributedLabelDelegate {
    
    var delegate: VerificationPopUpProtocol?
    
    @IBOutlet weak var userNameView: UIView!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var startOneLabel: UILabel!
    @IBOutlet weak var startTwoLabel: UILabel!
    @IBOutlet weak var startThreeLabel: UILabel!
    @IBOutlet weak var bungieButton: UIButton!
    @IBOutlet weak var bungieAttLabel: TTTAttributedLabel!
    
    func addVerificationPromptViewWithDelegate (delegate: VerificationPopUpProtocol?) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let window = appDelegate.window
        self.frame = (window?.frame)!
        window?.addSubviewWithLayoutConstraint(self)
        
        if let _ = delegate {
            self.delegate = delegate
        }
        
        self.updateView()
    }

    @IBAction func removeVerificationPromptView () {
        if let _ = self.delegate {
            self.delegate!.showGroups!()
            self.delegate = nil
        }
        
        self.removeFromSuperview()
    }
    
    func updateView () {
        
        self.bungieButton?.titleEdgeInsets = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
        self.userNameView?.layer.cornerRadius = 2.0
        
        var userName = TRUserInfo.getConsoleID()
        if var clanTag = TRApplicationManager.sharedInstance.currentUser?.getDefaultConsole()?.unverDisplayClanTag where clanTag != "" {
            clanTag = " " + "[" + clanTag + "]"
            userName = userName! + clanTag
        }
        
        self.userNameLabel?.text = userName
        self.userImage.roundRectView()
        
        let playerImage = TRApplicationManager.sharedInstance.currentUser?.userImageURL
        if let _ = playerImage where playerImage != "" {
            self.userImage!.sd_setImageWithURL(NSURL(string: playerImage!), placeholderImage: UIImage(named: "default_helmet"))
        }
        
        self.bungieButton?.layer.cornerRadius = 2.0
        
        self.startOneLabel?.text = "\u{02726}"
        self.startTwoLabel?.text = "\u{02726}"
        self.startThreeLabel?.text = "\u{02726}"
        
        //Attributed Label
        let messageString = "Check your messages on Bungie.net for a verification link."
        let bungieLinkName = "Bungie.net"
        self.bungieAttLabel?.text = messageString
        
        // Add HyperLink to Bungie
        let nsString = messageString as NSString
        let range = nsString.rangeOfString(bungieLinkName)
        let url = NSURL(string: "https://www.bungie.net/")!
        let subscriptionNoticeLinkAttributes = [
            NSForegroundColorAttributeName: UIColor(red: 0/255, green: 182/255, blue: 231/255, alpha: 1),
            NSUnderlineStyleAttributeName: NSNumber(bool:true),
            ]
        self.bungieAttLabel?.linkAttributes = subscriptionNoticeLinkAttributes
        self.bungieAttLabel?.addLinkToURL(url, withRange: range)
        self.bungieAttLabel?.delegate = self
    }
    
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        UIApplication.sharedApplication().openURL(url)
    }

    func goToBungie () {
        let url = NSURL(string: "https://www.bungie.net/")!
        UIApplication.sharedApplication().openURL(url)
    }
    
    @IBAction func bungieButtonAction () {
        self.goToBungie()
    }
}

