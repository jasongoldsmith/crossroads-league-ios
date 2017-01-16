//
//  TRErrorView.swift
//  Traveler
//
//  Created by Ashutosh on 7/29/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit

@objc protocol ErrorViewProtocol {
    optional func addActivity (eventInfo: TREventInfo?)
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
            self.delegate?.addActivity!(self.eventInfo)
            break
        case .MAXIMUM_PLAYERS_REACHED:
            self.delegate?.addActivity!(self.eventInfo)
            break
        case .NEEDS_CONSOLE:
            self.delegate?.addConsole!()
            break
        case .JOIN_BUNGIE_GROUP:
            self.delegate?.goToBungie!(self.eventInfo?.eventClanID)
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
            self.buttonOneYes.setTitle("ADD THIS ACTIVITY", forState: .Normal)
            self.errorDescription.text = "Sorry, that \(eventName) is no longer available. Would you like to add one of your own?"
            break
        case .MAXIMUM_PLAYERS_REACHED:
            self.buttonOneYes.setTitle("YES", forState: .Normal)
            self.errorDescription.text = "The maximum amount of players has been reached for this activity. Would you like to add one of your own?"
            break
        case .NEEDS_CONSOLE:
            if let consoleType = self.eventInfo?.eventConsoleType {
                let console  =  self.getConsoleTypeFromString(consoleType)
                self.buttonOneYes.setTitle("OK", forState: .Normal)
                self.errorDescription.text = "You'll need a \(console) linked to your Bungie account to join that activity from \(eventGroup)."
                self.buttonTwoCancel.hidden = true
            }
            break
        case .JOIN_BUNGIE_GROUP:
            self.buttonOneYes.setTitle("VIEW GROUP ON BUNGIE.NET", forState: .Normal)
            self.errorDescription.text = "You’ll need to be in the \(eventGroup) group to join that \(eventName). Request to join?"
            break
        }
    }
    
    func getConsoleTypeFromString (consoleName: String) -> String {
        
        var consoleType = ""
        switch consoleName {
        case "PS4":
            consoleType = "PS4"
            break
        case "PS3":
            consoleType = "PS3"
            break
        case "XBOX360":
            consoleType = "360"
            break
        default:
            consoleType = "XB1"
            break
        }
        
        return consoleType
    }
    
    /*
     // Only override drawRect: if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func drawRect(rect: CGRect) {
     // Drawing code
     }
     */
}
