//
//  DialyViewController.swift
//  FinalProject
//
//  Created by Kranthi Chinnakotla on 11/2/16.
//  Copyright © 2016 edu.uncc.cs6010. All rights reserved.
//

import UIKit
import SDCAlertView
import Alamofire
import AWSS3
import AWSCore

var questionsList = [Questions]()

class DialyViewController: UIViewController,UITextFieldDelegate{
    
    
    @IBOutlet weak var slider_outlet: UISlider!
    @IBOutlet weak var sad_label: UILabel!
    @IBOutlet weak var moderate_label: UILabel!
    @IBOutlet weak var happy_label: UILabel!
    @IBOutlet weak var button_no: UIButton!
    @IBOutlet weak var button_yes: UIButton!
    @IBOutlet weak var button_more: UIButton!
    @IBOutlet weak var button_3: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button_1: UIButton!
    
    @IBOutlet weak var imageText: UITextField!
    
    @IBOutlet weak var attach_button: UIButton!
    
    
    @IBAction func sliderAction(_ sender: UISlider) {
       
        if(sender.value > 60){
            feeling = "Sad"
        }else if(sender.value < 40){
            feeling = "Happy"
        }else if(sender.value > 40 && sender.value < 60 ){
            feeling = "Moderate"
            
        }
        
        
    }
    @IBOutlet weak var scrollV: UIScrollView!
    var questionAnswers = Dictionary<String,String>()
   // var questionsList = [Questions]()
    var imageData: Data?
    var yes_bool = false
    var no_bool = false
    var feeling: String?

    
    @IBAction func camerFromGallery(_ sender: UIButton) {
        self.pickAnImageGallery()
    }
    
    @IBOutlet weak var camerabutton_outlet: UIButton!
    @IBOutlet weak var dialyMenu: UIBarButtonItem!
    @IBOutlet weak var goBack: UIButton!
    
    @IBAction func cameraPick(_ sender: UIButton) {
        self.pickAnImage()}
    
    
    @IBAction func but_01(_ sender: UIButton) {
        
        button_1.layer.backgroundColor = UIColor.green.cgColor
        button2.layer.backgroundColor = UIColor.red.cgColor
        button_3.layer.backgroundColor = UIColor.red.cgColor
        button_more.layer.backgroundColor = UIColor.red.cgColor
        numOfVeggies = 1
        if(!responsetext.isHidden){
            responsetext.isHidden = true
            responsetext.placeholder = "Enter the response here"
        }
    }
    
    
    @IBAction func but_02(_ sender: UIButton) {
        
        button2.layer.backgroundColor = UIColor.green.cgColor
        button_1.layer.backgroundColor = UIColor.red.cgColor
        button_3.layer.backgroundColor = UIColor.red.cgColor
        button_more.layer.backgroundColor = UIColor.red.cgColor
        numOfVeggies = 2
        if(!responsetext.isHidden){
            responsetext.isHidden = true
            responsetext.placeholder = "Enter the response here"
        }
    }
    
    
    @IBAction func but_03(_ sender: UIButton) {
        
        button2.layer.backgroundColor = UIColor.red.cgColor
        button_1.layer.backgroundColor = UIColor.red.cgColor
        button_3.layer.backgroundColor = UIColor.green.cgColor
        button_more.layer.backgroundColor = UIColor.red.cgColor
        numOfVeggies = 3
        if(!responsetext.isHidden){
            responsetext.isHidden = true
            responsetext.placeholder = "Enter the response here"
        }
        
    }
    
    @IBAction func but_more(_ sender: UIButton) {
        
        button2.layer.backgroundColor = UIColor.red.cgColor
        button_1.layer.backgroundColor = UIColor.red.cgColor
        button_3.layer.backgroundColor = UIColor.red.cgColor
        button_more.layer.backgroundColor = UIColor.green.cgColor
        numOfVeggies = 5
        responsetext.isHidden = false
        responsetext.placeholder = "enter only numbers"
        responsetext.delegate = self
        responsetext.keyboardType = .numberPad
    }
    
    
    var numOfVeggies: Int?
    
    
    
