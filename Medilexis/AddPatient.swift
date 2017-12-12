//
//  AddPatient.swift
//  Medilexis
//
//  Created by iOS Developer on 07/07/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit
import CoreData
import SkyFloatingLabelTextField
import SwiftSpinner

class AddPatient: UIViewController {
    
   
    @IBOutlet var firstName: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var lastName: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var phone: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var dob: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var email: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var address: SkyFloatingLabelTextFieldWithIcon!
    
    let userDefaults = Foundation.UserDefaults.standard
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var filterFirstName = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

       firstName.iconFont = UIFont(name: "FontAwesome", size: 12)
        firstName.iconText = "\u{f2c0}"
        firstName.iconColor = UIColor.lightGray
        firstName.title = "First Name"
        firstName.titleFormatter = { $0 }
        firstName.titleLabel.font = UIFont(name: "FontAwesome", size:11)
        firstName.iconMarginBottom = 1.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        firstName.iconMarginLeft = 2.0
        self.view.addSubview(firstName)
        
        lastName.iconFont = UIFont(name: "FontAwesome", size: 12)
        lastName.iconText = "\u{f2c0}"
        lastName.iconColor = UIColor.lightGray
        lastName.title = "Last Name"
        lastName.titleFormatter = { $0 }
        lastName.titleLabel.font = UIFont(name: "FontAwesome", size:11)
        lastName.iconMarginBottom = 1.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        lastName.iconMarginLeft = 2.0
        self.view.addSubview(lastName)
        
        phone.iconFont = UIFont(name: "FontAwesome", size: 12)
        phone.iconText = "\u{f095}"
        phone.iconColor = UIColor.lightGray
        phone.title = "Phone No"
        phone.titleFormatter = { $0 }
        phone.titleLabel.font = UIFont(name: "FontAwesome", size:11)
        phone.iconMarginBottom = 1.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        phone.iconMarginLeft = 2.0
        self.view.addSubview(lastName)
        
        dob.iconFont = UIFont(name: "FontAwesome", size: 12)
        dob.iconText = "\u{f274}"
        dob.iconColor = UIColor.lightGray
        dob.title = "DOB"
        dob.titleFormatter = { $0 }
        dob.titleLabel.font = UIFont(name: "FontAwesome", size:11)
        dob.iconMarginBottom = 1.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        dob.iconMarginLeft = 2.0
        self.view.addSubview(dob)
        
        email.iconFont = UIFont(name: "FontAwesome", size: 12)
        email.iconText = "\u{f003}"
        email.iconColor = UIColor.lightGray
        email.title = "Email"
        email.titleFormatter = { $0 }
        email.titleLabel.font = UIFont(name: "FontAwesome", size:11)
        email.iconMarginBottom = 1.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        email.iconMarginLeft = 2.0
        self.view.addSubview(email)
        
        address.iconFont = UIFont(name: "FontAwesome", size: 12)
        address.iconText = "\u{f041}"
        address.iconColor = UIColor.lightGray
        address.title = "Address"
        address.titleFormatter = { $0 }
        address.titleLabel.font = UIFont(name: "FontAwesome", size:11)
        address.iconMarginBottom = 1.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        address.iconMarginLeft = 2.0
        self.view.addSubview(address)
        
        let toolBar1 = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        
        toolBar1.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar1.barStyle = UIBarStyle.blackTranslucent
        
        toolBar1.tintColor = UIColor.white
        
        toolBar1.backgroundColor = UIColor.black
        
        let defaultButton1 = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.plain, target: self, action: #selector(AddPatient.selectTodayBtn))
        
