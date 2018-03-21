//
//  RegisterVC.swift
//  Medilexis
//
//  Created by iOS Developer on 09/02/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftSpinner
import SystemConfiguration

class Register: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var firstNameTextField: SkyFloatingLabelTextFieldWithIcon!

    @IBOutlet weak var lastNameTextField: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var practiceNameTextField: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var phoneTextField: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var practiceAddressTextField: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var npiTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var reTypePasswordTextField: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var countriesTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var cityTextFIeld: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var stateTextFIeld: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var zipcodeTextField: SkyFloatingLabelTextFieldWithIcon!
    
    
    var countries: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for code in NSLocale.isoCountryCodes as [String] {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en_U").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
            countries.append(name)
        }
        
        //print(countries)
        
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        
        countriesTextField.inputView = pickerView
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar.barStyle = UIBarStyle.blackTranslucent
        
        toolBar.tintColor = UIColor.white
        
        toolBar.backgroundColor = UIColor.black
        
        
        let defaultButton = UIBarButtonItem(title: "Default", style: UIBarButtonItemStyle.plain, target: self, action: #selector(Register.tappedToolBarBtn))
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(Register.donePressed))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label.font = UIFont(name: "Helvetica", size: 12)
        
        label.backgroundColor = UIColor.clear
        
        label.textColor = UIColor.white
        
        label.text = "Select a Country"
        
        label.textAlignment = NSTextAlignment.center
        
        let textBtn = UIBarButtonItem(customView: label)
        
        toolBar.setItems([defaultButton,flexSpace,textBtn,flexSpace,doneButton], animated: true)
        
        countriesTextField.inputAccessoryView = toolBar
        
        firstNameTextField.iconFont = UIFont(name: "FontAwesome", size: 12)
        firstNameTextField.iconText = "\u{f2c0}"
        firstNameTextField.iconColor = UIColor.lightGray
        firstNameTextField.title = "First Name"
        firstNameTextField.titleFormatter = { $0 }
        firstNameTextField.titleLabel.font = UIFont(name: "FontAwesome", size:11)
        firstNameTextField.iconMarginBottom = 1.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        firstNameTextField.iconMarginLeft = 2.0
        self.view.addSubview(firstNameTextField)
        
        lastNameTextField.iconFont = UIFont(name: "FontAwesome", size: 12)
        lastNameTextField.iconText = "\u{f2c0}"
        lastNameTextField.iconColor = UIColor.lightGray
        lastNameTextField.title = "Last Name"
        lastNameTextField.titleFormatter = { $0 }
        lastNameTextField.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        lastNameTextField.iconMarginBottom = 1.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        lastNameTextField.iconMarginLeft = 2.0
        self.view.addSubview(lastNameTextField)
        
        practiceNameTextField.iconFont = UIFont(name: "FontAwesome", size: 12)
        practiceNameTextField.iconText = "\u{f044}"
        practiceNameTextField.iconColor = UIColor.lightGray
        practiceNameTextField.title = "Practice Name"
        practiceNameTextField.titleFormatter = { $0 }
        practiceNameTextField.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        practiceNameTextField.iconMarginBottom = 1.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        practiceNameTextField.iconMarginLeft = 2.0
        self.view.addSubview(practiceNameTextField)
        
        practiceAddressTextField.iconFont = UIFont(name: "FontAwesome", size: 12)
        practiceAddressTextField.iconText = "\u{f041}"
        practiceAddressTextField.iconColor = UIColor.lightGray
        practiceAddressTextField.title = "Practice Address"
        practiceNameTextField.titleFormatter = { $0 }
        practiceAddressTextField.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        practiceAddressTextField.iconMarginBottom = 1.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        practiceAddressTextField.iconMarginLeft = 2.0
        self.view.addSubview(practiceAddressTextField)
        
        emailTextField.iconFont = UIFont(name: "FontAwesome", size: 12)
        emailTextField.iconText = "\u{f003}"
        emailTextField.iconColor = UIColor.lightGray
        emailTextField.title = "Email"
        emailTextField.titleFormatter = { $0 }
        emailTextField.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        emailTextField.iconMarginBottom = 1.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        emailTextField.iconMarginLeft = 2.0
        self.view.addSubview(emailTextField)
        
        phoneTextField.iconFont = UIFont(name: "FontAwesome", size: 11)
        phoneTextField.iconText = "\u{f095}"
        phoneTextField.iconColor = UIColor.lightGray
        phoneTextField.title = "Phone"
        phoneTextField.titleFormatter = { $0 }
        phoneTextField.titleLabel.font = UIFont(name: "FontAwesome", size: 9)
        phoneTextField.iconMarginBottom = 1.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        phoneTextField.iconMarginLeft = 2.0
        self.view.addSubview(phoneTextField)
        
        npiTextField.iconFont = UIFont(name: "FontAwesome", size: 12)
        npiTextField.iconText = "\u{f0e7}"
        npiTextField.iconColor = UIColor.lightGray
        npiTextField.title = "NPI"
        npiTextField.titleFormatter = { $0 }
        npiTextField.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        npiTextField.iconMarginBottom = 1.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        npiTextField.iconMarginLeft = 2.0
        self.view.addSubview(npiTextField)
        
        passwordTextField.iconFont = UIFont(name: "FontAwesome", size: 12)
        passwordTextField.iconText = "\u{f084}"
        passwordTextField.iconColor = UIColor.lightGray
        passwordTextField.title = "Password"
        passwordTextField.titleFormatter = { $0 }
        passwordTextField.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        passwordTextField.iconMarginBottom = 1.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        passwordTextField.iconMarginLeft = 2.0
        self.view.addSubview(passwordTextField)
        
        reTypePasswordTextField.iconFont = UIFont(name: "FontAwesome", size: 12)
        reTypePasswordTextField.iconText = "\u{f084}"
        reTypePasswordTextField.iconColor = UIColor.lightGray
        reTypePasswordTextField.title = "Re-Type Password"
        reTypePasswordTextField.titleFormatter = { $0 }
        reTypePasswordTextField.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        reTypePasswordTextField.iconMarginBottom = 1.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        reTypePasswordTextField.iconMarginLeft = 2.0
        self.view.addSubview(reTypePasswordTextField)
        
        countriesTextField.iconFont = UIFont(name: "FontAwesome", size: 12)
        countriesTextField.iconText = "\u{f0ac}"
        countriesTextField.iconColor = UIColor.lightGray
        countriesTextField.title = "Country"
        countriesTextField.titleFormatter = { $0 }
        countriesTextField.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        countriesTextField.iconMarginBottom = 1.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        countriesTextField.iconMarginLeft = 2.0
        self.view.addSubview(countriesTextField)
        
        cityTextFIeld.iconFont = UIFont(name: "FontAwesome", size: 12)
        cityTextFIeld.iconText = "\u{f041}"
        cityTextFIeld.iconColor = UIColor.lightGray
        cityTextFIeld.title = "City"
        cityTextFIeld.titleFormatter = { $0 }
        cityTextFIeld.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        cityTextFIeld.iconMarginBottom = 1.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        cityTextFIeld.iconMarginLeft = 2.0
        self.view.addSubview(cityTextFIeld)
        
        stateTextFIeld.iconFont = UIFont(name: "FontAwesome", size: 12)
        stateTextFIeld.iconText = "\u{f041}"
        stateTextFIeld.iconColor = UIColor.lightGray
        stateTextFIeld.title = "State"
        stateTextFIeld.titleFormatter = { $0 }
        stateTextFIeld.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        stateTextFIeld.iconMarginBottom = 1.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        stateTextFIeld.iconMarginLeft = 2.0
        self.view.addSubview(stateTextFIeld)
        
        zipcodeTextField.iconFont = UIFont(name: "FontAwesome", size: 12)
        zipcodeTextField.iconText = "\u{f126}"
        zipcodeTextField.iconColor = UIColor.lightGray
        zipcodeTextField.title = "Zipcode"
        zipcodeTextField.titleFormatter = { $0 }
        zipcodeTextField.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        zipcodeTextField.iconMarginBottom = 1.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        zipcodeTextField.iconMarginLeft = 2.0
        self.view.addSubview(zipcodeTextField)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        print("Memory Issue on Register")

    }
    
    @objc func donePressed(_ sender: UIBarButtonItem) {
        
        let _ = countriesTextField.resignFirstResponder()
        
    }
    
    @objc func tappedToolBarBtn(_ sender: UIBarButtonItem) {
        
        countriesTextField.text = "United States"
        
        let _ = countriesTextField.resignFirstResponder()
    }
    
    @IBAction func registerBackButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        countriesTextField.text = countries[row]
       
    }
    
    @IBAction func registerBtn(_ sender: UIButton) {
        
           let _ = reTypePasswordTextField.resignFirstResponder()
        
           let isEmailAddressValid = isValidEmailAddress(emailAddressString: emailTextField.text!)
   
           if currentReachabilityStatus == .reachableViaWiFi ||  currentReachabilityStatus == .reachableViaWWAN{
            
            let _ = reTypePasswordTextField.resignFirstResponder()
            let _ = emailTextField.resignFirstResponder()
            
            if firstNameTextField.text == "" || lastNameTextField.text == "" || practiceNameTextField.text == "" || phoneTextField.text == "" || practiceAddressTextField.text == "" || emailTextField.text == "" || countriesTextField.text == "" || cityTextFIeld.text == "" || stateTextFIeld.text == "" || zipcodeTextField.text == "" || passwordTextField.text == "" || reTypePasswordTextField.text == ""{
                
                let alert = UIAlertController(title: "Notice", message: "Please fill all the fields", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil);
                
                return;
                
            } else if !isEmailAddressValid{
                
                let alert = UIAlertController(title: "Notice", message: "Please enter valid email address", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil);
                
            } else if (phoneTextField.text?.characters.count)! > 15 {
                
                let alert = UIAlertController(title: "Notice", message: "Phone Number should not be more then 15 numbers", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil);
                
            }  else if passwordTextField.text != reTypePasswordTextField.text {
                
                let alert = UIAlertController(title: "Notice", message: "Passwords not matched", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil);
                
            } else {
                
                let _ = reTypePasswordTextField.resignFirstResponder()
                let _ = emailTextField.resignFirstResponder()
                
                SwiftSpinner.show("Registering User Account")
                
                let url = URL(string: "http://muapp.com/medilixis_server/public/signup")!
                let jsonDict = ["email": emailTextField.text, "password": passwordTextField.text, "username": practiceNameTextField.text, "firstname": firstNameTextField.text, "lastname": lastNameTextField.text, "phone": phoneTextField.text, "address": practiceAddressTextField.text, "npi": npiTextField.text, "country": countriesTextField.text, "retypepassword": reTypePasswordTextField.text, "state": stateTextFIeld.text, "city": cityTextFIeld.text, "zipcode": zipcodeTextField.text]
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
                        DispatchQueue.main.async {
                            
                            let status = json["status"] as? String
                            
                            if (status == "success"){
                                
                                DispatchQueue.main.async {
                                    
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
                  
                                    
                                    self.firstNameTextField.text = ""
                                    self.lastNameTextField.text = ""
                                    self.practiceNameTextField.text = ""
                                    self.phoneTextField.text = ""
                                    self.practiceAddressTextField.text = ""
                                    self.emailTextField.text = ""
                                    self.npiTextField.text = ""
                                    self.passwordTextField.text = ""
                                    self.reTypePasswordTextField.text = ""
                                    self.countriesTextField.text = ""
                                    self.cityTextFIeld.text = ""
                                    self.stateTextFIeld.text = ""
                                    self.zipcodeTextField.text = ""
                                    
                                    SwiftSpinner.hide()
                                    
                                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
                                    self.present(nextViewController, animated:true, completion:nil)
                                    
                                    
                                }
                                
                            } else  if (status == "fail") {
                                
                                let response = json["error"] as! NSDictionary
                                let data = response["message"]! as! String
                               
                                SwiftSpinner.hide()
                                
                                let alert = UIAlertController(title: "Notice", message: data, preferredStyle: UIAlertControllerStyle.alert)
                                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                                alert.addAction(action)
                                
                                self.present(alert, animated: true, completion: nil);
                                
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
    
    
    @IBAction func cancel(_ sender: UIButton) {
        
        self.firstNameTextField.text = ""
        self.lastNameTextField.text = ""
        self.practiceNameTextField.text = ""
        self.phoneTextField.text = ""
        self.practiceAddressTextField.text = ""
        self.emailTextField.text = ""
        self.npiTextField.text = ""
        self.passwordTextField.text = ""
        self.reTypePasswordTextField.text = ""
        self.countriesTextField.text = ""
        self.cityTextFIeld.text = ""
        self.stateTextFIeld.text = ""
        self.zipcodeTextField.text = ""
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "selection") as! Selection
        self.present(nextViewController, animated:true, completion:nil)
        return
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
}



