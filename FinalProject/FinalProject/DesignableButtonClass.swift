//
//  DesignableButtonClass.swift
//  FinalProject
//
//  Created by Kranthi Chinnakotla on 11/17/16.
//  Copyright © 2016 edu.uncc.cs6010. All rights reserved.
//

import UIKit

class DesignableButtonClass: UIButton {

    @IBInspectable var color:UIColor = UIColor.green
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        //let path = UIBezierPath(ovalIn: rect)
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: .allCorners, cornerRadii: .init(width: 10, height: 10))
        color.setFill()
        path.fill()
        
    }
    
    
 

}
