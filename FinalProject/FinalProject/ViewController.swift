//
//  ViewController.swift
//  FinalProject
//
//  Created by Kranthi Chinnakotla on 11/1/16.
//  Copyright © 2016 edu.uncc.cs6010. All rights reserved.
//

import UIKit
import Then
import SDCAlertView
import Alamofire


class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var dialyLogLabel: UILabel!
    
    
    
    var button = UIButton()
    
    @IBOutlet weak var profileButton: UIBarButtonItem!
    
    
    @IBAction func backHere(segue: UIStoryboardSegue){
        
        
        
    }
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var listOfQuestions = [Questions]()
    
    func loadQuestions(){
        
        Alamofire.request("http:54.197.12.149/user/DailyQuestions?token=\(token)").responseJSON { (response) in
            let a = response.result.value as? Dictionary<String,AnyObject>
            let qustns = a?["data"] as? NSArray
            self.listOfQuestions.removeAll()
            if(qustns != nil){
                for q in qustns!{
                    let question = Questions()
                    let adata = q as? Dictionary<String,AnyObject>
                    // question.step = adata?["Step"] as! Int
                    question.question = adata?["Question"] as! String
                    self.listOfQuestions.append(question)
                }

            }else if(qustns == nil){
                let alertController = UIAlertController(title: "Connection Issue", message: "Check the connection with server", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Connection Issue", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
//            for q in qustns!{
//                let question = Questions()
//                let adata = q as? Dictionary<String,AnyObject>
//               // question.step = adata?["Step"] as! Int
//                question.question = adata?["Question"] as! String
//                self.listOfQuestions.append(question)
//                }
            
            DispatchQueue.main.async {
                
                print(self.listOfQuestions.count)
            }
            
        }
    }
    
    func buttonClicked(sender: UIButton){
        
        if(sender.tag == 9){
           self.performSegue(withIdentifier: "profilesegue", sender: self)
        }
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        button = UIButton(type: UIButtonType.custom)
        button.layer.cornerRadius = 10
        
        if(databaseImage == nil){
        
            button.setImage(UIImage(named: "user-icon"), for: UIControlState.normal)
        }else if(databaseImage != nil){
            button.setImage(UIImage(data: databaseImage!), for: UIControlState.normal)
        }
        
        //add function for button
        button.tag = 9
        button.addTarget(self, action: #selector(buttonClicked), for: UIControlEvents.touchUpInside)
        //set frame
       button.frame = CGRect(x: 0, y: 0, width: 51, height: 41)
        
        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.leftBarButtonItem = barButton
        
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "background")!)
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        getTheImage()
        
        if(databaseImage != nil){
            button.setImage(UIImage(data: databaseImage!), for: UIControlState.normal)
        }
        if(token.characters.count>0 ){
            //listOfQuestions.removeAll()
            loadQuestions()
            print(token)
        }else{
            
            let alertController = UIAlertController(title: "Enter Credentials", message: "Enter valid UserName and Password", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (alrt) in
                self.performSegue(withIdentifier: "home", sender: self)
            }))
            self.present(alertController, animated: true, completion: nil)
        }

        
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showdialy"){
            let nc = segue.destination as? UINavigationController
            _ = nc?.topViewController as? DialyViewController
            questionsList = listOfQuestions
        }
    }
}

