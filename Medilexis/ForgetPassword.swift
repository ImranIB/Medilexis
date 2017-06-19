//
//  ForgetPassword.swift
//  Medilexis
//
//  Created by iOS Developer on 21/03/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftSpinner

class ForgetPassword: UIViewController {

    @IBOutlet weak var emailTextFIeld: SkyFloatingLabelTextFieldWithIcon!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailTextFIeld.iconFont = UIFont(name: "FontAwesome", size: 12)
        emailTextFIeld.iconText = "\u{f003}"
        emailTextFIeld.iconColor = UIColor.lightGray
        emailTextFIeld.title = "Email"
        emailTextFIeld.placeholder = "Email"
        emailTextFIeld.titleFormatter = { $0 }
        emailTextFIeld.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        emailTextFIeld.iconMarginBottom = 1.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        emailTextFIeld.iconMarginLeft = 2.0
        self.view.addSubview(emailTextFIeld)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backBtnPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func resetPass(_ sender: UIButton) {
        
        let _ = emailTextFIeld.resignFirstResponder()
        
        let isEmailAddressValid = isValidEmailAddress(emailAddressString: emailTextFIeld.text!)
        
        if currentReachabilityStatus == .reachableViaWiFi ||  currentReachabilityStatus == .reachableViaWWAN{
            
            let _ = emailTextFIeld.resignFirstResponder()
            
            if emailTextFIeld.text == "" {
                
                let alert = UIAlertController(title: "Notice", message: "Please enter email address", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil);
                
                return
                
            } else if !isEmailAddressValid{
                
                let alert = UIAlertController(title: "Notice", message: "Please enter valid email address", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil);
                
                return
                
            }  else {
                
                let _ = emailTextFIeld.resignFirstResponder()
                
                SwiftSpinner.show("Resetting Password")
                
                let url = URL(string: "http://muapp.com/medilixis_server/public/forgetpass")!
                let jsonDict = ["email": emailTextFIeld.text]
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
                        print(json)
                        self.emailTextFIeld.text = ""
                        
                      
                        
                        DispatchQueue.main.async {
                            
                            SwiftSpinner.hide({
                                
                                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! Login
                                self.present(nextViewController, animated:true, completion:nil)
                                
                                return
                                
                                
                            })
                            

                            
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
    
    func isValidEmailAddress(emailAddressString: String) -> Bool {
        
        var returnValue = true
        let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
        
        do {
            let regex = try NSRegularExpression(pattern: emailRegEx)
            let nsString = emailAddressString as NSString
            let results = regex.matches(in: emailAddressString, range: NSRange(location: 0, length: nsString.length))
            
            if results.count == 0
            {
                returnValue = false
            }
            
        } catch let error as NSError {
            print("invalid regex: \(error.localizedDescription)")
            returnValue = false
        }
        
        return  returnValue
    }


}
