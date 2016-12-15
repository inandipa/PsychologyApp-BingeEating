//
//  UIViewController.swift
//  FinalProject
//
//  Created by Kranthi Chinnakotla on 11/17/16.
//  Copyright © 2016 edu.uncc.cs6010. All rights reserved.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
