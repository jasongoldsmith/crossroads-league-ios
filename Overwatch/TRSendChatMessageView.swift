//
//  TRSendChatMessageView.swift
//  Traveler
//
//  Created by Manjunatha, Roopesh on 3/30/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit
import pop

class TRSendChatMessageView: UIView, UITextViewDelegate {
    
    private let MAX_MESSAGE_CHARACTER_COUNT = 80
    
    @IBOutlet weak var sendToLabel: UILabel!
    @IBOutlet weak var chatBubbleTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var backGroundImageView: UIImageView!
    @IBOutlet weak var characterCount: UILabel!
    @IBOutlet weak var textViewBackgroundImage: UIImageView!
    @IBOutlet weak var textViewHeightConstraint: NSLayoutConstraint!
    
    var userId:String!
    var eventId:String!
    var sendToAll: Bool?
    
    override func layoutSubviews() {
        super.layoutSubviews()

        self.chatBubbleTextView.delegate = self
        self.chatBubbleTextView.layer.cornerRadius = 15
        self.sendButton?.addTarget(self, action: #selector(TRSendChatMessageView.sendChatMessage(_:)), forControlEvents: .TouchUpInside)
        self.chatBubbleTextView.becomeFirstResponder()
        self.characterCount.text = MAX_MESSAGE_CHARACTER_COUNT.description
        
        // Close View on Clicking BackGround Image View
        self.addCloseToBackGroundImageView()
    }
    
    func addCloseToBackGroundImageView () {
        let closeViewGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(TRSendChatMessageView.closeView))
        self.backGroundImageView?.userInteractionEnabled = true
        self.backGroundImageView?.addGestureRecognizer(closeViewGestureRecognizer)
    }
    
    
    func closeView()  {

        if self.chatBubbleTextView.isFirstResponder() {
            self.chatBubbleTextView.resignFirstResponder()
        }

        let popAnimation:POPBasicAnimation = POPBasicAnimation(propertyNamed: kPOPViewAlpha)
        popAnimation.toValue = 0.0
        popAnimation.duration = 0.2
        popAnimation.completionBlock = {(animation, finished) in
            self.removeFromSuperview()
        }
        
        self.pop_addAnimation(popAnimation, forKey: "alphasIn")
    }
    
// Mark: UITextFieldDelegate methods
    func textViewDidChange(textView: UITextView) {
       
        let newLength = MAX_MESSAGE_CHARACTER_COUNT - (textView.text?.characters.count)!
        self.characterCount.text = "\(newLength)"
        
        if (newLength <= 0) {
            TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("Message limit reached.")
        }
        
        let contentSizeHeight = textView.contentSize.height
        self.textViewHeightConstraint.constant = contentSizeHeight
        self.updateConstraints()
    }
   
   
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        let newLength = MAX_MESSAGE_CHARACTER_COUNT - (textView.text?.characters.count)!
        if text == "" {
            return true
        }

        if (newLength <= 0) {
            TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("Message limit reached.")
            return false
        }
        
        return true
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        return true
    }

    func textViewDidBeginEditing(textField: UITextView) {
        self.chatBubbleTextView.becomeFirstResponder()
    }
    
    func sendChatMessage(sender: EventButton) {
        
        /*
        let message: String = (self.chatBubbleTextView?.text)!
        if (message.characters.count == 0) {
            TRApplicationManager.sharedInstance.addErrorSubViewWithMessage("Please enter a message.")
            return
        }
        
        if let sendAll = sendToAll {
            if sendAll {
                _ = TRSendPushMessage().sendPushMessageToAll(self.eventId, messageString: message, completion: { (didSucceed) in
                    if (didSucceed != nil)  {
                        self.chatBubbleTextView.resignFirstResponder()
                        self.chatBubbleTextView.text = nil
                        self.removeFromSuperview()
                    } else {
                        self.chatBubbleTextView.becomeFirstResponder()
                    }
                })
            } else {
                _ = TRSendPushMessage().sendPushMessageTo(self.userId, eventId: self.eventId, messageString: message, completion: { (didSucceed) in
                    if (didSucceed != nil)  {
                        self.chatBubbleTextView.resignFirstResponder()
                        self.chatBubbleTextView.text = nil
                        self.removeFromSuperview()
                    } else {
                        self.chatBubbleTextView.becomeFirstResponder()
                    }
                })
            }
        }
         */
    }
}

