//
//  TRActivitySelectionCell.swift
//  Traveler
//
//  Created by Ashutosh on 3/9/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation
import UIKit

private let CORNER_RADIUS: CGFloat = 2

class TRActivitySelectionCell: UITableViewCell {
 
    
    @IBOutlet weak var activityIconImage: UIImageView!
    @IBOutlet weak var activityInfoLabel: UILabel!
    
    
    func updateCell (activity: TRActivityInfo) {
        
        var labelSting = activity.activitySubType!
        if let hasDifficulty = activity.activityDificulty {
            if hasDifficulty != "" {
                labelSting = labelSting + " - " + hasDifficulty
            }
        }
        
        self.activityInfoLabel.text = labelSting

        self.layer.cornerRadius = 3
        self.layer.masksToBounds = true
        
        // Cell Shadow
        self.layer.shadowOffset = CGSizeMake(0, 1)
        self.layer.shadowColor = UIColor.blackColor().CGColor
        self.layer.shadowRadius = 3.0
        self.layer.shadowOpacity = 0.8
        self.clipsToBounds = false
        let shadowFrame: CGRect = (self.bounds)
        let shadowPath: CGPathRef = UIBezierPath(rect: shadowFrame).CGPath
        self.layer.shadowPath = shadowPath
        
        //Selection Color
        let myCustomSelectionColorView = UIView()
        myCustomSelectionColorView.backgroundColor = UIColor(red: 96/255, green: 184/255, blue: 0/255, alpha: 1)
        myCustomSelectionColorView.layer.cornerRadius = 3.0
        myCustomSelectionColorView.clipsToBounds = true
        self.selectedBackgroundView = myCustomSelectionColorView
    }
}

