//
//  UserProfileTableViewCell.swift
//  Play Squash
//
//  Created by Imran Aziz on 5/10/16.
//  Copyright © 2016 Maikya. All rights reserved.
//

import UIKit

class UserProfileTableViewCell: UITableViewCell {

    // Custom cell properties
    
    @IBOutlet weak var propertyLabel: UILabel!
    @IBOutlet weak var propertyField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        propertyField.borderStyle = UITextBorderStyle.None
        
        let verticalLine = CGRect(x: (self.contentView.bounds.size.width/2.5), y: 5, width: 2, height: self.contentView.bounds.size.height - 10)
        let lineSeperator = UIView(frame: verticalLine)
        lineSeperator.backgroundColor = UIColor.lightGrayColor()
        lineSeperator.autoresizingMask = UIViewAutoresizing(rawValue: 0x3f)
        
        self.addSubview(lineSeperator)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
