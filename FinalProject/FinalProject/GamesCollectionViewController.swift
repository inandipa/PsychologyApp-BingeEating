//
//  GamesCollectionViewController.swift
//  FinalProject
//
//  Created by Kranthi Chinnakotla on 12/14/16.
//  Copyright © 2016 edu.uncc.cs6010. All rights reserved.
//

import UIKit
import Alamofire


private let reuseIdentifier = "Cell"


class GamesCollectionViewController: UICollectionViewController {
    
    @IBAction func submit(_ sender: UIBarButtonItem) {
        
        var count = 0
        let alert = UIAlertController(title: "Results", message: "Results Of the Game", preferredStyle: .alert)
        for  i in 0...tags.count-1{
            
            
            for tag in tags{
            
                if(tags[i] != tag){
                    count = 1
                }
            
            }
        }
        
        if (count == 0){
            alert.addAction(UIAlertAction(title: "Correct",style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else if(count == 1){
            alert.addAction(UIAlertAction(title: "InCorrect",style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBOutlet weak var gamesMenu: UIBarButtonItem!

    var object = Array<Dictionary<String,String>>()
    var imageUrl = [URL]()
    var imageKey = [String]()
    var tags = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        
        gamesMenu.target = revealViewController()
        gamesMenu.action = #selector(SWRevealViewController.revealToggle(animated:))
        
        
                

        
        
        let url = URL(string: "http://54.197.12.149/user/game?token="+token);
        // Do any additional setup after loading the view, typically from a nib.
        Alamofire.request(url!).responseJSON { (response) in
            let ImageData = response.result.value as? Dictionary<String,AnyObject>
            var ImageDictionary = Dictionary<String, NSArray>()
            ImageDictionary["data"] = (ImageData!["data"] as! NSArray)
            self.imageUrl.removeAll()
            for i in ImageDictionary["data"]!{
                let localObject = i as! Dictionary<String,String>
                //self.object.append(localObject)
                let url = URL(string: localObject["value"]!)
                let key = localObject["key"]
                if(url != nil){
                
                    self.imageUrl.append(url!)
                    self.imageKey.append(key!)
                }
                
                
                
                
//                let data = try? Data(contentsOf: url!)
//                if(data != nil){
//                    self.imageUrl.append(data!)
//                }
                
                
                
            }
            
            DispatchQueue.main.async {
                
               self.collectionView?.reloadData()
            }
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
     //   self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
     //   self.collectionView!.register(GamesCell.self, forCellWithReuseIdentifier: "Cell")

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
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        if(imageUrl.count == 0){
            
            return 0
            
        }else {
        
            return imageUrl.count
        }
        
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GamesCell
        
        
            //collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! GamesCell
        let imageView = cell.gamesImageView
        let button = cell.viewWithTag(10) as! UIButton
        
     //   button!.addTarget(Any?, action: <#T##Selector#>, for: <#T##UIControlEvents#>)
        
        
        
        func downloadImage(url: URL) {
            print("Download Started")
            getDataFromUrl(url: url) { (data, response, error)  in
                guard let data = data, error == nil else { return }
                print(response?.suggestedFilename ?? url.lastPathComponent)
                print("Download Finished")
                DispatchQueue.main.async() { () -> Void in
                    if(imageView != nil){
                        imageView!.image = UIImage(data: data)
                    }
                    
                }
            }
        }
        
        downloadImage(url: imageUrl[indexPath.row])
        button.addTarget(self, action: #selector(selectedImage), for: .touchUpInside)
        button.tag = indexPath.row

        
       // (cell.viewWithTag(1) as? UIImageView)?.image = UIImage(data: imageUrl[indexPath.row])
    
        // Configure the cell
    
        return cell
    }
    func selectedImage(sender: UIButton){
        sender.titleLabel?.text = "Done"
        if(sender.layer.backgroundColor == UIColor.white.cgColor){
        
            sender.layer.backgroundColor = UIColor.green.cgColor
            tags.append(imageKey[sender.tag])
            
        }else if(sender.layer.backgroundColor == UIColor.green.cgColor){
            sender.layer.backgroundColor = UIColor.red.cgColor
        }
        
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (_ data: Data?, _  response: URLResponse?, _ error: Error?) -> Void) {
        URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            completion(data, response, error)
            }.resume()
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
