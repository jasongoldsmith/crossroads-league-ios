//
//  TREventDescriptionCell.swift
//  Traveler
//
//  Created by Ashutosh on 8/16/16.
//  Copyright © 2016 Forcecatalyst. All rights reserved.
//

import Foundation

class TREventDescriptionCell: UITableViewCell {
 
    override func prepareForReuse() {
        super.prepareForReuse()
        self.blueBarView.hidden = true
    }
    
    @IBOutlet weak var playerIcon: UIImageView!
    @IBOutlet weak var playerUserName: UILabel!
    @IBOutlet weak var playerInviteButton: UIButton!
    @IBOutlet weak var creatorDogTag: UIImageView!
    @IBOutlet weak var invitationButton: EventButton!
    @IBOutlet weak var blueBarView: UIView!
}