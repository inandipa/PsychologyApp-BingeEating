//
//  SaveWeeklyTableViewController.swift
//  FinalProject
//
//  Created by Kranthi Chinnakotla on 12/14/16.
//  Copyright © 2016 edu.uncc.cs6010. All rights reserved.
//

import UIKit
import Alamofire

class SaveWeeklyTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        var questionAnswers = Dictionary<String,String>()
        questionAnswers = ["Week": weeklyQuestions[7].weeklyAnswers,"Binges":weeklyQuestions[0].weeklyAnswers,"V/L/D":weeklyQuestions[5].weeklyAnswers,"GoodDays":weeklyQuestions[1].weeklyAnswers,"Weight":currentWeight!,"F/V":weeklyQuestions[4].weeklyAnswers,"PhysicalActivity":weeklyQuestions[3].weeklyAnswers,"Events":weeklyQuestions[2].weeklyAnswers]
        
        
        let url = URL(string:"http://54.197.12.149/user/WeeklyResponse")
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(weeklyQuestions.count == 0){
        
            return 0
            
        }else{
            
            return weeklyQuestions.count
        }
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableviewcell", for: indexPath)

        (cell.viewWithTag(1) as! UITextView).text = weeklyQuestions[indexPath.row].weeklyQuestions
        (cell.viewWithTag(2) as! UITextView).text = weeklyQuestions[indexPath.row].weeklyAnswers

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
