//
//  StepsQuestions.swift
//  FinalProject
//
//  Created by Araballi, Pawan on 12/13/16.
//  Copyright © 2016 edu.uncc.cs6010. All rights reserved.
//

import Foundation
public class StepsQuestions{
    var step = String()
    var question = String()
    var answer = String()
    
    init(step:String, question:String, answer:String) {
        self.question = question
        self.step = step
        self.answer = answer
    }
}
