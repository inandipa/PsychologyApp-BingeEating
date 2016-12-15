//
//  ProfileViewController.swift
//  FinalProject
//
//  Created by Kranthi Chinnakotla on 11/3/16.
//  Copyright © 2016 edu.uncc.cs6010. All rights reserved.
//

import UIKit
import CoreData
import AWSCore
import AWSS3
import Charts

let appDelegate = UIApplication.shared.delegate as! AppDelegate
var databaseImage: Data?

func getTheImage(){
    
    //self.pickAnImage()
    let context = appDelegate.persistentContainer.viewContext
    let fetchRequest: NSFetchRequest<ProfileImage> = ProfileImage.fetchRequest()
    do{
        
        let results = try context.fetch(fetchRequest)
        print("Number Of Results:\(results.count)")
        for trans in results as [NSManagedObject]{
            let data = trans.value(forKeyPath: "imageData")
            //print("PickImage:\(data)")
            // profileImage.image = UIImage(data: data as! Data)
            databaseImage = data as? Data
            
        }
        
        
    }catch{
        print("RetrieveDataError:"+error.localizedDescription)
    }
    
    do{
        try context.save()
    }catch{
        
    }
}






class ProfileViewController: UIViewController {

   
    var selectedUrl: NSURL?
    @IBOutlet weak var progress: UILabel!
    @IBOutlet weak var profileMenuButton: UIBarButtonItem!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBAction func selectAnImage(_ sender: UIButton) {
        
        self.pickAnImage()
        
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let layer = profileImage.layer
        layer.cornerRadius = profileImage.frame.size.width/10
        layer.borderWidth = 1
        layer.masksToBounds = true
        
        
        profileImage.image = UIImage(named: "user-icon")
        getTheImage()
        
        if(databaseImage != nil){
            profileImage.image = UIImage(data: databaseImage!)
        }
        
          }
    
    override func viewDidAppear(_ animated: Bool) {

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getTheImage()
        
        if(databaseImage != nil){
            profileImage.image = UIImage(data: databaseImage!)
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

}
