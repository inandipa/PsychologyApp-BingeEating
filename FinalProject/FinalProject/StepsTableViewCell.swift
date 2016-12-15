//
//  StepsTableViewCell.swift
//  FinalProject
//
//  Created by Araballi, Pawan on 12/14/16.
//  Copyright © 2016 edu.uncc.cs6010. All rights reserved.
//

import UIKit

class StepsTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBOutlet weak var question: UITextView!
    @IBOutlet weak var `switch`: UISwitch!

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
