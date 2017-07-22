//
//  TodayCell.swift
//  1542257-1542258
//
//  Created by Phu on 5/18/17.
//  Copyright © 2017 Phu. All rights reserved.
//

import UIKit

class TodayCell: UITableViewCell {
    
    // MARK: *** UI Element
    @IBOutlet weak var labelEnglish: UILabel!
    @IBOutlet weak var labelVietnamese: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
