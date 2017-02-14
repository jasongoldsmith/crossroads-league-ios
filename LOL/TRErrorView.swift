//
//  TRErrorView.swift
//  Traveler
//
//  Created by Ashutosh on 7/29/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit

@objc protocol ErrorViewProtocol {
    optional func addActivity (eventInfo: String?)
    optional func addConsole ()
    optional func goToBungie (eventID: String?)
}

class TRErrorView: UIView {
    
    var errorType: Branch_Error?
    var delegate: ErrorViewProtocol?
    var eventInfo: TREventInfo?
    var activityName: String?
    
    @IBOutlet weak var buttonOneYes: UIButton!
    @IBOutlet weak var buttonTwoCancel: UIButton!
    @IBOutlet weak var errorDescription: UILabel!
    
    @IBAction func closeErrorView () {
        self.delegate = nil
        self.removeFromSuperview()
    }
    
    @IBAction func buttonOneYesPressed (sender: UIButton) {
        switch self.errorType! {
        case .ACTIVITY_NOT_AVAILABLE:
            self.delegate?.addActivity!(self.activityName)
            break
        case .MAXIMUM_PLAYERS_REACHED:
            self.delegate?.addActivity!(self.activityName)
            break
        case .NEEDS_CONSOLE:
            self.delegate?.addConsole!()
            break
        case .JOIN_BUNGIE_GROUP:
            break
        }
        
        self.delegate = nil
        self.removeFromSuperview()
    }
    
    @IBAction func buttonTwoCancelPressed (sender: UIButton) {
        self.closeErrorView()
    }

    override func layoutSubviews() {
        
        //Button radius
        self.buttonOneYes.layer.cornerRadius = 2.0
        self.buttonTwoCancel.hidden = false
        
        var eventName = ""
        var eventGroup = ""
        
        if let groupName = self.eventInfo?.clanName {
            eventGroup = groupName
        }
        if let _ = self.activityName {
            eventName = self.activityName!
        }
        
        switch self.errorType! {
        case .ACTIVITY_NOT_AVAILABLE:
            self.buttonOneYes.setTitle("YES", forState: .Normal)
            self.errorDescription.text = "That \(eventName) team is no longer available. Look for a new one?"
            break
        case .MAXIMUM_PLAYERS_REACHED:
            self.buttonOneYes.setTitle("YES", forState: .Normal)
            self.errorDescription.text = "The maximum amount of players has been reached for this team. Find a new one?"
            break
        case .JOIN_BUNGIE_GROUP:
            self.buttonOneYes.setTitle("OK", forState: .Normal)
            self.errorDescription.text = "You'll need an account in \(eventGroup) to join that team."
            break
        default:
            break
        }
    }
}
