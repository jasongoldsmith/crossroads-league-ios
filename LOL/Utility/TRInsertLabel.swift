//
//  TRInsertLabel.swift
//  Traveler
//
//  Created by Ashutosh on 8/14/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation


class TRInsertLabel: UILabel {
    
    var topInset = CGFloat(5.0), bottomInset = CGFloat(5.0), leftInset = CGFloat(5.0), rightInset = CGFloat(5.0)
    
    
    override func drawTextInRect(rect: CGRect) {
        
        let insets: UIEdgeInsets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawTextInRect(UIEdgeInsetsInsetRect(rect, insets))
    }
    
    
    override func intrinsicContentSize() -> CGSize {
        var intrinsicSuperViewContentSize = super.intrinsicContentSize()
        intrinsicSuperViewContentSize.height += topInset + bottomInset
        intrinsicSuperViewContentSize.width += leftInset + rightInset
        return intrinsicSuperViewContentSize
    }
}