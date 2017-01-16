//
//  TRBaseNavigationController.swift
//  Traveler
//
//  Created by Ashutosh on 4/19/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit

class TRBaseNavigationController: UINavigationController {
    
    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.barStyle = .Black
        
        let nav = self.navigationBar
        nav.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        nav.barTintColor = UIColor(red: 10/255, green: 31/255, blue: 39/255, alpha: 1)
        
        //Add Bar Button
        self.addNavigationBarButtons()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidLoad()
    }
    
    
    override func presentViewController(viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        
    }
    
    func addNavigationBarButtons () {
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
        
        // Avator Image View
        if let imageString = TRUserInfo.getUserImageString() {
            let imageUrl = NSURL(string: imageString)
            let avatorImageView = UIImageView()
            avatorImageView.sd_setImageWithURL(imageUrl)
            let avatorImageFrame = CGRectMake((self.navigationBar.frame.width) - avatorImageView.frame.size.width - 50, (self.navigationBar.frame.height) - avatorImageView.frame.size.height - 40, 30, 30)
            avatorImageView.frame = avatorImageFrame
            avatorImageView.roundRectView()
            
            self.navigationBar.addSubview(avatorImageView)
        }
    }
    
    func tr_topViewController () -> UIViewController? {
        return self.topViewController
    }
    
        
    func navBackButtonPressed (sender: UIBarButtonItem) {
        self.popViewControllerAnimated(true)
    }

    
    deinit {
        TRApplicationManager.sharedInstance.log.debug("deinit")
    }
}