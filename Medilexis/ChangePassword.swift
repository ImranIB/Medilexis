//
//  ChangePassword.swift
//  Medilexis
//
//  Created by iOS Developer on 28/02/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftSpinner
import SCLAlertView

class ChangePassword: UIViewController {
    
    
    @IBOutlet weak var currentPasswordTextField: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var newPasswordTextField: SkyFloatingLabelTextFieldWithIcon!

    @IBOutlet weak var reTypePasswordTextField: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        currentPasswordTextField.iconFont = UIFont(name: "FontAwesome", size: 12)
        currentPasswordTextField.iconText = "\u{f13e}"
        currentPasswordTextField.iconColor = UIColor.lightGray
        currentPasswordTextField.title = "Current Password"
        currentPasswordTextField.titleFormatter = { $0 }
        currentPasswordTextField.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        currentPasswordTextField.iconMarginBottom = 1.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        currentPasswordTextField.iconMarginLeft = 2.0
        self.view.addSubview(currentPasswordTextField)
        
        newPasswordTextField.iconFont = UIFont(name: "FontAwesome", size: 12)
        newPasswordTextField.iconText = "\u{f13e}"
        newPasswordTextField.iconColor = UIColor.lightGray
        newPasswordTextField.title = "New Password"
        newPasswordTextField.titleFormatter = { $0 }
        newPasswordTextField.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        newPasswordTextField.iconMarginBottom = 1.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        newPasswordTextField.iconMarginLeft = 2.0
        self.view.addSubview(newPasswordTextField)
        
        reTypePasswordTextField.iconFont = UIFont(name: "FontAwesome", size: 12)
        reTypePasswordTextField.iconText = "\u{f13e}"
        reTypePasswordTextField.iconColor = UIColor.lightGray
        reTypePasswordTextField.title = "Re-Type Password"
        reTypePasswordTextField.titleFormatter = { $0 }
        reTypePasswordTextField.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        reTypePasswordTextField.iconMarginBottom = 1.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        reTypePasswordTextField.iconMarginLeft = 2.0
        self.view.addSubview(reTypePasswordTextField)
        
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

    @IBAction func navigateToHome(_ sender: UIBarButtonItem) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func save(_ sender: UIButton) {
        
        let defaults = UserDefaults.standard
        //let cpassword = defaults.value(forKey: "Password") as! String
        
        let token = defaults.value(forKey: "Token")
        
        if currentReachabilityStatus == .reachableViaWiFi ||  currentReachabilityStatus == .reachableViaWWAN {
            
            if currentPasswordTextField.text == "" || newPasswordTextField.text == "" || reTypePasswordTextField.text == ""{
                
                let alert = UIAlertController(title: "Notice", message: "Please fill all the fields", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil);
                
                return
                
            } else if newPasswordTextField.text != reTypePasswordTextField.text {
                
                let alert = UIAlertController(title: "Notice", message: "Passwords not matched", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil);
                
            } else {
                
                let _ = reTypePasswordTextField.resignFirstResponder()
                let _ = currentPasswordTextField.resignFirstResponder()
                let _ = newPasswordTextField.resignFirstResponder()
                
                SwiftSpinner.show("Changing Password....")
                
                let url = URL(string: "http://muapp.com/medilixis_server/public/changepassword")!
                let jsonDict = ["oldpass": currentPasswordTextField.text, "newpass": newPasswordTextField.text, "token": token]
                let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict, options: [])
                
                var request = URLRequest(url: url)
                request.httpMethod = "post"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = jsonData
                
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        print("error:", error)
                        SwiftSpinner.hide()
                    }
                    
                    do {
                        guard let data = data else { return }
                        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else { return }
                       // print("json:", json)
                    
                       let status = json["status"] as? String
                       
                        if (status == "success"){
                            
                            DispatchQueue.main.async {
                                
                                SwiftSpinner.hide()
                                
                                self.currentPasswordTextField.text = ""
                                self.newPasswordTextField.text = ""
                                self.reTypePasswordTextField.text = ""
                                
                                let alert = UIAlertController(title: "Success", message: "Password successfully updated.", preferredStyle: UIAlertControllerStyle.alert)
                                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                                alert.addAction(action)
                                
                                self.present(alert, animated: true, completion: nil);
                                
                                return
                                
                                
                            }
                            
                        } else {
                            
                            DispatchQueue.main.async {
                                
                                SwiftSpinner.hide()
                                
                                self.currentPasswordTextField.text = ""
                                self.newPasswordTextField.text = ""
                                self.reTypePasswordTextField.text = ""
                                
                                let alert = UIAlertController(title: "Notice", message: "Incorrect correct password", preferredStyle: UIAlertControllerStyle.alert)
                                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                                alert.addAction(action)
                                
                                self.present(alert, animated: true, completion: nil);
                                
                                return
                                
                            }
                        }
                       
                        
                    } catch {
                        print("error:", error)
                        
                    }
                }
                
                task.resume()
                
            }

            
        } else {
            
            DispatchQueue.main.async {
                
                let alert = UIAlertController(title: "No Connection", message: "Please check your internet connection and try again!", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil);
                
                return
            }
        }
        
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        
        currentPasswordTextField.text = ""
        newPasswordTextField.text = ""
        reTypePasswordTextField.text = ""
    }
    
    
}
