//
//  MoreCell.swift
//  1542257-1542258
//
//  Created by Phu on 6/2/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit

class MoreCell: UITableViewCell {
    
    // MARK: *** UI Element
    @IBOutlet weak var imageViewImage: UIImageView!
    @IBOutlet weak var labelTitle: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
