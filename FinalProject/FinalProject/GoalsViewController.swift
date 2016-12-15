//
//  GoalsViewController.swift
//  FinalProject
//
//  Created by Kranthi Chinnakotla on 11/27/16.
//  Copyright © 2016 edu.uncc.cs6010. All rights reserved.
//

import UIKit
import SDCAlertView
import CoreData

class GoalsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var goals = [String]()
    var alertTextField: UITextField?
    var transaction: NSManagedObject?
    let context = appDelegate.persistentContainer.viewContext
    var fetchGoals: NSFetchRequest<Goals>?
    var results = [Goals]()

    @IBOutlet weak var goalsMenu: UIBarButtonItem!
    @IBAction func addGoals(_ sender: UIBarButtonItem) {
        let goalsAlert = AlertController(title: "Goals", message: "Enter the goals in the textfield", preferredStyle: .alert)
                goalsAlert.addTextField { (textField) in
        
                   self.alertTextField = textField
        
        
                }
        
                goalsAlert.add(AlertAction(title: "OK", style: .preferred, handler: { (alert) in
                    self.goals.append((self.alertTextField?.text!)!)
                    self.inserData()
                                    }))
                self.present(goalsAlert, animated: true, completion: nil)
                

        
        
    }
    
    
    @IBOutlet weak var tableView: UITableView!

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "goalscell")!
        if(goals.count > 0){
        
            let goal = goals[indexPath.row]
            (cell.viewWithTag(101) as? UITextView)?.text = goal
            (cell.viewWithTag(101) as? UITextView)?.layer.cornerRadius = 20
            //(cell.viewWithTag(1) as? UILabel)?.layer.borderWidth = 2
            //(cell.viewWithTag(1) as? UILabel)?.layer.borderColor = UIColor.black.cgColor
            
            (cell.viewWithTag(100) as? UIButton)?.addTarget(self, action: #selector(removeGoal), for: .touchUpInside)
            (cell.viewWithTag(100) as? UIButton)?.tag = indexPath.row
            if let shareButton = cell.viewWithTag(10) as? UIButton{
            
                shareButton.addTarget(self, action: #selector(shareWithSupporter), for: .touchUpInside)
                shareButton.tag = indexPath.row
            }
            
            
        }
        
        
        
        return cell
        
    }
    
    func removeGoal(sender: UIButton){
        
        goals.remove(at: sender.tag)
        context.delete(results[sender.tag] as NSManagedObject)
        try! context.save()
        tableView.reloadData()
        
    }
    
    func shareWithSupporter(sender: UIButton){
        
        let shareAlert = AlertController(title: "Share Goals", message: "Do you want to share the goals with your supporter?", preferredStyle: .alert)
        shareAlert.add(AlertAction(title: "Yes", style: .preferred, handler: { (action) in
            
        }))
        shareAlert.add(AlertAction(title: "No", style: .preferred))
        self.present(shareAlert, animated: true, completion: nil)
        
        
    }
    
    func coachAppearance(){
        
//        let img = UIImage(named: "images")
//        let imageView = UIImageView(frame: CGRect(x: 80, y: 80, width: 172, height: 172))
//        imageView.layer.cornerRadius = imageView.frame.size.width/10
//        imageView.layer.borderColor = UIColor.purple.cgColor
//        imageView.layer.borderWidth = CGFloat(2)
//        imageView.layer.masksToBounds = true
//        imageView.image = img
        let coach = AlertController(title: "Hi there!", message: "Great decision to have goals, try to add realistic and achievable goals", preferredStyle: .alert)
        //coach.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        coach.add(AlertAction(title: "OK", style: .normal))
        coach.view.addSubview(imageV!)
        self.present(coach, animated: true, completion: nil)
        
    }
    
    func inserData(){
        
        let entity = NSEntityDescription.entity(forEntityName: "Goals", in: context)
        transaction = NSManagedObject(entity: entity!, insertInto: context)
        transaction?.setValue(globalUser, forKey: "userName")
        transaction?.setValue((alertTextField?.text!)!, forKey: "goal")
        try! self.context.save()
        self.tableView.reloadData()

        
    }
    
    func retrieveData(){
        do{
            fetchGoals = Goals.fetchRequest()
            results = try context.fetch(fetchGoals!)
            for trans in results as [NSManagedObject]{
                if(trans.value(forKey: "userName") != nil){
                    if((trans.value(forKey: "userName") as! String) == globalUser){
                        
                        goals.append(trans.value(forKey: "goal") as! String)
                    }
                }
                
                
            }
            try! context.save()
            tableView.reloadData()
            
        }catch{
            print("DataError:"+error.localizedDescription)
        }
        
        
        
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        goalsMenu.target = revealViewController()
        goalsMenu.action = #selector(SWRevealViewController.revealToggle(animated:))
        coachAppearance()
        retrieveData()
        
        
        // Do any additional setup after loading the view.
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
