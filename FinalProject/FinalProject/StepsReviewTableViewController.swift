//
//  StepsReviewTableViewController.swift
//  FinalProject
//
//  Created by Araballi, Pawan on 12/14/16.
//  Copyright © 2016 edu.uncc.cs6010. All rights reserved.
//

import UIKit

class StepsReviewTableViewController: UITableViewController {

    @IBOutlet weak var slideButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        slideButton.target = revealViewController()
        slideButton.action = #selector(SWRevealViewController.revealToggle(animated:))

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if reviewQuestions.count == 0 {
            return 0
        }else{
            return reviewQuestions.count + 1
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == reviewQuestions.count {

            let cell = tableView.dequeueReusableCell(withIdentifier: "stepsNextStepIdentifier", for: indexPath) as! NextStepReviewTableViewCell
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "stepsCellIdentifier", for: indexPath) as! StepsTableViewCell
            
            cell.question.text = reviewQuestions[indexPath.row].question
            cell.switch.addTarget(self, action: #selector(nextStep), for: .touchUpInside)
            cell.switch.tag = indexPath.row
            if reviewQuestions[indexPath.row].answer == "YES"{
                cell.switch.isOn = true
            }else{
                cell.switch.isOn = false
            }
            return cell
        }
    }
    
    func nextStep(sender: UISwitch){
        if reviewQuestions[sender.tag].answer == "YES"{
            reviewQuestions[sender.tag].answer = "NO"
        }else{
            reviewQuestions[sender.tag].answer = "YES"
        }
        print(reviewQuestions[sender.tag].answer)
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
