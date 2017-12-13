//
//  LoginVC.swift
//  Medilexis
//
//  Created by iOS Developer on 08/02/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftSpinner
import SystemConfiguration

class Login: UIViewController{
    
    
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextFieldWithIcon!


    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextField.iconFont = UIFont(name: "FontAwesome", size: 12)
        emailTextField.iconText = "\u{f003}"
        emailTextField.iconColor = UIColor.lightGray
        emailTextField.title = "Email"
        emailTextField.titleFormatter = { $0 }
        emailTextField.titleLabel.font = UIFont(name: "FontAwesome", size: 12)
        emailTextField.iconMarginBottom = 0.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        emailTextField.iconMarginLeft = 2.0
        self.view.addSubview(emailTextField)
        
        passwordTextField.iconFont = UIFont(name: "FontAwesome", size: 11)
        passwordTextField.iconText = "\u{f13e}"
        passwordTextField.iconColor = UIColor.lightGray
        passwordTextField.title = "Password"
        passwordTextField.titleFormatter = { $0 }
        passwordTextField.titleLabel.font = UIFont(name: "FontAwesome", size: 12)
        passwordTextField.iconMarginBottom = 0.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        passwordTextField.iconMarginLeft = 2.0
        self.view.addSubview(emailTextField)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("Memory Issue on Login")
    }
    
    @IBAction func login(_ sender: UIButton) {
        
        let _ = passwordTextField .resignFirstResponder()
        let _ = emailTextField.resignFirstResponder()
        
        if currentReachabilityStatus == .reachableViaWiFi ||  currentReachabilityStatus == .reachableViaWWAN {
            
            if emailTextField.text == "" || passwordTextField.text == "" {
                
                let alert = UIAlertController(title: "Notice", message: "Please fill all the fields", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil);
                
                return

            } else {
                
                SwiftSpinner.show("Authenticating User Account")
                
                let url = URL(string: "http://muapp.com/medilixis_server/public/login")!
                let jsonDict = ["email": emailTextField.text, "password": passwordTextField.text]
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
                        
                        //print(json)
                        
                       let status = json["status"] as? String
                        
                        if (status == "success"){
                            
                            DispatchQueue.main.async {
                         
                                self.emailTextField.text = ""
                                self.passwordTextField.text = ""
                                
                                let status = json["user_details"] as! NSDictionary
                               
                                let response = json["data"] as! NSArray
                                let details = response[0] as! [String:Any]
                                let userDefaults = Foundation.UserDefaults.standard
                                
                                userDefaults.set("true", forKey: "login")
                                userDefaults.set(status["address"]!, forKey: "Address")
                                userDefaults.set(status["city"]!, forKey: "City")
                                userDefaults.set(status["country"]!, forKey: "Country")
                                userDefaults.set(status["firstname"]!, forKey: "FirstName")
                                userDefaults.set(status["lastname"]!, forKey: "LastName")
                                userDefaults.set(status["npi"]!, forKey: "Npi")
                                userDefaults.set(status["phone"]!, forKey: "Phone")
                                userDefaults.set(status["state"]!, forKey: "State")
                                userDefaults.set(status["zipcode"]!, forKey: "Zipcode")
                                userDefaults.set(status["retypepassword"]!, forKey: "Password")
                                userDefaults.set(details["username"]!, forKey: "Username")
                                userDefaults.set(details["token"]!, forKey: "Token")
                                userDefaults.set(details["userID"]!, forKey: "UserID")
                                userDefaults.set(details["email"]!, forKey: "Email")
                                userDefaults.set(true, forKey: "photos")
                                userDefaults.set(true, forKey: "cpt")
                                userDefaults.set(true, forKey: "rx")
                                userDefaults.set(true, forKey: "anotherphoto")
                                userDefaults.set(false, forKey: "qaTranscription")
                                
                                SwiftSpinner.hide()
                                
                                // activityIndicator.stopAnimating()
                                
                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                
                                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
                                self.present(nextViewController, animated:true, completion:nil)
                                return
                                
                                
                            }
                            
                        } else {
                            
                            DispatchQueue.main.async {
                        
                                SwiftSpinner.hide()
                                
                                let alert = UIAlertController(title: "Hold On", message: "Invalid Credentials", preferredStyle: UIAlertControllerStyle.alert)
                                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                                alert.addAction(action)
                                
                                self.present(alert, animated: true, completion: nil);
                                
                                return
                            }
                        }
                        
                        
                    } catch {
                        
                        print("error:", error)
                        
                        DispatchQueue.main.async {
                            
                            let alert = UIAlertController(title: "Notice", message: "Unable to login! Please try again later.", preferredStyle: UIAlertControllerStyle.alert)
                            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                            alert.addAction(action)
                            
                            self.present(alert, animated: true, completion: nil);
                            
                            
                            SwiftSpinner.hide()
                            
                            
                            return
                        }
                        
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
    
    func loginAlertMessage(userMessage: String){
        
        let alert = UIAlertController(title: "Alert", message: userMessage, preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(action)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func loginBackBtn(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    

}
