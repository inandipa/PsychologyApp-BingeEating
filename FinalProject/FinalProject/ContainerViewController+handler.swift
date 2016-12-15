//
//  ContainerViewController+handler.swift
//  FinalProject
//
//  Created by Kranthi Chinnakotla on 11/11/16.
//  Copyright © 2016 edu.uncc.cs6010. All rights reserved.
//

import UIKit

extension ContainerViewController{
    
    func keyBoardWillShow(notification: NSNotification){
        if let keyBoardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue{
            if self.view.frame.origin.y == 0{
                self.view.frame.origin.y -= keyBoardSize.height
            }
        }
        
        
    }
    
    func keyBoardWillHide(notificaiton: NSNotification){
        if let keyboardSize = (notificaiton.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y != 0{
                self.view.frame.origin.y += keyboardSize.height
            }
        }
      }
    }
    
    

