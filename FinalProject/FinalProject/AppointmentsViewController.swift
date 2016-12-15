//
//  AppointmentsViewController.swift
//  FinalProject
//
//  Created by Kranthi Chinnakotla on 11/9/16.
//  Copyright © 2016 edu.uncc.cs6010. All rights reserved.
//

import UIKit
import EventKit
import Alamofire

class AppointmentsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    @IBOutlet weak var appointmentsMenuButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var bookings = [AppointmentsClass]()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        appointmentsMenuButton.target = revealViewController()
        appointmentsMenuButton.action = #selector(SWRevealViewController.revealToggle(animated:))
        pullTheAppointments()
        
    }

    func pullTheAppointments(){
        let url = "http://54.197.12.149/user/appointments?token=\(token)"
        Alamofire.request(url).responseJSON { (response) in
            
            let resp = response.result.value as? Dictionary<String,AnyObject>
            if(resp != nil){
                let appointments = resp?["data"] as? NSArray
                self.bookings.removeAll()
                if((appointments?.count)! > 0){
                    
                
                for appnt in appointments!{
                    
                    let appointment = appnt as? Dictionary<String,AnyObject>
                    let booking = AppointmentsClass()
                    booking.userName = (appointment?["username"])! as! String
                    booking.supporter = (appointment?["supporter"])! as! String
                    booking.timeOfAppointment = (appointment?["Time"])! as! String
                    
                    self.bookings.append(booking)
                    
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                }else{
                    let alertController = UIAlertController(title: "No Appointments", message: "Currently no appointments available", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                }

            }else if(resp == nil){
                let alertController = UIAlertController(title: "Error in retreiving appointments", message: "Couldn't pull the appointments", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alertController, animated: true, completion: nil)
            }
            
            
            
        }
        
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.bookings.count > 0){
            return self.bookings.count
        }
        
       return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "basicCell")!
        
        (cell.viewWithTag(2) as? UITextView)?.text = bookings[indexPath.row].timeOfAppointment
        (cell.viewWithTag(2) as? UITextView)?.layer.cornerRadius = 10
//        (cell.viewWithTag(2) as? UITextField)?.layer.borderColor = UIColor.black.cgColor
//        (cell.viewWithTag(2) as? UITextField)?.sizeToFit()
//        (cell.viewWithTag(2) as? UITextField)?.isEnabled = false
        (cell.viewWithTag(3) as? UITextView)?.text = bookings[indexPath.row].supporter
        (cell.viewWithTag(3) as? UITextView)?.layer.cornerRadius = 10
//        (cell.viewWithTag(3) as? UITextField)?.layer.borderColor = UIColor.black.cgColor
//        (cell.viewWithTag(3) as? UITextField)?.sizeToFit()
//        (cell.viewWithTag(3) as? UITextField)?.isEnabled = false
        
        
        (cell.viewWithTag(12) as? UILabel)?.layer.cornerRadius = 5
//        (cell.viewWithTag(12) as? UILabel)?.layer.borderWidth = CGFloat(2)
//        (cell.viewWithTag(12) as? UILabel)?.layer.borderColor = UIColor.black.cgColor
        (cell.viewWithTag(13) as? UILabel)?.layer.cornerRadius = 5
//        (cell.viewWithTag(13) as? UILabel)?.layer.borderWidth = CGFloat(2)
//        (cell.viewWithTag(13) as? UILabel)?.layer.borderColor = UIColor.black.cgColor
        
//        if let calendars = self.calendars {
//            let calendarName = calendars[(indexPath as NSIndexPath).row].title
//            cell.textLabel?.text = calendarName
//            
//        } else {
//            cell.textLabel?.text = "Unknown Calendar Name"
//        }
        
        return cell
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        //checkCalendarAuthorizationStatus()
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
