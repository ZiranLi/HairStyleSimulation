//
//  TableViewCell.swift
//  GrabCutIOS
//
//  Created by Xiang Zheng on 12/5/17.
//  Copyright © 2017 EunchulJeon. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

  
    @IBOutlet weak var Hair: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