    @IBAction func button_yesAction(_ sender: UIButton) {
        
        if(questionsList[count].question == "Is it Binge?" ){
            yes_bool = true
            no_bool = false
            button_yes.layer.backgroundColor = UIColor.green.cgColor
            button_no.layer.backgroundColor = UIColor.red.cgColor
        }else if(questionsList[count].question == "Any Vomiting or Laxative Use, etc.?"){
            yes_bool = true
            no_bool = false
            button_no.layer.backgroundColor = UIColor.red.cgColor
            button_yes.layer.backgroundColor = UIColor.green.cgColor
        
        }
        
    }
    
    @IBAction func button_noAction(_ sender: UIButton) {
        
        if(questionsList[count].question == "Is it Binge?" ){
        
            no_bool = true
            yes_bool = false
            
            button_yes.layer.backgroundColor = UIColor.red.cgColor
            button_no.layer.backgroundColor = UIColor.green.cgColor
        }else if(questionsList[count].question == "Any Vomiting or Laxative Use, etc.?"){
            
            no_bool = true
            yes_bool = false
            button_yes.layer.backgroundColor = UIColor.red.cgColor
            button_no.layer.backgroundColor = UIColor.green.cgColor
        
        }
        
        
    }
    
    
    
    func uploadintoAwsS3(question: Questions){
        
        if(imageData != nil){
            let bucket = "finalproject6160"
            let imageName = NSUUID().uuidString
            let fileUrl = NSURL(fileURLWithPath: NSTemporaryDirectory().appending(imageName))
            try! imageData?.write(to: fileUrl as URL)
            let uploadRequest = AWSS3TransferManagerUploadRequest()
            uploadRequest?.body = fileUrl as URL
            uploadRequest?.key = imageName
            uploadRequest?.bucket = bucket
            uploadRequest?.contentType = "image/png"
            let s3Url = NSURL(string: "https://s3.amazonaws.com/\(bucket)/\(imageName)")
            
            question.imageUrl = s3Url!
            
            let transferManager = AWSS3TransferManager.default()
            
            transferManager?.upload(uploadRequest).continue({ (task) -> Any? in
                
                if let error = task.error{
                    print("Upload Failed:"+error.localizedDescription)
                }
                
                if(task.result != nil){
                    
                    print("Uploaded to:\n\(s3Url)")
                    
                }
                
                return nil
            })
            
            
        }

    }
    
    
    var count = 0
    @IBOutlet weak var imageFromCamera: UIImageView!

   
    @IBOutlet weak var questionText: UITextView!
    
   // @IBOutlet weak var questionText: UITextField!
    @IBOutlet weak var timeText: UILabel!
   // @IBOutlet weak var informationLabel: UILabel!
    @IBOutlet weak var responsetext: UITextField!
    
