//
//  ProfileViewController+handler.swift
//  FinalProject
//
//  Created by Kranthi Chinnakotla on 11/3/16.
//  Copyright © 2016 edu.uncc.cs6010. All rights reserved.
//

import UIKit
import CoreData

extension ProfileViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func pickAnImage() -> Void{
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(picker, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImag: UIImage?
        
        if let originalImage = info["UIImagePickerControllerOriginalImage"]{
            
            selectedImag = (originalImage as! UIImage)
            
        }else if let editImage = info["UIImagePickerControllerEditedImage"]{
            selectedImag = (editImage as! UIImage)
        }
        selectedUrl = info[UIImagePickerControllerReferenceURL] as? NSURL
    
        
        if let image = selectedImag {
            profileImage.image = image
            
            
            //.child("userImages.png")
            
            let context = appDelegate.persistentContainer.viewContext
                    let entity = NSEntityDescription.entity(forEntityName: "ProfileImage", in: context)
                    let transaction = NSManagedObject(entity: entity!, insertInto: context)
                    guard let imageData = UIImagePNGRepresentation(profileImage.image!) else {
                        return
                    }
            
            
            
            let fetchRequest: NSFetchRequest<ProfileImage> = ProfileImage.fetchRequest()
            do{
                
                let results = try context.fetch(fetchRequest)
                if(results.count > 1){
                   context.delete(results[0] as NSManagedObject)
                    try! context.save()
                }
                
            
             transaction.setValue(imageData, forKey: "imageData")
                
                
                
                
            }catch{
                print("RetrieveDataError:"+error.localizedDescription)
            }
            
            

            
            
                   // transaction.setValue(imageData, forKey: "imageData")
            
                    do{
                        try context.save()
                        print("Saved")
                        getTheImage()
                    }catch let error as NSError{
                        print(error.localizedDescription)
                    }catch{
                        
                    }
            
            
            
        }
        
        
        
        
        dismiss(animated: true, completion: nil)
        

        
    }
            
    @nonobjc func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        print("Canceleld picker")
      //  dismiss(animated: true, completion: nil)
    }

    
}
