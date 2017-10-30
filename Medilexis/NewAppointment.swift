//
//  WalkInVC.swift
//
//
//  Created by iOS Developer on 20/02/2017.
//
//

import UIKit
import SkyFloatingLabelTextField
import XLActionController
import CoreData

class NewAppointment: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var pickerTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var patientNameTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var dateTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var scheduledDateWalkinPatient: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var lastNameTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var phoneTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var emailTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var addressTextFIeld: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet var appointmentTimeTextField: SkyFloatingLabelTextFieldWithIcon!
    
    
    
    var pickOption = ["New Patient", "Follow-up"]
    let defaults = UserDefaults.standard
    var scheduledPickDate: NSDate!
    var outputTitle = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        
        pickerTextField.inputView = pickerView
        
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar.barStyle = UIBarStyle.blackTranslucent
        
        toolBar.tintColor = UIColor.white
        
        toolBar.backgroundColor = UIColor.black
        
        
        let defaultButton = UIBarButtonItem(title: "Default", style: UIBarButtonItemStyle.plain, target: self, action: #selector(NewAppointment.tappedToolBarVisitBtn))
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(NewAppointment.doneVisitBtnPressed))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label.font = UIFont(name: "FontAwesome", size: 16)
        
        label.backgroundColor = UIColor.clear
        
        label.textColor = UIColor.white
        
        label.text = "Visit Type"
        
        label.textAlignment = NSTextAlignment.center
        
        let textBtn = UIBarButtonItem(customView: label)
        
        toolBar.setItems([defaultButton,flexSpace,textBtn,flexSpace,doneButton], animated: true)
        
        pickerTextField.inputAccessoryView = toolBar
        
        
        let toolBar1 = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        
        toolBar1.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar1.barStyle = UIBarStyle.blackTranslucent
        
        toolBar1.tintColor = UIColor.white
        
        toolBar1.backgroundColor = UIColor.black
        
        
        let defaultButton1 = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.plain, target: self, action: #selector(NewAppointment.selectDefaultBtn))
        
        let doneButton1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(NewAppointment.selectDoneDateButton))
        
        let flexSpace1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let label1 = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label1.font = UIFont(name: "FontAwesome", size: 16)
        
        label1.backgroundColor = UIColor.clear
        
        label1.textColor = UIColor.white
        
        label1.text = "Birth Date"
        
        label1.textAlignment = NSTextAlignment.center
        
        let textBtn1 = UIBarButtonItem(customView: label1)
        
        toolBar1.setItems([defaultButton1,flexSpace1,textBtn1,flexSpace1,doneButton1], animated: true)
        
        dateTextField.inputAccessoryView = toolBar1
        
        
        let toolBar2 = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        
        toolBar2.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar2.barStyle = UIBarStyle.blackTranslucent
        
        toolBar2.tintColor = UIColor.white
        
        toolBar2.backgroundColor = UIColor.black
        
        
        let defaultButton2 = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.plain, target: self, action: #selector(NewAppointment.selectDefaultScheduleBtn))
        
        let doneButton2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(NewAppointment.DoneScheduleButton))
        
        let flexSpace2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let label2 = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label2.font = UIFont(name: "FontAwesome", size: 16)
        
        label2.backgroundColor = UIColor.clear
        
        label2.textColor = UIColor.white
        
        label2.text = "Appointment Date"
        
        label2.textAlignment = NSTextAlignment.center
        
        let textBtn2 = UIBarButtonItem(customView: label2)
        
        toolBar2.setItems([defaultButton2,flexSpace2,textBtn2,flexSpace2,doneButton2], animated: true)
        
        scheduledDateWalkinPatient.inputAccessoryView = toolBar2
        
        /////////////////// Appointment Time
        
        let toolBar3 = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        
        toolBar3.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar3.barStyle = UIBarStyle.blackTranslucent
        
        toolBar3.tintColor = UIColor.white
        
        toolBar3.backgroundColor = UIColor.black
        
        let doneButton3 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(NewAppointment.DoneTimeButton))
        
        let flexSpace3 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let label3 = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 2, height: self.view.frame.size.height))
        
        label3.font = UIFont(name: "FontAwesome", size: 16)
        
        label3.backgroundColor = UIColor.clear
        
        label3.textColor = UIColor.white
        
        label3.text = "Appointment Time"
        
        label3.textAlignment = NSTextAlignment.center
        
        let textBtn3 = UIBarButtonItem(customView: label3)
        
        toolBar3.setItems([flexSpace3,textBtn3,flexSpace3,doneButton3], animated: true)
        
        appointmentTimeTextField.inputAccessoryView = toolBar3
        
        patientNameTextField.iconFont = UIFont(name: "FontAwesome", size: 12)
        patientNameTextField.iconText = "\u{f2c0}"
        patientNameTextField.iconColor = UIColor.lightGray
        patientNameTextField.title = "First Name"
        patientNameTextField.titleFormatter = { $0 }
        patientNameTextField.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        patientNameTextField.iconMarginBottom = 1.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        patientNameTextField.iconMarginLeft = 2.0
        self.view.addSubview(patientNameTextField)
        
        lastNameTextField.iconFont = UIFont(name: "FontAwesome", size: 12)
        lastNameTextField.iconText = "\u{f2c0}"
        lastNameTextField.iconColor = UIColor.lightGray
        lastNameTextField.title = "Last Name"
        lastNameTextField.titleFormatter = { $0 }
        lastNameTextField.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        lastNameTextField.iconMarginBottom = 1.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        lastNameTextField.iconMarginLeft = 2.0
        self.view.addSubview(lastNameTextField)
        
        phoneTextField.iconFont = UIFont(name: "FontAwesome", size: 12)
        phoneTextField.iconText = "\u{f095}"
        phoneTextField.iconColor = UIColor.lightGray
        phoneTextField.title = "Phone No"
        phoneTextField.titleFormatter = { $0 }
        phoneTextField.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        phoneTextField.iconMarginBottom = 1.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        phoneTextField.iconMarginLeft = 2.0
        self.view.addSubview(phoneTextField)
        
        pickerTextField.iconFont = UIFont(name: "FontAwesome", size: 12)
        pickerTextField.iconText = "\u{f0f6}"
        pickerTextField.iconColor = UIColor.lightGray
        pickerTextField.title = "Visit Type"
        pickerTextField.titleFormatter = { $0 }
        pickerTextField.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        pickerTextField.iconMarginBottom = 1.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        pickerTextField.iconMarginLeft = 2.0
        self.view.addSubview(pickerTextField)
        
        dateTextField.iconFont = UIFont(name: "FontAwesome", size: 12)
        dateTextField.iconText = "\u{f274}"
        dateTextField.iconColor = UIColor.lightGray
        dateTextField.title = "D.O.B"
        dateTextField.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        dateTextField.iconMarginBottom = 1.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        dateTextField.iconMarginLeft = 2.0
        self.view.addSubview(dateTextField)
        
        emailTextField.iconFont = UIFont(name: "FontAwesome", size: 12)
        emailTextField.iconText = "\u{f003}"
        emailTextField.iconColor = UIColor.lightGray
        emailTextField.title = "Email"
        emailTextField.titleFormatter = { $0 }
        emailTextField.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        emailTextField.iconMarginBottom = 1.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        emailTextField.iconMarginLeft = 2.0
        self.view.addSubview(emailTextField)
        
        addressTextFIeld.iconFont = UIFont(name: "FontAwesome", size: 12)
        addressTextFIeld.iconText = "\u{f041}"
        addressTextFIeld.iconColor = UIColor.lightGray
        addressTextFIeld.title = "Address"
        addressTextFIeld.titleFormatter = { $0 }
        addressTextFIeld.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        addressTextFIeld.iconMarginBottom = 1.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        addressTextFIeld.iconMarginLeft = 2.0
        self.view.addSubview(addressTextFIeld)
        
        scheduledDateWalkinPatient.iconFont = UIFont(name: "FontAwesome", size: 12)
        scheduledDateWalkinPatient.iconText = "\u{f274}"
        scheduledDateWalkinPatient.iconColor = UIColor.lightGray
        scheduledDateWalkinPatient.title = "Appointment Date"
        scheduledDateWalkinPatient.titleFormatter = { $0 }
        scheduledDateWalkinPatient.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        scheduledDateWalkinPatient.iconMarginBottom = 1.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        scheduledDateWalkinPatient.iconMarginLeft = 2.0
        self.view.addSubview(scheduledDateWalkinPatient)
        
        appointmentTimeTextField.iconFont = UIFont(name: "FontAwesome", size: 12)
        appointmentTimeTextField.iconText = "\u{f017}"
        appointmentTimeTextField.iconColor = UIColor.lightGray
        appointmentTimeTextField.title = "Appointment Time"
        appointmentTimeTextField.titleFormatter = { $0 }
        appointmentTimeTextField.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        appointmentTimeTextField.iconMarginBottom = 1.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        appointmentTimeTextField.iconMarginLeft = 2.0
        self.view.addSubview(appointmentTimeTextField)
        
        
    }
    
    func doneVisitBtnPressed(_ sender: UIBarButtonItem) {
        
        let _ = pickerTextField.resignFirstResponder()
        
    }
    
    func tappedToolBarVisitBtn(_ sender: UIBarButtonItem) {
        
        pickerTextField.text = "New Patient"
        
        let _ = pickerTextField.resignFirstResponder()
    }
    
    func selectDoneDateButton(_ sender: UIBarButtonItem) {
        
        let _ = dateTextField.resignFirstResponder()
        
    }
    
    func selectDefaultBtn(_ sender: UIBarButtonItem) {
        
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "dd MMMM yyyy"
        let date = NSDate()
        let stringOfDate = dateFormate.string(from: date as Date)
        dateTextField.text = stringOfDate
        
        let _ = dateTextField.resignFirstResponder()
    }
    
    func DoneScheduleButton(_ sender: UIBarButtonItem) {
        
        let _ = scheduledDateWalkinPatient.resignFirstResponder()
        
    }
    
    func DoneTimeButton(_ sender: UIBarButtonItem) {
        
        let _ = appointmentTimeTextField.resignFirstResponder()
        
    }
    
    func selectDefaultScheduleBtn(_ sender: UIBarButtonItem) {
        
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "dd MMMM yyyy"
        let date = NSDate()
        scheduledPickDate = date
        let stringOfDate = dateFormate.string(from: date as Date)
        scheduledDateWalkinPatient.text = stringOfDate
        
         let todayDate = dateWithOutTime(datDate: NSDate())
         scheduledPickDate = todayDate
        
        let _ = scheduledDateWalkinPatient.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickOption.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        pickerTextField.text = "New Patient"
        return pickOption[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerTextField.text = pickOption[row]
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
            
            let _ = dateTextField.resignFirstResponder()
            
        } else {
            
            dateTextField.text = dateFormatter.string(from: sender.date)
        }
        
    }
    
    func ScheduledDateChanged(sender:UIDatePicker){
        
        let date = NSDate()
        let todayDate = dateWithOutTime(datDate: date)
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd MMMM yyyy"
        
        scheduledPickDate = dateWithOutTime(datDate: sender.date as NSDate!)
        
        //print(scheduledPickDate)
        
        switch scheduledPickDate.compare(todayDate as Date) {
        case .orderedAscending     :   print("Date A is earlier than date B")
        case .orderedDescending    :   print("Date A is later than date B")
        case .orderedSame          :   print("The two dates are the same")
        }
        
        if scheduledPickDate.compare(todayDate as Date) == .orderedAscending {
            
            let alert = UIAlertController(title: "Notice", message: "Schedule date should not be selected before today's date", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil);
            
            let _ = scheduledDateWalkinPatient.resignFirstResponder()
            
        } else {
            
            scheduledDateWalkinPatient.text = dateFormatter.string(from: sender.date)
        }
        
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
        dateTextField.text = stringOfDate
        
        datePickerView.addTarget(self, action: #selector(NewAppointment.datePickerDateValueChanged), for: UIControlEvents.valueChanged)

    }

    
    @IBAction func scheduleDateTextFieldBeginEditing(_ sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datePickerView
        
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "dd MMMM yyyy"
        let date = NSDate()
        let todayDate = dateWithOutTime(datDate: date)
        let stringOfDate = dateFormate.string(from: todayDate as Date)
        scheduledDateWalkinPatient.text = stringOfDate
        scheduledPickDate = todayDate
        
        datePickerView.addTarget(self, action: #selector(NewAppointment.ScheduledDateChanged), for: UIControlEvents.valueChanged)
        
    }
    
    @IBAction func walkInBarButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func nextButtonClicked(_ sender: UIButton) {
        
        let isEmailAddressValid = isValidEmailAddress(emailAddressString: emailTextField.text!)
        
        if pickerTextField.text == "" || patientNameTextField.text == "" || dateTextField.text == "" || scheduledDateWalkinPatient.text == "" || lastNameTextField.text == "" || phoneTextField.text == "" {
            
            let alert = UIAlertController(title: "Notice", message: "Please fill mandatory fields", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil);
            
            return
            
        }  else if emailTextField.text != "" && !isEmailAddressValid {
            
            let alert = UIAlertController(title: "Notice", message: "Please enter valid email address", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil);
            
        } else if (phoneTextField.text?.characters.count)! > 15 {
            
            let alert = UIAlertController(title: "Notice", message: "Phone Number should not be more then 15 numbers", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil);
            
        } else {
            
            let userID = defaults.value(forKey: "UserID") as! Int32
           // let patientid = defaults.value(forKey: "PKEY")
            let generatedID = NSUUID().uuidString.lowercased() as String
            
            let context = getContext()
            
            let entity = NSEntityDescription.entity(forEntityName: "Appointments", in: context)
            
            let managedObj = NSManagedObject(entity: entity!, insertInto: context)
            
            managedObj.setValue(pickerTextField.text, forKey: "visitType")
            managedObj.setValue(patientNameTextField.text, forKey: "firstName")
            managedObj.setValue(lastNameTextField.text, forKey: "lastName")
            managedObj.setValue(phoneTextField.text, forKey: "phone")
            managedObj.setValue(emailTextField.text, forKey: "email")
            managedObj.setValue(addressTextFIeld.text, forKey: "address")
            managedObj.setValue(dateTextField.text, forKey: "dateBirth")
            managedObj.setValue(scheduledPickDate, forKey: "dateSchedule")
            managedObj.setValue(appointmentTimeTextField.text, forKey: "appointmentTime")
            managedObj.setValue(userID, forKey: "userID")
            managedObj.setValue(generatedID, forKey: "appointmentID")
            managedObj.setValue(false, forKey: "isRecording")
            managedObj.setValue("false", forKey: "recordingStatus")
            
            do {
                try context.save()
                            
                savePatientRecord()
                
                defaults.set(patientNameTextField.text, forKey: "PName")
                defaults.set(generatedID, forKey: "AppointmentID")
                defaults.set("", forKey: "PKEY")
                
                pickerTextField.text = ""
                patientNameTextField.text = ""
                lastNameTextField.text = ""
                phoneTextField.text = ""
                emailTextField.text = ""
                addressTextFIeld.text = ""
                dateTextField.text = ""
                appointmentTimeTextField.text = ""
                scheduledDateWalkinPatient.text = ""
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Dictation") as! selectDictation
                self.present(nextViewController, animated:true, completion:nil)
                
                return
                
                
            } catch {
                print(error.localizedDescription)
            }
            
            
        }
        
    }
    
    func getContext () -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    @IBAction func savePatient(_ sender: UIButton) {
        
        let userID = defaults.value(forKey: "UserID") as! Int32
        //let patientid = defaults.value(forKey: "PKEY")
        let generatedID = NSUUID().uuidString.lowercased() as String
        let isEmailAddressValid = isValidEmailAddress(emailAddressString: emailTextField.text!)
        
        if pickerTextField.text == "" || patientNameTextField.text == "" || dateTextField.text == "" || scheduledDateWalkinPatient.text == "" || lastNameTextField.text == "" || phoneTextField.text == ""  {
            
            let alert = UIAlertController(title: "Notice", message: "Please fill mandatory fields", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil);
            
            return
            
        }  else if emailTextField.text != "" && !isEmailAddressValid {
            
            let alert = UIAlertController(title: "Notice", message: "Please enter valid email address", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil);
            
        } else if (phoneTextField.text?.characters.count)! > 15 {
            
            let alert = UIAlertController(title: "Notice", message: "Phone Number should not be more then 15 numbers", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil);
            
        }  else {
            
            //print(scheduledPickDate)
            
            let context = getContext()
            
            let entity = NSEntityDescription.entity(forEntityName: "Appointments", in: context)
            
            let managedObj = NSManagedObject(entity: entity!, insertInto: context)
            
            
            managedObj.setValue(pickerTextField.text, forKey: "visitType")
            managedObj.setValue(patientNameTextField.text, forKey: "firstName")
            managedObj.setValue(lastNameTextField.text, forKey: "lastName")
            managedObj.setValue(phoneTextField.text, forKey: "phone")
            managedObj.setValue(emailTextField.text, forKey: "email")
            managedObj.setValue(addressTextFIeld.text, forKey: "address")
            managedObj.setValue(dateTextField.text, forKey: "dateBirth")
            managedObj.setValue(scheduledPickDate, forKey: "dateSchedule")
            managedObj.setValue(appointmentTimeTextField.text, forKey: "appointmentTime")
            managedObj.setValue(userID, forKey: "userID")
            managedObj.setValue(generatedID, forKey: "appointmentID")
            managedObj.setValue(false, forKey: "isRecording")
            managedObj.setValue("false", forKey: "recordingStatus")
            
            do {
                try context.save()
                
                savePatientRecord()
                
                defaults.set("", forKey: "PKEY")
                pickerTextField.text = ""
                patientNameTextField.text = ""
                lastNameTextField.text = ""
                phoneTextField.text = ""
                emailTextField.text = ""
                addressTextFIeld.text = ""
                dateTextField.text = ""
                appointmentTimeTextField.text = ""
                scheduledDateWalkinPatient.text = ""
                
                let alert = UIAlertController(title: "Success", message: "Appointment added successfully", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil);
                
                return
                
            } catch {
                print(error.localizedDescription)
            }
            
            
        }
        
        
    }
    
    @IBAction func dismissNewPatient(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    func navigate(){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Dictation") as! selectDictation
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    func dateWithOutTime( datDate: NSDate) -> NSDate {
        let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
        calendar.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone
        return calendar.startOfDay(for: datDate as Date) as (Date) as NSDate
    }
    
    @IBAction func navigateToHome(_ sender: UIBarButtonItem) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
        self.present(nextViewController, animated:true, completion:nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let firstname = defaults.value(forKey: "FN")
        let lastname = defaults.value(forKey: "LN")
        let phone = defaults.value(forKey: "PH")
        let dob = defaults.value(forKey: "DB")
        let email = defaults.value(forKey: "EM")
        let address = defaults.value(forKey: "AD")
        
        if firstname != nil {
            patientNameTextField.text = firstname as! String?
        }
        
        if lastname != nil {
            lastNameTextField.text = lastname as! String?
        }
        
        if phone != nil {
            phoneTextField.text = phone as! String?
        }
        
        if dob != nil {
            dateTextField.text = dob as! String?
        }
        
        if email != nil {
            emailTextField.text = email as! String?
        }
        
        if address != nil {
            addressTextFIeld.text = address as! String?
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        defaults.set("", forKey: "FN")
        defaults.set("", forKey: "LN")
        defaults.set("", forKey: "DB")
        defaults.set("", forKey: "PH")
        defaults.set("", forKey: "EM")
        defaults.set("", forKey: "AD")
        defaults.set("", forKey: "PKEY")
    }
    
    func savePatientRecord(){
        
        let uid = defaults.value(forKey: "UserID")
        let fetchRequest:NSFetchRequest<Patients> = Patients.fetchRequest()
        let predicate = NSPredicate(format: "(userID = %@) AND (firstName = %@) AND (lastName = %@) AND (phone = %@) AND (dateBirth = %@)", uid as! CVarArg, patientNameTextField.text!, lastNameTextField.text!, phoneTextField.text!, dateTextField.text!)
        fetchRequest.predicate = predicate
        
        do {
            let count = try getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            if count == 0 {
                
                let userID = defaults.value(forKey: "UserID") as! Int32
                let patientid = NSUUID().uuidString.lowercased() as String
                
                let context = getContext()
                
                let entity = NSEntityDescription.entity(forEntityName: "Patients", in: context)
                
                let managedObj = NSManagedObject(entity: entity!, insertInto: context)
                
                managedObj.setValue(patientNameTextField.text, forKey: "firstName")
                managedObj.setValue(lastNameTextField.text, forKey: "lastName")
                managedObj.setValue(phoneTextField.text, forKey: "phone")
                managedObj.setValue(dateTextField.text, forKey: "dateBirth")
                managedObj.setValue(emailTextField.text, forKey: "email")
                managedObj.setValue(addressTextFIeld.text, forKey: "address")
                managedObj.setValue(patientid, forKey: "id")
                managedObj.setValue(userID, forKey: "userID")
                
                do {
                    try context.save()
                    print("saved!")
                    
                    
                } catch {
                    print(error.localizedDescription)
                }
                
                
            }
        }catch {
            print(error.localizedDescription)
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
    
    @IBAction func searchPatient(_ sender: UIButton) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "patientsList") as! PatientsList
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func appointmentTimeBeginEditing(_ sender: UITextField) {
        
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        formatter.dateStyle = .none
        appointmentTimeTextField.text =  formatter.string(from: currentDateTime)
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.time
        datePickerView.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        sender.inputView = datePickerView
        
        
        datePickerView.addTarget(self, action: #selector(NewAppointment.timeValueChanged), for: UIControlEvents.valueChanged)
    }
    
    func timeValueChanged(sender:UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        appointmentTimeTextField.text = formatter.string(from: sender.date)
        
    }
    
}



