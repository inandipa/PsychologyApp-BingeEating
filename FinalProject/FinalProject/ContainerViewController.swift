//
//  ContainerViewController.swift
//  FinalProject
//
//  Created by Kranthi Chinnakotla on 11/8/16.
//  Copyright © 2016 edu.uncc.cs6010. All rights reserved.
//

import UIKit
import Alamofire
var token : String = String()
var globalUser = String()
var imageV : UIImageView?
class ContainerViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var menuButton: UIBarButtonItem!
   
    
   
    @IBOutlet weak var signOut: UIButton!
    
    @IBOutlet weak var userNameLabel: UILabel!
    
    @IBOutlet weak var passwordLabel: UILabel!
    
    @IBOutlet weak var userNameText: UITextField!
    
    
    @IBOutlet weak var passwordText: UITextField!
    
    
    @IBOutlet weak var signIn: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        
        scrollView.setContentOffset(CGPoint(x:0,y:250), animated: true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
//        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        scrollView.setContentOffset(CGPoint(x:0,y:0), animated: true)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuButton.target = self.revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        signOut.isHidden = true

        // Do any additional setup after loading the view.
        
        let img = UIImage(named: "images")
        let imageView = UIImageView(frame: CGRect(x: 120, y: 160, width: 100, height: 100))
        imageView.layer.cornerRadius = (imageView.frame.size.height)/2
        imageView.clipsToBounds = true
        //imageView.layer.borderColor = UIColor.purple.cgColor
        //imageView.layer.borderWidth = CGFloat(2)
        imageView.layer.masksToBounds = true
        imageView.image = img
        imageV = imageView
        
       
        if(token.characters.count > 0){
            self.signOut.isHidden = false
            self.signIn.isHidden = true
            self.passwordLabel.isHidden = true
            self.userNameLabel.isHidden = true
            self.userNameText.isHidden = true
            self.passwordText.isHidden = true
            

        }
        
       self.hideKeyboardWhenTappedAround()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func signInAction(_ sender: UIButton) {
        
        userNameText.text = "indra"
        passwordText.text = "1234"
        if let userName = userNameText.text , let pass = passwordText.text{
            
            let trimmedUserName = userName.trimmingCharacters(in: .whitespaces)
            let trimmedPass = pass.trimmingCharacters(in: .whitespaces)
            globalUser = trimmedUserName
            
            Alamofire.request("http://54.197.12.149/login?username=\(trimmedUserName)&password=\(trimmedPass)").responseJSON(completionHandler: { (response) in
                
                if let userAuthentication = response.result.value as? Dictionary<String,AnyObject>{
                    
                    if(userAuthentication["message"] as? String == " login Successful " ){
                        token = (userAuthentication["token"] as? String)!
                        DispatchQueue.main.async {
                            self.signOut.isHidden = false
                            self.signIn.isHidden = true
                            self.passwordLabel.isHidden = true
                            self.userNameLabel.isHidden = true
                            self.userNameText.isHidden = true
                            self.passwordText.isHidden = true
                            }
                    }
                    
                }
                
            })
            
        }
        
    }
    
    
    @IBAction func signOutAction(_ sender: UIButton) {
        
        token = ""
        self.signIn.isHidden = false
        self.passwordLabel.isHidden = false
        self.userNameLabel.isHidden = false
        self.userNameText.isHidden = false
        self.passwordText.isHidden = false

    }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


