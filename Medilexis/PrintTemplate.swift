//
//  PrintTemplate.swift
//  Medilexis
//
//  Created by iOS Developer on 12/04/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit
import SCLAlertView
import Photos
import SkyFloatingLabelTextField

class PrintTemplate: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    
    @IBOutlet weak var headerTextOne: SkyFloatingLabelTextField!
    @IBOutlet weak var headerTextTwo: SkyFloatingLabelTextField!
    @IBOutlet weak var footerTextOne: SkyFloatingLabelTextField!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    let picker = UIImagePickerController()
    let userDefaults = Foundation.UserDefaults.standard
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
        
        if userDefaults.value(forKey: "HeaderOne") != nil{

            let headerOne = userDefaults.value(forKey: "HeaderOne") as! String
            
            headerTextOne.text = headerOne

        }
        
        if userDefaults.value(forKey: "HeaderTwo") != nil{
            
            let headerTwo = userDefaults.value(forKey: "HeaderTwo") as! String
            
            headerTextTwo.text = headerTwo
            
        }
        
        if userDefaults.value(forKey: "FooterOne") != nil{
            
            let Footer = userDefaults.value(forKey: "FooterOne")
            
            footerTextOne.text = Footer as! String!
            
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
                               didFinishPickingMediaWithInfo info: [String : AnyObject])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        let data = UIImagePNGRepresentation(chosenImage)
        userDefaults.set(data, forKey: "TemplateImage")
        dismiss(animated:true, completion: nil) //5
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
            
        } else {
            
            userDefaults.set(headerTextOne.text, forKey: "HeaderOne")
            userDefaults.set(headerTextTwo.text, forKey: "HeaderTwo")
            userDefaults.set(footerTextOne.text, forKey: "FooterOne")
            
            let alert = UIAlertController(title: "Success", message: "Template successfully saved", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil);
            
            return
            
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
    

}
