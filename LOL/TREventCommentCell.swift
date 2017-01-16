//
//  TREventCommentCell.swift
//  Traveler
//
//  Created by Ashutosh on 8/17/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation


class TREventCommentCell: UITableViewCell {
    @IBOutlet weak var playerIcon: UIImageView!
    @IBOutlet weak var playerUserName: UILabel!
    @IBOutlet weak var playerComment: UILabel!
    @IBOutlet weak var messageTimeLabel: UILabel!
    @IBOutlet weak var creatorDogTag: UIImageView!
    @IBOutlet weak var messageTopConst: NSLayoutConstraint!
    @IBOutlet weak var messageBottomConst: NSLayoutConstraint!
}