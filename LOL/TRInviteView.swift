//
//  TRInviteView.swift
//  Traveler
//
//  Created by Ashutosh on 10/11/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import SwiftyJSON
import pop

@objc protocol InvitationViewProtocol {
    optional func invitationViewClosed ()
    optional func showInviteButton ()
    optional func hideInviteButton ()
    optional func closeViewAndShowEventCreation ()
}

class TRInviteView: UIView, KSTokenViewDelegate, CustomErrorDelegate, KSTokenFieldDelegate {
    
    var keys = [String]()
    var eventInfo: TREventInfo?
    var delegate: InvitationViewProtocol?
    let names: Array<String> = ["ashu", "singh"]
    
    @IBOutlet var tokenView: KSTokenView!
    @IBOutlet weak var inviteButton: UIButton!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var tokenViewContainerBackground:UIImageView!
    @IBOutlet weak var inviteBtnBottomConst:NSLayoutConstraint!
    
    
    func setUpView () {
        self.descriptionLabel?.text = "Inviting players will send a message from\nyou to them on Bungie.net."
        
        self.tokenView.delegate = self
        self.tokenView.placeholder = "Type a Gamertag"
        self.tokenView.maxTokenLimit = 5
        self.tokenView.minimumCharactersToSearch = 100
        self.tokenView.style = .Squared
        self.tokenView.backgroundColor = UIColor(red: CGFloat(32)/CGFloat(255), green: CGFloat(50)/CGFloat(255), blue: CGFloat(54)/CGFloat(255), alpha: 1)
        self.tokenView.searchResultSize = CGSize(width: 0, height: 0)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
    internal func tokenView(token: KSTokenView, performSearchWithString string: String, completion: ((results: Array<AnyObject>) -> Void)?) {
        if (string.characters.isEmpty){
            completion!(results: names)
            return
        }
        
        var data: Array<String> = []
        for value: String in names {
            if value.lowercaseString.rangeOfString(string.lowercaseString) != nil {
                data.append(value)
            }
        }
        completion!(results: data)
    }
    
    internal func tokenView(token: KSTokenView, displayTitleForObject object: AnyObject) -> String {
        return object as! String
    }
    
    internal func tokenView(tokenView: KSTokenView, shouldAddToken token: KSToken) -> Bool {
        if token.title == "f" {
            return false
        }
        return true
    }
    
    func tokenFieldShouldChangeHeight(height: CGFloat) {
        
    }
    
    func tokenFieldTextDidChange(textField: UITextField) {
        // Check Player Required Limit
        let extraPlayersRequiredCount = ((eventInfo!.eventActivity?.activityMaxPlayers?.integerValue)! - (eventInfo!.eventPlayersArray.count))
        if tokenView.tokens()?.count < extraPlayersRequiredCount {
            self.tokenView?.shouldAddTokenFromTextInput = true
        } else {
            self.tokenView?.shouldAddTokenFromTextInput = false
        }
    }
    
    @IBAction func inviteButtonClicked (sender: UIButton) {
        
        guard let _ = self.eventInfo else { return }
        
        self.tokenView.forcedResignFirstResponder()
        
        var playerArray: [String] = []
        for player in (self.tokenView.tokens()?.enumerate())! {
            playerArray.append(player.element.title)
        }
        
        TRApplicationManager.sharedInstance.branchManager?.createInvitationLinkWithBranch(self.eventInfo!, playerArray: playerArray ,deepLinkType: BRANCH_DEEP_LINKING_END_POINT.EVENT_INVITATION.rawValue, callback: {(url, error) in
            if let wrappedURL = url,
                let eventID = self.eventInfo?.eventID where error == nil {
                _ = TRInvitePlayersRequest().invitePlayers(eventID, invitedPlayers: playerArray, invitationLink: wrappedURL, completion: { (error, responseObject) in
                    if let _ = error {
                        //                        let errorView = NSBundle.mainBundle().loadNibNamed("TRCustomError", owner: self, options: nil)[0] as! TRCustomError
                        //                        errorView.errorMessageHeader?.text = "ERROR"
                        //                        errorView.errorMessageDescription?.text = error
                        //                        errorView.frame = self.frame
                        //                        errorView.delegate = self
                        //                        errorView.actionButton.setTitle("ADD NEW ACTIVITY", forState: .Normal)
                        //
                        //                        self.addSubview(errorView)
                    } else {
                        if let networkObject = responseObject["networkObject"].dictionary {
                            let bungieUrl = networkObject["url"]!.stringValue
                            let requestBody = networkObject["body"]
                            let pendingEventInvitationId = networkObject["_id"]!.stringValue
                            
                            _ = TRInviteRequestToBungie().inviteFriendRequestToBungie(bungieUrl, requestBody: requestBody!, completion: { (responseObject, responseDict) -> () in
                                
                                if let _ = responseDict {
                                    _ = TRBungieInvitationCompletionRequest().sendInvitationCompletionRequest(responseDict!, pendingEventInvitationId: pendingEventInvitationId, completion: { (didSucceed) in
                                        if didSucceed == true {
                                            print("Request Successful")
                                        }
                                    })
                                }
                            })
                        } else {
                            print("No network object received")
                        }
                        
                        self.closeInviteView()
                    }
                })
            }
            
        })
    }


    
    @IBAction func closeInviteView () {
        
        //Remove TokenView
        self.tokenView.removeFromSuperview()
        
        let trans = POPSpringAnimation(propertyNamed: kPOPLayerTranslationXY)
        trans.fromValue = NSValue(CGPoint: CGPointMake(0, 0))
        trans.toValue = NSValue(CGPoint: CGPointMake(0, self.bounds.size.height))
        trans.springSpeed = 2
        self.layer.pop_addAnimation(trans, forKey: "Translation")
        
        let popAnimation:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        popAnimation.toValue = 0.0
        popAnimation.duration = 0.7
        self.pop_addAnimation(popAnimation, forKey: "alphasIn")
        
        trans.completionBlock = {(animation, finished) in
            self.tokenView.delegate = nil
            self.removeFromSuperview()
        }
        
        delegate?.invitationViewClosed!()
        delegate = nil
    }
    
    func tokenViewHeightUpdated(tokenFieldHeight: CGFloat) {
        self.tokenViewContainerBackground.frame = CGRectMake(0, 0, self.tokenViewContainerBackground.frame.size.width, tokenFieldHeight)
    }
    
    func tokenView(tokenView: KSTokenView, didAddToken token: KSToken) {
        
        // Check Player Required Limit
        let extraPlayersRequiredCount = ((eventInfo!.eventActivity?.activityMaxPlayers?.integerValue)! - (eventInfo!.eventPlayersArray.count))
        if tokenView.tokens()?.count < extraPlayersRequiredCount {
            self.descriptionLabel?.text = "Inviting players will send a message from\nyou to them on Bungie.net."
        } else {
            self.descriptionLabel?.text = "The maximum number of players for your Fireteam has been reached. Each invited player will have a reserved spot on your Fireteam."
        }

        delegate?.showInviteButton!()
        if self.checkIfTheUserAlreadyExists(token.title) == true || token.title == "Untitled"{
           tokenView._removeToken(token)
            return
        }
        
        if let console = TRApplicationManager.sharedInstance.currentUser?.getDefaultConsole() {
            switch console.consoleType! {
            case ConsoleTypes.XBOXONE:
                self.xBoxValidation(token)
                break
            case ConsoleTypes.PS4:
                self.playStationValidation(token)
                break
            default: break
            }
        }
    }
    
    func tokenView(tokenView: KSTokenView, didDeleteToken token: KSToken) {
        if tokenView.tokens()?.count == 0 {
            delegate?.hideInviteButton!()
        }
        
        // Check Player Required Limit
        let extraPlayersRequiredCount = ((eventInfo!.eventActivity?.activityMaxPlayers?.integerValue)! - (eventInfo!.eventPlayersArray.count))
        if tokenView.tokens()?.count <= extraPlayersRequiredCount {
            self.descriptionLabel?.text = "Inviting players will send a message from\nyou to them on Bungie.net."
        } else {
            self.descriptionLabel?.text = "The maximum number of players for your Fireteam has been reached. Each invited player will have a reserved spot on your Fireteam."
        }
    }
        
    //MARK:- GamerTag Validation
    func playStationValidation (token: KSToken) {
        if !(token.title.isPlayStationVerified == true && token.title.characters.count > 2  && token.title.characters.count < 17) {
            tokenView._removeToken(token)
            self.showInvalidGamerTag()
        }
    }
    
    func xBoxValidation (token: KSToken) {
        if !(token.title.isXboxVerified == true) {
            tokenView._removeToken(token)
            self.showInvalidGamerTag()
        }
    }
    
    func showInvalidGamerTag () {
        
        self.tokenView?.forcedResignFirstResponder()
        
        let errorView = NSBundle.mainBundle().loadNibNamed("TRCustomError", owner: self, options: nil)[0] as! TRCustomError
        errorView.errorMessageHeader?.text = "INVALID GAMERTAG"
        errorView.errorMessageDescription?.text = "Please enter a valid gamertag."
        errorView.frame = self.frame
        errorView.delegate = self
        
        self.addSubview(errorView)
    }
    
    func okButtonPressed () {
        self.tokenView?.becomeFirstResponder()
    }
    
    func customErrorActionButtonPressed () {
        self.closeInviteView()
    }
    
    func checkIfTheUserAlreadyExists (token: String) -> Bool {
        let userExists = self.tokenView.tokens()?.filter{$0.title == token}
        if userExists?.count > 1 {
            return true
        }
        
        let userExistsInEvent = self.eventInfo?.eventPlayersArray.filter{$0.playerPsnID == token}
        if userExistsInEvent?.count > 0 {
            return true
        }
        
        return false
    }
}
