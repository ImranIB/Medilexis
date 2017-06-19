//
//  EditProfile.swift
//  Medilexis
//
//  Created by iOS Developer on 28/02/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import SwiftSpinner

class EditProfile: UIViewController, UIPickerViewDelegate {
    
    
    @IBOutlet weak var firstNameTextField: SkyFloatingLabelTextFieldWithIcon!

    @IBOutlet weak var lastNameTextField: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var practiceNameTextField: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var practiceAddressTextField: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var cityTextFIeld: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var stateTextFIeld: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var codeTextField: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var phoneTextField: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var npiTextField: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var countryTextField: SkyFloatingLabelTextFieldWithIcon!
    
    @IBOutlet weak var emailTextField: SkyFloatingLabelTextFieldWithIcon!
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    
    var countries: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        for code in NSLocale.isoCountryCodes as [String] {
            let id = NSLocale.localeIdentifier(fromComponents: [NSLocale.Key.countryCode.rawValue: code])
            let name = NSLocale(localeIdentifier: "en_US").displayName(forKey: NSLocale.Key.identifier, value: id) ?? "Country not found for code: \(code)"
            countries.append(name)
        }
        
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        
        countryTextField.inputView = pickerView
        
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
        
        countryTextField.inputAccessoryView = toolBar
        
        firstNameTextField.iconFont = UIFont(name: "FontAwesome", size: 12)
        firstNameTextField.iconText = "\u{f2c0}"
        firstNameTextField.iconColor = UIColor.lightGray
        firstNameTextField.title = "First Name"
        firstNameTextField.titleFormatter = { $0 }
        firstNameTextField.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
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
        practiceAddressTextField.titleFormatter = { $0 }
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
        
        codeTextField.iconFont = UIFont(name: "FontAwesome", size: 12)
        codeTextField.iconText = "\u{f126}"
        codeTextField.iconColor = UIColor.lightGray
        codeTextField.title = "Zipcode"
        codeTextField.titleFormatter = { $0 }
        codeTextField.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        codeTextField.iconMarginBottom = 1.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        codeTextField.iconMarginLeft = 2.0
        self.view.addSubview(codeTextField)
        
        phoneTextField.iconFont = UIFont(name: "FontAwesome", size: 12)
        phoneTextField.iconText = "\u{f095}"
        phoneTextField.iconColor = UIColor.lightGray
        phoneTextField.title = "Phone"
        phoneTextField.titleFormatter = { $0 }
        phoneTextField.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
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
        
        countryTextField.iconFont = UIFont(name: "FontAwesome", size: 12)
        countryTextField.iconText = "\u{f0ac}"
        countryTextField.iconColor = UIColor.lightGray
        countryTextField.title = "Country"
        countryTextField.titleFormatter = { $0 }
        countryTextField.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        countryTextField.iconMarginBottom = 1.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        countryTextField.iconMarginLeft = 2.0
        self.view.addSubview(countryTextField)
        
         emailTextField.isEnabled = false
        
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

    @IBAction func dismissEditProfile(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func donePressed(_ sender: UIBarButtonItem) {
    
    let _ = countryTextField.resignFirstResponder()
    
    }
    
    func tappedToolBarBtn(_ sender: UIBarButtonItem) {
        
        countryTextField.text = "United States"
        
        let _ = countryTextField.resignFirstResponder()
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
        countryTextField.text = countries[row]
        
    }

    
    @IBAction func navigateToHome(_ sender: UIBarButtonItem) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        emailTextField.isEnabled = false
        
        let defaults = UserDefaults.standard
        
        let address = defaults.value(forKey: "Address")
        let city = defaults.value(forKey: "City")
        let country = defaults.value(forKey: "Country")
        let firstname = defaults.value(forKey: "FirstName")
        let lastname = defaults.value(forKey: "LastName")
        let npi = defaults.value(forKey: "Npi")
        let phone = defaults.value(forKey: "Phone")
        let state = defaults.value(forKey: "State")
        let zipcode = defaults.value(forKey: "Zipcode")
        let username = defaults.value(forKey: "Username")
        let email = defaults.value(forKey: "Email")
       
        practiceAddressTextField.text = address as! String?
        cityTextFIeld.text = city as! String?
        countryTextField.text = country as! String?
        firstNameTextField.text = firstname as! String?
        lastNameTextField.text = lastname as! String?
        npiTextField.text = npi as! String?
        phoneTextField.text = phone as! String?
        stateTextFIeld.text = state as! String?
        codeTextField.text = zipcode as! String?
        practiceNameTextField.text = username as! String?
        emailTextField.text = email as! String? 
    }
    
