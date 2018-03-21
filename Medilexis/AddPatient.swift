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
import AlamofireImage
import SVProgressHUD
import XLActionController

class AddPatient: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate  {
    
    @IBOutlet var firstName: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var lastName: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var phone: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var dob: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var email: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var address: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var patientProfileImage: UIImageView!
    @IBOutlet weak var patientIDImage: UIImageView!
    @IBOutlet var medicalNo: SkyFloatingLabelTextFieldWithIcon!
    
    let userDefaults = Foundation.UserDefaults.standard
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var filterFirstName = [String]()
    let picker = UIImagePickerController()
    var selectedImage:UIImage!
    var selectedIDImage:UIImage!
    var imagePicked: String!
    var profileImageName: String!
    var idImageName: String!
    var selectedImageBool = false
    var selectedIDImageBool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createProfileImagesFolder()
        createIDImagesFolder()
        
        selectedImage = UIImage(named: "thumb_image_not_available")
        selectedIDImage =  UIImage(named: "thumb_image_not_available")
        
        picker.delegate = self
        
        self.patientProfileImage.layer.cornerRadius = self.patientProfileImage!.frame.height/2
        self.patientProfileImage.clipsToBounds = true
        patientProfileImage.contentMode = UIViewContentMode.scaleAspectFill
        self.patientIDImage.layer.cornerRadius = self.patientIDImage!.frame.height/2
        self.patientIDImage.clipsToBounds = true
        patientIDImage.contentMode = UIViewContentMode.scaleAspectFill

        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AddPatient.imageTapped(gesture:)))
        patientProfileImage.addGestureRecognizer(tapGesture)
        patientProfileImage.isUserInteractionEnabled = true
        
        let tapGestureID = UITapGestureRecognizer(target: self, action: #selector(AddPatient.imageTappedID(gesture:)))
        patientIDImage.addGestureRecognizer(tapGestureID)
        patientIDImage.isUserInteractionEnabled = true

        medicalNo.iconFont = UIFont(name: "FontAwesome", size: 12)
        medicalNo.iconText = "\u{f292}"
        medicalNo.iconColor = UIColor.lightGray
        medicalNo.title = "MR#"
        medicalNo.titleFormatter = { $0 }
        medicalNo.titleLabel.font = UIFont(name: "FontAwesome", size:11)
        medicalNo.iconMarginBottom = 1.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        medicalNo.iconMarginLeft = 2.0
        
        firstName.iconFont = UIFont(name: "FontAwesome", size: 12)
        firstName.iconText = "\u{f2c0}"
        firstName.iconColor = UIColor.lightGray
        firstName.title = "First Name"
        firstName.titleFormatter = { $0 }
        firstName.titleLabel.font = UIFont(name: "FontAwesome", size:11)
        firstName.iconMarginBottom = 1.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        firstName.iconMarginLeft = 2.0
        //self.view.addSubview(firstName)
        
        lastName.iconFont = UIFont(name: "FontAwesome", size: 12)
        lastName.iconText = "\u{f2c0}"
        lastName.iconColor = UIColor.lightGray
        lastName.title = "Last Name"
        lastName.titleFormatter = { $0 }
        lastName.titleLabel.font = UIFont(name: "FontAwesome", size:11)
        lastName.iconMarginBottom = 1.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        lastName.iconMarginLeft = 2.0
       // self.view.addSubview(lastName)
        
        phone.iconFont = UIFont(name: "FontAwesome", size: 12)
        phone.iconText = "\u{f095}"
        phone.iconColor = UIColor.lightGray
        phone.title = "Phone No"
        phone.titleFormatter = { $0 }
        phone.titleLabel.font = UIFont(name: "FontAwesome", size:11)
        phone.iconMarginBottom = 1.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        phone.iconMarginLeft = 2.0
       // self.view.addSubview(lastName)
        
        dob.iconFont = UIFont(name: "FontAwesome", size: 12)
        dob.iconText = "\u{f274}"
        dob.iconColor = UIColor.lightGray
        dob.title = "DOB"
        dob.titleFormatter = { $0 }
        dob.titleLabel.font = UIFont(name: "FontAwesome", size:11)
        dob.iconMarginBottom = 1.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        dob.iconMarginLeft = 2.0
        //self.view.addSubview(dob)
        
        email.iconFont = UIFont(name: "FontAwesome", size: 12)
        email.iconText = "\u{f003}"
        email.iconColor = UIColor.lightGray
        email.title = "Email"
        email.titleFormatter = { $0 }
        email.titleLabel.font = UIFont(name: "FontAwesome", size:11)
        email.iconMarginBottom = 1.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        email.iconMarginLeft = 2.0
       // self.view.addSubview(email)
        
        address.iconFont = UIFont(name: "FontAwesome", size: 12)
        address.iconText = "\u{f041}"
        address.iconColor = UIColor.lightGray
        address.title = "Address"
        address.titleFormatter = { $0 }
        address.titleLabel.font = UIFont(name: "FontAwesome", size:11)
        address.iconMarginBottom = 1.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        address.iconMarginLeft = 2.0
       // self.view.addSubview(address)
        
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
        
        //Add done button to numeric pad keyboard
        let toolbarDone = UIToolbar.init()
        toolbarDone.sizeToFit()
        let flexibleSpaceDone = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        let barBtnDone = UIBarButtonItem.init(barButtonSystemItem: UIBarButtonSystemItem.done,
                                              target: self, action: #selector(AddPatient.doneButton_Clicked(_:)))
        toolbarDone.items = [flexibleSpaceDone, barBtnDone] // You can even add cancel button too
        phone.inputAccessoryView = toolbarDone
        
    }
    
    @objc func doneButton_Clicked(_ sender: UIBarButtonItem) {
        
        let _ = phone.resignFirstResponder()
        
    }
    
    @objc func imageTappedID(gesture: UIGestureRecognizer) {
        
        imagePicked = "ID"
        
        let actionController = YoutubeActionController()
        
        actionController.addAction(Action(ActionData(title: "Camera", image: UIImage(named: "camera")!), style: .default, handler: { action in
            
            self.CaptureCamera()
            
        }))
        actionController.addAction(Action(ActionData(title: "Photo Library", image: UIImage(named: "photolibrary")!), style: .default, handler: { action in
            
            self.CaptureLibrary()
        }))
        
        actionController.addAction(Action(ActionData(title: "Cancel", image: UIImage(named: "cancel")!), style: .default, handler: { action in
        }))
        
        present(actionController, animated: true, completion: nil)
        
    }
    
    func CaptureCamera(){
        
        if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
            self.picker.allowsEditing = false
            self.picker.sourceType = UIImagePickerControllerSourceType.camera
            self.picker.cameraCaptureMode = .photo
            present(self.picker, animated: true, completion: nil)
        } else {
            self.noCamera()
        }
    }
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(alertVC,
                animated: true,
                completion: nil)
    }
    
    func CaptureLibrary(){
        
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width:newWidth, height:newHeight))
        image.draw(in: CGRect(x:0, y:0, width:newWidth, height:newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any])
    {
 
        if imagePicked == "Profile" {
            
            selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            patientProfileImage.image = resizeImage(image: selectedImage, newWidth: 200)
            selectedImageBool = true
            dismiss(animated: true, completion: nil)//5
            
            
        } else {
            
            selectedIDImage = info[UIImagePickerControllerOriginalImage] as? UIImage
            patientIDImage.image = resizeImage(image: selectedIDImage, newWidth: 200)
            selectedIDImageBool = true
            dismiss(animated: true, completion: nil)//5
        }
   
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        
        imagePicked = "Profile"
        
        let actionController = YoutubeActionController()
        
        actionController.addAction(Action(ActionData(title: "Camera", image: UIImage(named: "camera")!), style: .default, handler: { action in
            
            self.CaptureCamera()
            
        }))
        actionController.addAction(Action(ActionData(title: "Photo Library", image: UIImage(named: "photolibrary")!), style: .default, handler: { action in
            
            self.CaptureLibrary()
        }))
        
        actionController.addAction(Action(ActionData(title: "Cancel", image: UIImage(named: "cancel")!), style: .default, handler: { action in
        }))
        
        present(actionController, animated: true, completion: nil)
        
    }
 
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        print("Memory issue on Add patient")
    }
    
    @objc func selectDoneDateButton(_ sender: UIBarButtonItem) {
        
        let _ = dob.resignFirstResponder()
        
    }
    
    @objc func selectTodayBtn(_ sender: UIBarButtonItem) {
        
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
    
    @objc func datePickerDateValueChanged(sender:UIDatePicker) {
        
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
         
            SVProgressHUD.show()
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
                    
                    if selectedImageBool == true {
                        
                        let currentDateTime = NSDate()
                        let formatter = DateFormatter()
                        formatter.dateFormat = "dd-MM-yyyy-HH:mm:ss"
                        let file = formatter.string(from: currentDateTime as Date)
                        profileImageName = file + ".png"
                        saveImageToDocuments(image: resizeImage(image: selectedImage, newWidth: 200), fileNameWithExtension: profileImageName)
                        
                    } else {
                        profileImageName = "N/A"
                    }
                    
                    if selectedIDImageBool == true {
                        
                        let currentDateTime = NSDate()
                        let formatter = DateFormatter()
                        formatter.dateFormat = "dd-MM-yyyy-HH:mm:ss"
                        let file = formatter.string(from: currentDateTime as Date)
                        idImageName = file + ".png"
                        saveIDImageToDocuments(image: resizeImage(image: selectedIDImage, newWidth: 200), fileNameWithExtension: idImageName)
                        
                    } else {
                        idImageName = "N/A"
                    }
                    
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
                    managedObj.setValue(profileImageName, forKey: "profileImage")
                    managedObj.setValue(idImageName, forKey: "idCardImage")
                    managedObj.setValue(medicalNo.text, forKey: "medicalNo")
                    
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
                
                if selectedImageBool == true {
                    
                    let currentDateTime = NSDate()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd-MM-yyyy-HH:mm:ss"
                    let file = formatter.string(from: currentDateTime as Date)
                    profileImageName = file + ".png"
                    saveImageToDocuments(image: resizeImage(image: selectedImage, newWidth: 200), fileNameWithExtension: profileImageName)
                    
                } else {
                  profileImageName = "N/A"
                }
                
                if selectedIDImageBool == true {
                    
                    let currentDateTime = NSDate()
                    let formatter = DateFormatter()
                    formatter.dateFormat = "dd-MM-yyyy-HH:mm:ss"
                    let file = formatter.string(from: currentDateTime as Date)
                    idImageName = file + ".png"
                    saveIDImageToDocuments(image: resizeImage(image: selectedIDImage, newWidth: 200), fileNameWithExtension: idImageName)
                    
                } else {
                    idImageName = "N/A"
                }
                
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
                managedObj.setValue(profileImageName, forKey: "profileImage")
                managedObj.setValue(idImageName, forKey: "idCardImage")
                managedObj.setValue(medicalNo.text, forKey: "medicalNo")
                
                do {
                    try context.save()
                    print("saved")
                    
                   // addPatientsOnServer()
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "WalkInPatients") as! NewAppointment
                    nextViewController.firstname = firstName.text
                    nextViewController.lastname = lastName.text
                    nextViewController.phone = phone.text
                    nextViewController.dob = dob.text
                    nextViewController.email = email.text
                    nextViewController.address = address.text
                    nextViewController.profile = profileImageName
                    nextViewController.idCard = idImageName
                    nextViewController.medicalno = medicalNo.text
                    userDefaults.set("Add Patients", forKey: "View")
                    self.present(nextViewController, animated:true, completion:nil)
                    
                    SVProgressHUD.dismiss()
                    
                /*    self.firstName.text = ""
                    self.lastName.text = ""
                    self.phone.text = ""
                    self.address.text = ""
                    self.dob.text = ""
                    self.email.text = ""
                    self.medicalNo.text = ""
                    self.patientProfileImage.image = UIImage(named: "thumb_image_not_available")
                    self.patientIDImage.image = UIImage(named: "thumb_image_not_available")*/
                    
                    
                } catch {
                    print(error.localizedDescription)
                }
                
                
            }
        }catch {
            print(error.localizedDescription)
        }
        
    }
    
    func saveImageToDocuments(image: UIImage, fileNameWithExtension: String){
        
        let fileManager = FileManager.default
        //get the image path
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("ProfileImages/" + fileNameWithExtension)
        //get the image we took with camera
        //get the PNG data for this image
        let data = UIImagePNGRepresentation(image)
        //store it in the document directory
        fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
        
    }
    
    func saveIDImageToDocuments(image: UIImage, fileNameWithExtension: String){
        
        let fileManager = FileManager.default
        //get the image path
        let imagePath = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("IDCardImages/" + fileNameWithExtension)
        //get the image we took with camera
        //get the PNG data for this image
        let data = UIImagePNGRepresentation(image)
        //store it in the document directory
        fileManager.createFile(atPath: imagePath as String, contents: data, attributes: nil)
        
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
                    
                    if selectedImageBool == true {
                        
                        let currentDateTime = NSDate()
                        let formatter = DateFormatter()
                        formatter.dateFormat = "dd-MM-yyyy-HH:mm:ss"
                        let file = formatter.string(from: currentDateTime as Date)
                        profileImageName = file + ".png"
                        saveImageToDocuments(image: resizeImage(image: selectedImage, newWidth: 200), fileNameWithExtension: profileImageName)
                        
                    } else {
                        profileImageName = "N/A"
                    }
                    
                    if selectedIDImageBool == true {
                        
                        let currentDateTime = NSDate()
                        let formatter = DateFormatter()
                        formatter.dateFormat = "dd-MM-yyyy-HH:mm:ss"
                        let file = formatter.string(from: currentDateTime as Date)
                        idImageName = file + ".png"
                        saveIDImageToDocuments(image: resizeImage(image: selectedIDImage, newWidth: 200), fileNameWithExtension: idImageName)
                        
                    } else {
                        idImageName = "N/A"
                    }
                    
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
                    managedObj.setValue(profileImageName, forKey: "profileImage")
                    managedObj.setValue(idImageName, forKey: "idCardImage")
                    managedObj.setValue(medicalNo.text, forKey: "medicalNo")
                    
                    do {
                        try context.save()
                        
                        self.firstName.text = ""
                        self.lastName.text = ""
                        self.phone.text = ""
                        self.address.text = ""
                        self.dob.text = ""
                        self.email.text = ""
                        self.medicalNo.text = ""
                        self.selectedImageBool = false
                        self.selectedIDImageBool = false
                        self.patientProfileImage.image = UIImage(named: "thumb_image_not_available")
                        self.patientIDImage.image = UIImage(named: "thumb_image_not_available")
                        
                       // addPatientsOnServer()
                        
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
    
    func createProfileImagesFolder() {
        // path to documents directory
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        if let documentDirectoryPath = documentDirectoryPath {
            // create the custom folder path
            let imagesDirectoryPath = documentDirectoryPath.appending("/ProfileImages")
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: imagesDirectoryPath) {
                do {
                    try fileManager.createDirectory(atPath: imagesDirectoryPath,
                                                    withIntermediateDirectories: false,
                                                    attributes: nil)
                } catch {
                    print("Error creating images folder in documents dir: \(error)")
                }
            }
        }
    }
    
    func createIDImagesFolder() {
        // path to documents directory
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
        if let documentDirectoryPath = documentDirectoryPath {
            // create the custom folder path
            let imagesDirectoryPath = documentDirectoryPath.appending("/IDCardImages")
            let fileManager = FileManager.default
            if !fileManager.fileExists(atPath: imagesDirectoryPath) {
                do {
                    try fileManager.createDirectory(atPath: imagesDirectoryPath,
                                                    withIntermediateDirectories: false,
                                                    attributes: nil)
                } catch {
                    print("Error creating images folder in documents dir: \(error)")
                }
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func addPatientsOnServer(){
        
        let doctorID = userDefaults.value(forKey: "UserID")
        let doctorName = userDefaults.value(forKey: "Username")
        let token = userDefaults.value(forKey: "Token")
        
        
        let url = URL(string: "http://muapp.com/medilixis_server/public/addapppatient")!
        
        let jsonDict = ["username": firstName.text, "last_name": lastName.text, "phone_number": phone.text, "dob": dob.text, "address": address.text, "email": email.text, "doctor_id": doctorID, "doctor_name": doctorName, "token": token]
        let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict, options: [])
        
        var request = URLRequest(url: url)
        request.httpMethod = "post"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                print("error:", error)
                
            }
            
            do {
                guard let data = data else { return }
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else { return }
                print(json)
                
            } catch {
                print("error:", error)
                
            }
        }
        
        task.resume()
    }
    
}
