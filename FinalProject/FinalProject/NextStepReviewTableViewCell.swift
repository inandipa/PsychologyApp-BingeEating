//
//  NextStepReviewTableViewCell.swift
//  FinalProject
//
//  Created by Araballi, Pawan on 12/14/16.
//  Copyright © 2016 edu.uncc.cs6010. All rights reserved.
//

import UIKit

class NextStepReviewTableViewCell: UITableViewCell {
    @IBAction func nextStep(_ sender: DesignableButtonClass) {
        currentstep += 1
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
