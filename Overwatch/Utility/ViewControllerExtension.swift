//
//  ViewControllerExtension.swift
//  Traveler
//
//  Created by Rangarajan, Srivatsan on 2/22/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import UIKit

extension UIViewController {
    
    typealias TRActivityIndicatorCompletion = (complete: Bool?) -> ()
    typealias TRActivityIndicatorCompletionWithHandler = (action: UIAlertAction?) -> ()
    typealias TRActivityIndicatorWithButtonIndex = (complete: String?) -> ()
    
    //let alertIndex = alertView.actions.indexOf(action)
    
    func displayAlertWithActionHandler(title: String, message: String, buttonOneTitle: String?, buttonTwoTitle: String?, buttonThreeTitle: String, completionHandler: TRActivityIndicatorWithButtonIndex) {
        
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        let closure = { (index: String) in
            { (action: UIAlertAction!) -> Void in
                completionHandler(complete: index)
            }
        }
        
        if let _ = buttonOneTitle {
            alertView.addAction(UIAlertAction(title: buttonOneTitle, style: .Default, handler: closure(K.Legal.PP)))
        }
        if let _ = buttonTwoTitle {
            alertView.addAction(UIAlertAction(title: buttonTwoTitle, style: .Default, handler: closure(K.Legal.TOS)))
        }
        
        alertView.addAction(UIAlertAction(title: buttonThreeTitle, style: .Cancel, handler: closure(K.Legal.OK)))
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    func displayAlertWithTitle(title: String, complete: TRActivityIndicatorCompletion) {
        let alertView = UIAlertController(title: title, message: " ", preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            switch action.style{
            case .Default:
                complete(complete: true)
                
            case .Cancel:
                print("cancel")
                
            case .Destructive:
                print("destructive")
            }
        }))
        
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    func displayAlertWithTitleAndMessageAnOK(title: String, message: String, complete: TRActivityIndicatorCompletion) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "Ok", style: .Default, handler: { action in
            switch action.style{
            case .Default:
                complete(complete: true)
                
            case .Cancel:
                print("OK")
                
            case .Destructive:
                print("destructive")
            }
        }))
        
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    func displayAlertWithTitleAndMessage(title: String, message: String, complete: TRActivityIndicatorCompletion) {
        let alertView = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { action in
            switch action.style{
            case .Default:
                complete(complete: true)
                
            case .Cancel:
                print("cancel")
                
            case .Destructive:
                print("destructive")
            }
        }))
        
        alertView.addAction(UIAlertAction(title: "Upgrade", style: .Default, handler: { action in
            switch action.style{
            case .Default:
                complete(complete: true)
                
            case .Cancel:
                print("cancel")
                
            case .Destructive:
                print("destructive")
            }
        }))
        
        presentViewController(alertView, animated: true, completion: nil)
    }
    
    func addNavigationBarButtons (showBack: Bool, showCancel: Bool) {
        
        //Navigation Bar Title Font
        self.navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: "HelveticaNeue-Bold", size: 17)!]
        self.navigationController?.navigationBar.setTitleVerticalPositionAdjustment(2.0, forBarMetrics: .Default)

        let nav = self.navigationController?.navigationBar
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        nav?.barTintColor = UIColor(red: 28/255, green: 43/255, blue: 51/255, alpha: 1)
        
        if showBack {
            //Adding Back Button to nav Bar
            let leftButton = UIButton(frame: CGRectMake(0,0,44,44))
            leftButton.setImage(UIImage(named: "iconBackArrow"), forState: .Normal)
            leftButton.addTarget(self, action: #selector(TRCreateEventViewController.navBackButtonPressed(_:)), forControlEvents: .TouchUpInside)
            leftButton.transform = CGAffineTransformMakeTranslation(-10, 0)
            
            // Add the button to a container, otherwise the transform will be ignored
            let leftButtonContainer = UIView(frame: leftButton.frame)
            leftButtonContainer.addSubview(leftButton)
            
            let leftBarButton = UIBarButtonItem()
            leftBarButton.customView = leftButtonContainer
            
            self.navigationItem.leftBarButtonItem = leftBarButton
        }
        
        if showCancel {
            //Adding Back Button to nav Bar
            let rightButton = UIButton(frame: CGRectMake(0,0,60,17))
            rightButton.setTitle("Cancel", forState: .Normal)
            rightButton.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 17)
            rightButton.addTarget(self, action: #selector(TRCreateEventViewController.navigationButtonClosePressed(_:)), forControlEvents: .TouchUpInside)
            rightButton.transform = CGAffineTransformMakeTranslation(3, 0)
            
            // Add the button to a container, otherwise the transform will be ignored
            let rightButtonContainer = UIView(frame: rightButton.frame)
            rightButtonContainer.addSubview(rightButton)
            
            let rightBarButton = UIBarButtonItem()
            rightBarButton.customView = rightButtonContainer
            
            self.navigationItem.rightBarButtonItem = rightBarButton
        }
    }
    
    func hideNavigationBar () {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    func showNavigationbar () {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}