    @IBOutlet weak var prevButton: UIButton!
    @IBOutlet weak var contButLabel: UIButton!
    @IBAction func continueButton(_ sender: UIButton) {
        
        button_yes.layer.backgroundColor = UIColor.red.cgColor
        button_no.layer.backgroundColor = UIColor.red.cgColor
            if (count < questionsList.count - 1){
                
                if(responsetext.keyboardType == .numberPad){
                    responsetext.keyboardType = .alphabet
                    responsetext.placeholder = "Enter the response here"
                }
                
                switch count {
                case 0:
                    questionsList[count].answer = imageText.text!
                    break
                case 1:
                    if numOfVeggies != nil  {
                        if(numOfVeggies! > 3){
                            questionsList[count].answer = responsetext.text!
                        }else if(numOfVeggies! <= 3){
                            questionsList[count].answer = String(numOfVeggies!)
                        }

                    }
                    
                    break
                    
                case 2:
                    if(yes_bool){
                        
                        questionsList[count].answer = "yes"
                        
                    }else if(no_bool){
                        
                        questionsList[count].answer = "no"
                        
                    }
                    
                    
                    break
                    
                case 3:
                    
                    if(yes_bool){
                        
                        questionsList[count].answer = "yes"
                        
                    }else if(no_bool){
                        
                        questionsList[count].answer = "no"
                        
                    }
                    break
                    
                case 4:
                    if(feeling != nil){
                    
                        questionsList[count].answer = feeling!
                    }
                    
                    break
                    
                case 5:
                    questionsList[count].answer = responsetext.text!
                    break
                    
                case 6:
                    questionsList[count].answer = responsetext.text!
                    break
                case 7:
                    questionsList[count].answer = responsetext.text!
                    break
                default:
                    break
                }
                

                
                
                uploadintoAwsS3(question: questionsList[count])
                count += 1
                
                showQuestion(cnt: count)
                
            }else{
                let date = NSDate()
                let calendar = NSCalendar.current
                let year = calendar.component(.year, from: date as Date)
                let month = calendar.component(.month, from: date as Date)
                let day = calendar.component(.day, from: date as Date)
                let hour = calendar.component(.hour, from: date as Date)
                let minutes = calendar.component(.minute, from: date as Date)
                let seconds = calendar.component(.second, from: date as Date)
                
                
                questionAnswers = ["FoodAndDrinksConsumed": questionsList[0].answer,"NumberOfServingsOfVegetables":questionsList[1].answer,"Binge(YesOrNo)":questionsList[2].answer,"AnyVomitingOrLaxativeUse":questionsList[3].answer,"Context/Setting":questionsList[4].answer,"Feelings":questionsList[5].answer,"Time":"\(year)-\(month)-\(day) \(hour):\(minutes):\(seconds)","ImageUrl":String(describing: questionsList[0].imageUrl)]
                
                
                let url = URL(string:"http://54.197.12.149/user/DailyLog")
                var urlRequest = URLRequest(url: url!)
                urlRequest.httpMethod = "POST"
                do {
                    urlRequest.httpBody = try JSONSerialization.data(withJSONObject: questionAnswers, options: [])
                } catch {
                    print("Error while posting")
                }
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.setValue(token, forHTTPHeaderField: "token")
                
                Alamofire.request(urlRequest).responseJSON { (response) in
                    
                    print(response.result.value as? Dictionary<String,AnyObject>)
                    
                }
                
                
                
                let alert = AlertController(title: "This is the last question", message: "click OK ", preferredStyle: .actionSheet)
                
                alert.add(AlertAction(title: "OK", style: .normal, handler: { (action) in
                   let secAlert = AlertController(title: "Saving your log", message:"Click Save" ,
                                                  preferredStyle: .alert)
                    secAlert.add(AlertAction(title:"Save", style: AlertActionStyle.normal,handler: {(action) in
                       self.performSegue(withIdentifier: "table_log", sender: self)
                    }))
                    secAlert.present()
                }))
                alert.present()
            }

        
        
        
    }
    
    
    @IBAction func previousQuestion(_ sender: UIButton) {
        
            if (count > 0){
                if(responsetext.keyboardType == .numberPad){
                    responsetext.keyboardType = .alphabet
                    responsetext.placeholder = "Enter the response here"
                }
                count -= 1
                if(count == 0){
                    questionsList[count].answer = responsetext.text!
                }
                showQuestion(cnt: count)
            
            }else{
                let alert = AlertController(title: "You are at first Question", message: "click OK ", preferredStyle: .actionSheet)
                alert.add(AlertAction(title: "OK", style: .preferred))
                alert.present()
        }

        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollV.setContentOffset(CGPoint(x:0,y:250), animated: true)
        

    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollV.setContentOffset(CGPoint(x:0, y:0), animated: true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
   
    func showQuestion(cnt: Int){
        questionText.text = questionsList[cnt].question
        hideshow(status: cnt)
        responsetext.text = ""
        imageFromCamera.image = nil
        
        
        
    }
    
    func hideshow(status: Int){

        
        switch status {
        case 0:
            hideAll()
            imageFromCamera.isHidden = false
            camerabutton_outlet.isHidden = false
            imageText.isHidden = false
            attach_button.isHidden = false
            break
        case 1:
            hideAll()
            button_1.isHidden = false
            button2.isHidden = false
            button_3.isHidden = false
            button_more.isHidden = false
            break
        case 2:
            hideAll()
            button_yes.isHidden = false
            button_no.isHidden = false
            break
        case 3:
            hideAll()
            button_yes.isHidden = false
            button_no.isHidden = false
            break
            
        case 4:
            hideAll()
            happy_label.isHidden = false
            moderate_label.isHidden = false
            sad_label.isHidden = false
            slider_outlet.isHidden = false
            break
            
        case 5:
            hideAll()
            responsetext.isHidden = false
            break
        case 6:
            hideAll()
            responsetext.isHidden = false
            break
        case 7:
            hideAll()
            responsetext.isHidden = false
        default:
            break
        }
    }
    
    func hideAll(){
        responsetext.isHidden = true
        button_1.isHidden = true
        button2.isHidden = true
        button_3.isHidden = true
        button_no.isHidden = true
        button_yes.isHidden = true
        button_more.isHidden = true
        happy_label.isHidden = true
        moderate_label.isHidden = true
        sad_label.isHidden = true
        slider_outlet.isHidden = true
        imageFromCamera.isHidden = true
        camerabutton_outlet.isHidden = true
        attach_button.isHidden = true
        imageText.isHidden = true
        
    
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideAll()
        //hideshow(status: true)
        showQuestion(cnt: count)
//        if (questionText.text != ""){
//            hideshow(status: false)
//        }
        
        let date = NSDate()
        let calendar = NSCalendar.current
        let year = calendar.component(.year, from: date as Date)
        let month = calendar.component(.month, from: date as Date)
        let day = calendar.component(.day, from: date as Date)
        let hour = calendar.component(.hour, from: date as Date)
        let minutes = calendar.component(.minute, from: date as Date)
        
        timeText.text = "Date:\(month)/\(day)/\(year) Time:\(hour):\(minutes)"
        
        self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        dialyMenu.target = revealViewController()
        dialyMenu.action = #selector(SWRevealViewController.revealToggle(animated:))
        //timeText.layer.backgroundColor = UIColor.cyan.cgColor
        
        timeText.layer.cornerRadius = 10
        //timeText.layer.borderWidth = CGFloat(2)
        //timeText.layer.borderColor = UIColor.black.cgColor
        responsetext.layer.cornerRadius = 10
        //responsetext.layer.borderWidth = CGFloat(2)
        //responsetext.layer.borderColor = UIColor.black.cgColor
        questionText.layer.cornerRadius = 10
        //questionText.layer.borderWidth = CGFloat(2)
        //questionText.layer.borderColor = UIColor.black.cgColor
        imageFromCamera.layer.cornerRadius = 10
        imageFromCamera.layer.borderWidth = CGFloat(2)
        imageFromCamera.layer.borderColor = UIColor.black.cgColor
        
        
       // goBack.isHidden = true
       // Do any additional setup after loading the view.
        
        
        
        
        let coach = AlertController(title: "Hi there!", message: "Before you start the dialy questions, please ensure the weight is logged in the weekly section", preferredStyle: .alert)
        //coach.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        coach.add(AlertAction(title: "OK", style: .normal))
        coach.view.addSubview(imageV!)
        self.present(coach, animated: true, completion: nil)
        
        

        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.usEast1,
                                                                identityPoolId:"us-east-1:e7e1980f-4472-4ad8-90b4-36a1e8ab2733")
        
        let configuration = AWSServiceConfiguration(region:.usEast1, credentialsProvider:credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration


        responsetext.delegate = self
        button_1.layer.cornerRadius = 5
        button2.layer.cornerRadius = 5
        button_3.layer.cornerRadius = 5
        button_more.layer.cornerRadius = 5
        button_yes.layer.cornerRadius = 5
        button_no.layer.cornerRadius = 5
        
        self.hideKeyboardWhenTappedAround()
        slider_outlet.maximumValue = 100
        slider_outlet.minimumValue = 0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