    @IBAction func update(_ sender: UIButton) {
        
        let defaults = UserDefaults.standard
        let _ = countryTextField.resignFirstResponder()
        let token = defaults.value(forKey: "Token")
        
        if currentReachabilityStatus == .reachableViaWiFi ||  currentReachabilityStatus == .reachableViaWWAN {
            
            if firstNameTextField.text == "" || lastNameTextField.text == "" || practiceNameTextField.text == "" || phoneTextField.text == "" || practiceAddressTextField.text == "" || countryTextField.text == "" || cityTextFIeld.text == "" || stateTextFIeld.text == "" || codeTextField.text == "" {
                
                let alert = UIAlertController(title: "Notice", message: "Please fill all the fields", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil);
                
                return
                
            } else if (phoneTextField.text?.characters.count)! > 15 {
                
                let alert = UIAlertController(title: "Notice", message: "Phone Number should not be more then 15 numbers ", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil);
                
            } else {
                
                
                let _ = firstNameTextField.resignFirstResponder()
                let _ = lastNameTextField.resignFirstResponder()
                let _ =  practiceNameTextField.resignFirstResponder()
                let _ = phoneTextField.resignFirstResponder()
                let _ = practiceAddressTextField.resignFirstResponder()
                let _ = countryTextField.resignFirstResponder()
                let _ = cityTextFIeld.resignFirstResponder()
                let _ = stateTextFIeld.resignFirstResponder()
                let _ = codeTextField.resignFirstResponder()
                let _ = npiTextField.resignFirstResponder()
                
                
                SwiftSpinner.show("Updating User Profile")
                
                let url = URL(string: "http://muapp.com/medilixis_server/public/update")!
                let jsonDict = ["username": practiceNameTextField.text, "firstname": firstNameTextField.text, "lastname": lastNameTextField.text, "phone": phoneTextField.text, "address": practiceAddressTextField.text, "npi": npiTextField.text, "country": countryTextField.text, "state": stateTextFIeld.text, "city": cityTextFIeld.text, "zipcode": codeTextField.text, "token": token]
                let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict, options: [])
                
                var request = URLRequest(url: url)
                request.httpMethod = "post"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = jsonData
                
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        print("error:", error)
                        SwiftSpinner.hide()
                        return
                    }
                    
                    do {
                        guard let data = data else { return }
                        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else { return }
                        print("json:", json)
                        
                        DispatchQueue.main.async {
                            
                            SwiftSpinner.hide()
                            
                            let status = json["user_detail"] as! NSDictionary
                            let userdata = json["userdata"] as! NSDictionary
                            
                            defaults.set(status["address"]!, forKey: "Address")
                            defaults.set(status["city"]!, forKey: "City")
                            defaults.set(status["country"]!, forKey: "Country")
                            defaults.set(status["firstname"]!, forKey: "FirstName")
                            defaults.set(status["lastname"]!, forKey: "LastName")
                            defaults.set(status["npi"]!, forKey: "Npi")
                            defaults.set(status["phone"]!, forKey: "Phone")
                            defaults.set(status["state"]!, forKey: "State")
                            defaults.set(status["zipcode"]!, forKey: "Zipcode")
                            defaults.set(userdata["username"]!, forKey: "Username")
                            
                            let alert = UIAlertController(title: "Success", message: "Profile successfully updated.", preferredStyle: UIAlertControllerStyle.alert)
                            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                            alert.addAction(action)
                            
                            self.present(alert, animated: true, completion: nil);
                            
                            return
                            
                            
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
    

}
