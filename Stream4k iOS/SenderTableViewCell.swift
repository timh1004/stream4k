//
//  SenderTableViewCell.swift
//  Stream4k
//
//  Created by timh1004 on 19.01.16.
//  Copyright © 2016 timh1004. All rights reserved.
//

import UIKit

class SenderTableViewCell: UITableViewCell {



    @IBOutlet var senderImage: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
