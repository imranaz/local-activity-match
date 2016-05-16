//
//  UserProfilePhotoCell.swift
//  Play Squash
//
//  Created by Imran Aziz on 5/10/16.
//  Copyright © 2016 Maikya. All rights reserved.
//

import UIKit

class UserProfilePhotoCell: UITableViewCell {
 
    // Outlets to connect to the UI
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var firstnameField: UITextField!
    @IBOutlet weak var lastnameField: UITextField!
    @IBOutlet weak var nicknameField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