        let doneButton1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(AddPatient.selectDoneDateButton))
        
        let flexSpace1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let label1 = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label1.font = UIFont(name: "FontAwesome", size: 16)
        
        label1.backgroundColor = UIColor.clear
        
        label1.textColor = UIColor.white
        
        label1.text = "Birth Date"
        
        label1.textAlignment = NSTextAlignment.center
        
        let textBtn1 = UIBarButtonItem(customView: label1)
        
        toolBar1.setItems([defaultButton1,flexSpace1,textBtn1,flexSpace1,doneButton1], animated: true)
        
        dob.inputAccessoryView = toolBar1
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func selectDoneDateButton(_ sender: UIBarButtonItem) {
        
        let _ = dob.resignFirstResponder()
        
    }
    
    func selectTodayBtn(_ sender: UIBarButtonItem) {
        
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "dd MMMM yyyy"
        let date = NSDate()
        let stringOfDate = dateFormate.string(from: date as Date)
        dob.text = stringOfDate
        
        let _ = dob.resignFirstResponder()
    }
    
    @IBAction func dateBirthTextFieldBeginEditing(_ sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datePickerView
        
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "dd MMMM yyyy"
        let date = NSDate()
        let todayDate = dateWithOutTime(datDate: date)
        let stringOfDate = dateFormate.string(from: todayDate as Date)
        dob.text = stringOfDate
        
        datePickerView.addTarget(self, action: #selector(AddPatient.datePickerDateValueChanged), for: UIControlEvents.valueChanged)
    }
    
    func datePickerDateValueChanged(sender:UIDatePicker) {
        
        let date = NSDate()
        let dateFormatter = DateFormatter()
        let todayDate = dateWithOutTime(datDate: date)
        
        dateFormatter.dateFormat = "dd MMMM yyyy"
        
        let birthDate = dateWithOutTime(datDate: sender.date as NSDate!)
        
        switch birthDate.compare(todayDate as Date) {
        case .orderedAscending     :   print("Date A is earlier than date B")
        case .orderedDescending    :   print("Date A is later than date B")
        case .orderedSame          :   print("The two dates are the same")
        }
        
        if birthDate.compare(todayDate as Date) == .orderedDescending {
            
            let alert = UIAlertController(title: "Notice", message: "Date of birth should not be selected after today's date", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil);
            
            let _ = dob.resignFirstResponder()
            
        } else {
            
            dob.text = dateFormatter.string(from: sender.date)
        }
        
    }
    
    @IBAction func saveNext(_ sender: UIButton) {
        
        let isEmailAddressValid = isValidEmailAddress(emailAddressString: email.text!)
         
         if firstName.text == "" {
         
         let alert = UIAlertController(title: "Notice", message: "Enter first name", preferredStyle: UIAlertControllerStyle.alert)
         let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
         alert.addAction(action)
         
         self.present(alert, animated: true, completion: nil);
         
         } else  if lastName.text == "" {
         
         let alert = UIAlertController(title: "Notice", message: "Enter last name", preferredStyle: UIAlertControllerStyle.alert)
         let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
         alert.addAction(action)
         
         self.present(alert, animated: true, completion: nil);
         
         } else  if phone.text == "" {
         
         let alert = UIAlertController(title: "Notice", message: "Enter phone number", preferredStyle: UIAlertControllerStyle.alert)
         let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
         alert.addAction(action)
         
         self.present(alert, animated: true, completion: nil);
         
         } else  if dob.text == "" {
         
         let alert = UIAlertController(title: "Notice", message: "Enter birth date", preferredStyle: UIAlertControllerStyle.alert)
         let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
         alert.addAction(action)
         
         self.present(alert, animated: true, completion: nil);
         
         } else if email.text != "" && !isEmailAddressValid {
         
         let alert = UIAlertController(title: "Notice", message: "Please enter valid email address", preferredStyle: UIAlertControllerStyle.alert)
         let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
         alert.addAction(action)
         
         self.present(alert, animated: true, completion: nil);
         
         } else if (phone.text?.characters.count)! > 15 {
         
         let alert = UIAlertController(title: "Notice", message: "Phone Number should not be more then 15 numbers", preferredStyle: UIAlertControllerStyle.alert)
         let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
         alert.addAction(action)
         
         self.present(alert, animated: true, completion: nil);
         
         } else {
         
            checkPatientExists()
         }
            
    
    }
    
    @IBAction func saveExit(_ sender: UIButton) {
        
        let isEmailAddressValid = isValidEmailAddress(emailAddressString: email.text!)
        
        if firstName.text == "" {
            
            let alert = UIAlertController(title: "Notice", message: "Enter first name", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil);
            
        } else  if lastName.text == "" {
            
            let alert = UIAlertController(title: "Notice", message: "Enter last name", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil);
            
        } else  if phone.text == "" {
            
            let alert = UIAlertController(title: "Notice", message: "Enter phone number", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil);
            
        } else  if dob.text == "" {
            
            let alert = UIAlertController(title: "Notice", message: "Enter birth date", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil);
            
        } else if email.text != "" && !isEmailAddressValid {
            
            let alert = UIAlertController(title: "Notice", message: "Please enter valid email address", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil);
            
        } else if (phone.text?.characters.count)! > 15 {
            
            let alert = UIAlertController(title: "Notice", message: "Phone Number should not be more then 15 numbers", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil);
            
        } else {
            
            let uid = userDefaults.value(forKey: "UserID")
            let fetchRequest:NSFetchRequest<Patients> = Patients.fetchRequest()
            let predicate = NSPredicate(format: "(userID = %@) AND (firstName = %@) AND (lastName = %@) AND (phone = %@) AND (dateBirth = %@)", uid as! CVarArg, firstName.text!, lastName.text!, phone.text!, dob.text!)
            fetchRequest.predicate = predicate
            
            do {
                let count = try getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
                
                if count > 0 {
                    
                    let alert = UIAlertController(title: "Notice", message: "Patient already exists", preferredStyle: UIAlertControllerStyle.alert)
                    let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                    alert.addAction(action)
                    
                    self.present(alert, animated: true, completion: nil);
                    
                } else {
                    
                    let userID = userDefaults.value(forKey: "UserID") as! Int32
                    let patientid = NSUUID().uuidString.lowercased() as String
                    
                    
                    let context = getContext()
                    
                    let entity = NSEntityDescription.entity(forEntityName: "Patients", in: context)
                    
                    let managedObj = NSManagedObject(entity: entity!, insertInto: context)
                    
                    managedObj.setValue(firstName.text, forKey: "firstName")
                    managedObj.setValue(lastName.text, forKey: "lastName")
                    managedObj.setValue(phone.text, forKey: "phone")
                    managedObj.setValue(dob.text, forKey: "dateBirth")
                    managedObj.setValue(email.text, forKey: "email")
                    managedObj.setValue(address.text, forKey: "address")
                    managedObj.setValue(patientid, forKey: "id")
                    managedObj.setValue(userID, forKey: "userID")
                    
                    do {
                        try context.save()
                        
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
                        self.present(nextViewController, animated:true, completion:nil)
                        
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                    
                }
            }catch {
                print(error.localizedDescription)
            }

        }
    }
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func checkPatientExists(){
        
        let uid = userDefaults.value(forKey: "UserID")
        let fetchRequest:NSFetchRequest<Patients> = Patients.fetchRequest()
        let predicate = NSPredicate(format: "(userID = %@) AND (firstName = %@) AND (lastName = %@) AND (phone = %@) AND (dateBirth = %@)", uid as! CVarArg, firstName.text!, lastName.text!, phone.text!, dob.text!)
        fetchRequest.predicate = predicate
        
        do {
            let count = try getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            if count > 0 {
                
                let alert = UIAlertController(title: "Notice", message: "Patient already exists", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil);
                
            } else {
                
                let userID = userDefaults.value(forKey: "UserID") as! Int32
                let patientid = NSUUID().uuidString.lowercased() as String
       
                
                let context = getContext()
                
                let entity = NSEntityDescription.entity(forEntityName: "Patients", in: context)
                
                let managedObj = NSManagedObject(entity: entity!, insertInto: context)
                
                managedObj.setValue(firstName.text, forKey: "firstName")
                managedObj.setValue(lastName.text, forKey: "lastName")
                managedObj.setValue(phone.text, forKey: "phone")
                managedObj.setValue(dob.text, forKey: "dateBirth")
                managedObj.setValue(email.text, forKey: "email")
                managedObj.setValue(address.text, forKey: "address")
                managedObj.setValue(patientid, forKey: "id")
                managedObj.setValue(userID, forKey: "userID")
                
                do {
                    try context.save()
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "WalkInPatients") as! NewAppointment
                    nextViewController.firstname = firstName.text
                    nextViewController.lastname = lastName.text
                    nextViewController.phone = phone.text
                    nextViewController.dob = dob.text
                    nextViewController.email = email.text
                    nextViewController.address = address.text
                    self.present(nextViewController, animated:true, completion:nil)
                    
                    
                } catch {
                    print(error.localizedDescription)
                }
                
                
            }
        }catch {
            print(error.localizedDescription)
        }
        
    }
    
    @IBAction func saveAddNewPressed(_ sender: UIButton) {
        
        let isEmailAddressValid = isValidEmailAddress(emailAddressString: email.text!)
        
        if firstName.text == "" {
            
            let alert = UIAlertController(title: "Notice", message: "Enter first name", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil);
            
        } else  if lastName.text == "" {
            
            let alert = UIAlertController(title: "Notice", message: "Enter last name", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil);
            
        } else  if phone.text == "" {
            
            let alert = UIAlertController(title: "Notice", message: "Enter phone number", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil);
            
        } else  if dob.text == "" {
            
            let alert = UIAlertController(title: "Notice", message: "Enter birth date", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil);
            
        } else if email.text != "" && !isEmailAddressValid {
            
            let alert = UIAlertController(title: "Notice", message: "Please enter valid email address", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil);
            
        } else if (phone.text?.characters.count)! > 15 {
            
            let alert = UIAlertController(title: "Notice", message: "Phone Number should not be more then 15 numbers", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil);
            
        } else {
            
            let uid = userDefaults.value(forKey: "UserID")
            let fetchRequest:NSFetchRequest<Patients> = Patients.fetchRequest()
            let predicate = NSPredicate(format: "(userID = %@) AND (firstName = %@) AND (lastName = %@) AND (phone = %@) AND (dateBirth = %@)", uid as! CVarArg, firstName.text!, lastName.text!, phone.text!, dob.text!)
            fetchRequest.predicate = predicate
            
            do {
                let count = try getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
                
                if count > 0 {
                    
                    let alert = UIAlertController(title: "Notice", message: "Patient already exists", preferredStyle: UIAlertControllerStyle.alert)
                    let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                    alert.addAction(action)
                    
                    self.present(alert, animated: true, completion: nil);
                    
                } else {
                    
                    let userID = userDefaults.value(forKey: "UserID") as! Int32
                    let patientid = NSUUID().uuidString.lowercased() as String
                    
                    
                    let context = getContext()
                    
                    let entity = NSEntityDescription.entity(forEntityName: "Patients", in: context)
                    
                    let managedObj = NSManagedObject(entity: entity!, insertInto: context)
                    
                    managedObj.setValue(firstName.text, forKey: "firstName")
                    managedObj.setValue(lastName.text, forKey: "lastName")
                    managedObj.setValue(phone.text, forKey: "phone")
                    managedObj.setValue(dob.text, forKey: "dateBirth")
                    managedObj.setValue(email.text, forKey: "email")
                    managedObj.setValue(address.text, forKey: "address")
                    managedObj.setValue(patientid, forKey: "id")
                    managedObj.setValue(userID, forKey: "userID")
                    
                    do {
                        try context.save()
                        
                        self.firstName.text = ""
                        self.lastName.text = ""
                        self.phone.text = ""
                        self.address.text = ""
                        self.dob.text = ""
                        self.email.text = ""
                        
                        let alert = UIAlertController(title: "Success", message: "Patient added successfully", preferredStyle: UIAlertControllerStyle.alert)
                        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                        alert.addAction(action)
                        self.present(alert, animated: true, completion: nil);
                   
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                    
                }
            }catch {
                print(error.localizedDescription)
            }
            
        }
    }
    
    
    func dateWithOutTime( datDate: NSDate) -> NSDate {
        let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
        calendar.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone
        return calendar.startOfDay(for: datDate as Date) as (Date) as NSDate
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
    
    func getContext () -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    @IBAction func navigateToHome(_ sender: UIBarButtonItem) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    

    
}
