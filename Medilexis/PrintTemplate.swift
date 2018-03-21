//
//  PrintTemplate.swift
//  Medilexis
//
//  Created by iOS Developer on 12/04/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit
import Photos
import CoreData
import SkyFloatingLabelTextField

class PrintTemplate: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate  {
    
    
    @IBOutlet weak var headerTextOne: SkyFloatingLabelTextField!
    @IBOutlet weak var headerTextTwo: SkyFloatingLabelTextField!
    @IBOutlet weak var footerTextOne: SkyFloatingLabelTextField!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    let picker = UIImagePickerController()
    let userDefaults = Foundation.UserDefaults.standard
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let text = "N/A"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        headerTextOne.title = "Heading Text"
        headerTextOne.titleFormatter = { $0 }
        headerTextOne.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        self.view.addSubview(headerTextOne)
        
        headerTextTwo.title = "Sub Heading Text"
        headerTextTwo.titleFormatter = { $0 }
        headerTextTwo.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        self.view.addSubview(headerTextTwo)
        
        footerTextOne.title = "Footer text"
        footerTextOne.titleFormatter = { $0 }
        footerTextOne.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        self.view.addSubview(footerTextOne)

        
         picker.delegate = self
        
        let uid = userDefaults.value(forKey: "UserID")
        let fetchRequest:NSFetchRequest<Users> = Users.fetchRequest()
        let predicate = NSPredicate(format: "(userID = %@)", uid as! CVarArg)
        fetchRequest.predicate = predicate
        
        do {
            let count = try getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            if count > 0 {
                
                print("record exists")
                let fetchResult = try context.fetch(fetchRequest)
                
                for item in fetchResult {
                    
                    headerTextOne.text = item.heading
                    headerTextTwo.text = item.subHeading
                    footerTextOne.text = item.footer
                }
                
            }
        }catch {
            print(error.localizedDescription)
        }
        
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func captureImage(_ sender: UIButton) {
        
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        let data = UIImagePNGRepresentation(chosenImage)
        dismiss(animated:true, completion: nil) //5
        
        let uid = userDefaults.value(forKey: "UserID")
        let fetchRequest:NSFetchRequest<Users> = Users.fetchRequest()
        let predicate = NSPredicate(format: "(userID = %@)", uid as! CVarArg)
        fetchRequest.predicate = predicate
        
        do {
            let count = try getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            if count > 0 {
                
                let fetchResult = try context.fetch(fetchRequest)
                
                for item in fetchResult {
                    
                    item.logo =  data as NSData?
                    
                    try context.save()
                    
                    
                    let alert = UIAlertController(title: "Success", message: "Image successfully updated", preferredStyle: UIAlertControllerStyle.alert)
                    let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                    alert.addAction(action)
                    
                    self.present(alert, animated: true, completion: nil);
                    
                    return
                }
                
            } else {
                
                
                let userID = userDefaults.value(forKey: "UserID") as! Int32
                let context = getContext()
                
                let entity = NSEntityDescription.entity(forEntityName: "Users", in: context)
                
                let managedObj = NSManagedObject(entity: entity!, insertInto: context)
                
                managedObj.setValue(userID, forKey: "userID")
                managedObj.setValue(data, forKey: "logo")
                
                do {
                    try context.save()
                    
                    let alert = UIAlertController(title: "Success", message: "Image added successfully", preferredStyle: UIAlertControllerStyle.alert)
                    let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                    alert.addAction(action)
                    
                    self.present(alert, animated: true, completion: nil);
                    
                    return
                    
                    
                } catch {
                    print(error.localizedDescription)
                }
                
            }
            
        }catch {
            print(error.localizedDescription)
        }

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveTemplate(_ sender: UIButton) {
        
        if headerTextOne.text == "" || headerTextTwo.text == "" || footerTextOne.text == "" {
            
            let alert = UIAlertController(title: "Notice", message: "Please fill all the fields", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil);
            
            return
            
        } else if (headerTextOne.text?.characters.count)! > 45 {
            
            let alert = UIAlertController(title: "Notice", message: "Heading text should not be more then 45 characters", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil);
            
        } else if (headerTextTwo.text?.characters.count)! > 45 {
            
            let alert = UIAlertController(title: "Notice", message: "Sub heading text should not be more then 45 characters", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil);
            
        } else if (footerTextOne.text?.characters.count)! > 100 {
            
            let alert = UIAlertController(title: "Notice", message: "Footer text should not be more then 100 characters", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil);
            
        } else {
            
            let uid = userDefaults.value(forKey: "UserID")
            let fetchRequest:NSFetchRequest<Users> = Users.fetchRequest()
            let predicate = NSPredicate(format: "(userID = %@)", uid as! CVarArg)
            fetchRequest.predicate = predicate
            
            do {
                let count = try getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
                
                if count > 0 {
                    
                    print("updated")
                    let fetchResult = try context.fetch(fetchRequest)
                    
                    for item in fetchResult {
                        
                        item.heading =  headerTextOne.text
                        item.subHeading = headerTextTwo.text
                        item.footer = footerTextOne.text
                        
                        try context.save()
                        
                        
                        let alert = UIAlertController(title: "Success", message: "Template successfully updated", preferredStyle: UIAlertControllerStyle.alert)
                        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                        alert.addAction(action)
                        
                        self.present(alert, animated: true, completion: nil);
                        
                        return
                    }
                    
                } else {
                    
                    
                    let userID = userDefaults.value(forKey: "UserID") as! Int32
                    let context = getContext()
                    
                    let entity = NSEntityDescription.entity(forEntityName: "Users", in: context)
                    
                    let managedObj = NSManagedObject(entity: entity!, insertInto: context)
                    
                    managedObj.setValue(userID, forKey: "userID")
                    managedObj.setValue(headerTextOne.text, forKey: "heading")
                    managedObj.setValue(headerTextTwo.text, forKey: "subHeading")
                    managedObj.setValue(footerTextOne.text, forKey: "footer")
                    
                    do {
                        try context.save()
                        
                        let alert = UIAlertController(title: "Success", message: "Template added successfully", preferredStyle: UIAlertControllerStyle.alert)
                        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                        alert.addAction(action)
                        
                        self.present(alert, animated: true, completion: nil);
                        
                        return
                        
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                }
                
            }catch {
                print(error.localizedDescription)
            }
            
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    @IBAction func navigateToHome(_ sender: UIBarButtonItem) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    
    func getContext () -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }

}
