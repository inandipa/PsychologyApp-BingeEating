//
//  WeeklyReportViewController.swift
//  FinalProject
//
//  Created by Kranthi Chinnakotla on 11/3/16.
//  Copyright © 2016 edu.uncc.cs6010. All rights reserved.
//

import UIKit
import SDCAlertView
import Alamofire
import CoreData

var weightTextField: UITextField?
var currentWeight: String?
var weeklyQuestions = [WeeklyQuestions]()

class WeeklyReportViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {

    @IBOutlet weak var weeklyScrollView: UIScrollView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var weightUpdates: UITextField!
    @IBAction func actionBarButton(_ sender: UIBarButtonItem) {

        
        
        
        }
   

    @IBOutlet weak var saveWeekly: UIButton!
    
    @IBAction func previousReprots(_ sender: UIButton) {
        
    }
    
    @IBAction func saveWeeklyAction(_ sender: UIButton) {
        
        
            self.tableView.reloadData()
        
            
        
        let saveAlert = AlertController(title: "Save Responses", message: "All your responses would be saved", preferredStyle: .actionSheet)
        saveAlert.add(AlertAction(title: "Save", style: .preferred, handler: { (action) in
            self.performSegue(withIdentifier: "saveweekly", sender: self)
        }))
        saveAlert.add(AlertAction(title: "Cancel", style: .preferred))
        self.present(saveAlert, animated: true, completion: nil)
        
    }
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    
    @IBAction func addWeight(_ sender: UIBarButtonItem) {
        
        let weightCotroller = AlertController(title: "Update Weight", message: "Edit or Enter your weight", preferredStyle: .alert)
        weightCotroller.addTextField { (textField) in
            
            weightTextField = textField
            
            
        }
        weightCotroller.add(AlertAction(title: "OK", style: .preferred,handler: {(action) in
        
             self.weightUpdates.text = weightTextField?.text!
             //self.insertWeight()
            
            let context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Weights", in: context)
            let transaction = NSManagedObject(entity: entity!, insertInto: context)
            let fetchRequest: NSFetchRequest<ProfileImage> = ProfileImage.fetchRequest()
            do{
                
                let results = try context.fetch(fetchRequest)
                if(results.count > 1){
                    context.delete(results[0] as NSManagedObject)
                    try! context.save()
                }
                
                
                transaction.setValue(weightTextField?.text!, forKey: "weights")
                
                
                
                
            }catch{
                print("RetrieveDataError:"+error.localizedDescription)
            }

            do{
                try context.save()
                print("Saved")
              self.getTheWeight()
            }catch let error as NSError{
                print(error.localizedDescription)
         }

            
        }))
        
        
        self.present(weightCotroller, animated: true, completion: nil)
        
    }
    
    
    
    
    func getTheWeight(){
        
        //self.pickAnImage()
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Weights> = Weights.fetchRequest()
        do{
            
            let results = try context.fetch(fetchRequest)
            print("Number Of Results:\(results.count)")
            for trans in results as [NSManagedObject]{
                let data = trans.value(forKeyPath: "weights")
                //print("PickImage:\(data)")
                // profileImage.image = UIImage(data: data as! Data)
                currentWeight = data as? String
                
                
            }
            
            
        }catch{
            print("RetrieveDataError:"+error.localizedDescription)
        }
        
        do{
            try context.save()
        }catch{
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if(currentWeight != nil){
            weightUpdates.text = currentWeight
        }
    }
    
    func getTheWeeklyQuestions(){
        
        let url = URL(string: "http://54.197.12.149/user/WeeklyQuestions?token=\(token)")
        
        Alamofire.request(url!).responseJSON { (response) in
            let dict = response.result.value as! Dictionary<String,AnyObject>
            let dataArray = dict["data"] as! NSArray
            weeklyQuestions.removeAll()
            for dat in dataArray{
                let questionsData = dat as! Dictionary<String,String>
                let weekQuestion = WeeklyQuestions()
                weekQuestion.weeklyQuestions = questionsData["Questions"]!
                weeklyQuestions.append(weekQuestion)
                
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "weekreport", for: indexPath)
        
        (cell.viewWithTag(1) as? UITextView)?.text = weeklyQuestions[indexPath.row].weeklyQuestions
        if let answer = (cell.viewWithTag(2) as! UITextField).text{
        
            weeklyQuestions[indexPath.row].weeklyAnswers = answer
            
            if(indexPath.row == 2){
               (cell.viewWithTag(2) as! UITextField).keyboardType = .alphabet
            }else{
                (cell.viewWithTag(2) as! UITextField).keyboardType = .numberPad
            }
            if(indexPath.row == 6){
                if(answer.characters.count > 1){
                   
                    weightUpdates.text = answer
                    
                    let context = appDelegate.persistentContainer.viewContext
                    let entity = NSEntityDescription.entity(forEntityName: "Weights", in: context)
                    let transaction = NSManagedObject(entity: entity!, insertInto: context)
                    let fetchRequest: NSFetchRequest<ProfileImage> = ProfileImage.fetchRequest()
                    do{
                        
                        let results = try context.fetch(fetchRequest)
                        if(results.count > 1){
                            context.delete(results[0] as NSManagedObject)
                            try! context.save()
                        }
                        
                        
                        transaction.setValue(answer, forKey: "weights")
                        
                        
                        
                        
                    }catch{
                        print("RetrieveDataError:"+error.localizedDescription)
                    }
                    
                    do{
                        try context.save()
                        print("Saved")
                        self.getTheWeight()
                    }catch let error as NSError{
                        print(error.localizedDescription)
                    }

                    
                    
                }
            }
            
            
            
        }
        
        if(weeklyQuestions[indexPath.row].weeklyAnswers.characters.count > 1){
            (cell.viewWithTag(2) as! UITextField).text = weeklyQuestions[indexPath.row].weeklyAnswers
            
            
        }
        return cell
    }
    
    
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if weeklyQuestions.count > 0{
            return weeklyQuestions.count
        }else{
            return 0
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        weeklyScrollView.setContentOffset(CGPoint(x:0,y:250), animated: true)
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        weeklyScrollView.setContentOffset(CGPoint(x:0,y:0), animated: true)

    }
    

    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    @IBAction func SaveWeeklyBarButton(_ sender: UIBarButtonItem) {
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getTheWeeklyQuestions()
        menuButton.target = revealViewController()
        menuButton.action = #selector(SWRevealViewController.revealToggle(animated:))
        self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        // Do any additional setup after loading the view.
        weightUpdates.isEnabled = false
        self.hideKeyboardWhenTappedAround()
        getTheWeight()
        
        
        
       
        
        let coach = AlertController(title: "Weekly Log", message: "Click on the add sign on the top, to add your weekly weight", preferredStyle: .alert)
        //coach.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        coach.add(AlertAction(title: "OK", style: .normal))
        coach.view.addSubview(imageV!)
        self.present(coach, animated: true, completion: nil)
        

    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
