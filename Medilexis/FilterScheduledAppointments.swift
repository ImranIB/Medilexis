//
//  FilterScheduledAppointments.swift
//  Medilexis
//
//  Created by iOS Developer on 13/03/2018.
//  Copyright © 2018 NX3. All rights reserved.
//

import UIKit
import CoreData
import SkyFloatingLabelTextField

class FilterScheduledAppointments: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var filterView: UIView!
    @IBOutlet var fromTextField: SkyFloatingLabelTextField!
    @IBOutlet var toTextField: SkyFloatingLabelTextField!
    @IBOutlet var firstNameTextField: SkyFloatingLabelTextField!
    @IBOutlet var lastNameTextField: SkyFloatingLabelTextField!
    @IBOutlet var dobTextFIeld: SkyFloatingLabelTextField!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults.standard
    var tasks = [Appointments]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterView.layer.borderWidth = 1.0
        filterView.layer.borderColor = UIColor.darkGray.cgColor
        
        fromTextField.title = ""
        fromTextField.titleFormatter = { $0 }
        fromTextField.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        // self.view.addSubview(fromTextField)
        
        toTextField.title = ""
        toTextField.titleFormatter = { $0 }
        toTextField.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        //self.view.addSubview(toTextField)
        
        firstNameTextField.title = ""
        firstNameTextField.titleFormatter = { $0 }
        firstNameTextField.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        //self.view.addSubview(firstNameTextField)
        
        lastNameTextField.title = ""
        lastNameTextField.titleFormatter = { $0 }
        lastNameTextField.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        //self.view.addSubview(lastNameTextField)
        
        dobTextFIeld.title = ""
        dobTextFIeld.titleFormatter = { $0 }
        dobTextFIeld.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        //self.view.addSubview(dobTextFIeld)
        
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "dd MMMM yyyy"
        let date = NSDate()
        let stringOfDate = dateFormate.string(from: date as Date)
        toTextField.text = stringOfDate
        
        let previousDateFormate = DateFormatter()
        previousDateFormate.dateFormat = "dd MMMM yyyy"
        let newFromDate = dateFormate.string(from: date as Date)
        fromTextField.text = newFromDate
        
        let toolBar1 = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        
        toolBar1.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar1.barStyle = UIBarStyle.blackTranslucent
        
        toolBar1.tintColor = UIColor.white
        
        toolBar1.backgroundColor = UIColor.black
        
        
        let defaultButton1 = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.plain, target: self, action: #selector(FilterScheduledAppointments.FromDefaultBtn))
        
        let doneButton1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(FilterScheduledAppointments.selectDoneFromButton))
        
        let flexSpace1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let label1 = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label1.font = UIFont(name: "FontAwesome", size: 16)
        
        label1.backgroundColor = UIColor.clear
        
        label1.textColor = UIColor.white
        
        label1.text = "Start Date"
        
        label1.textAlignment = NSTextAlignment.center
        
        let textBtn1 = UIBarButtonItem(customView: label1)
        
        toolBar1.setItems([defaultButton1,flexSpace1,textBtn1,flexSpace1,doneButton1], animated: true)
        
        fromTextField.inputAccessoryView = toolBar1
        
        let toolBar2 = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        
        toolBar2.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar2.barStyle = UIBarStyle.blackTranslucent
        
        toolBar2.tintColor = UIColor.white
        
        toolBar2.backgroundColor = UIColor.black
        
        
        let defaultButton2 = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.plain, target: self, action: #selector(FilterScheduledAppointments.ToDefaultBtn))
        
        let doneButton2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(FilterScheduledAppointments.DoneToButton))
        
        let flexSpace2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let label2 = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label2.font = UIFont(name: "FontAwesome", size: 16)
        
        label2.backgroundColor = UIColor.clear
        
        label2.textColor = UIColor.white
        
        label2.text = "End Date"
        
        label2.textAlignment = NSTextAlignment.center
        
        let textBtn2 = UIBarButtonItem(customView: label2)
        
        toolBar2.setItems([defaultButton2,flexSpace2,textBtn2,flexSpace2,doneButton2], animated: true)
        
        toTextField.inputAccessoryView = toolBar2
        
        //............................................................................................. DOB
        
        let toolBar3 = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        
        toolBar3.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar3.barStyle = UIBarStyle.blackTranslucent
        
        toolBar3.tintColor = UIColor.white
        
        toolBar3.backgroundColor = UIColor.black
        
        
        let defaultButton3 = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.plain, target: self, action: #selector(FilterScheduledAppointments.selectDefaultBtn))
        
        let doneButton3 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(FilterScheduledAppointments.selectDoneDateButton))
        
        let flexSpace3 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let label3 = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label3.font = UIFont(name: "FontAwesome", size: 16)
        
        label3.backgroundColor = UIColor.clear
        
        label3.textColor = UIColor.white
        
        label3.text = "Birth Date"
        
        label3.textAlignment = NSTextAlignment.center
        
        let textBtn3 = UIBarButtonItem(customView: label3)
        
        toolBar3.setItems([defaultButton3,flexSpace3,textBtn3,flexSpace3,doneButton3], animated: true)
        
        dobTextFIeld.inputAccessoryView = toolBar3
    }
    
    @objc func FromDefaultBtn(_ sender: UIBarButtonItem) {
        
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "dd MMMM yyyy"
        let date = NSDate()
        let stringOfDate = dateFormate.string(from: date as Date)
        fromTextField.text = stringOfDate
        
        let todayDate = dateWithOutTime(datDate: NSDate())
        defaults.set(todayDate, forKey: "FromDate")
        
        let _ = fromTextField.resignFirstResponder()
    }
    
    @objc func ToDefaultBtn(_ sender: UIBarButtonItem) {
        
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "dd MMMM yyyy"
        let date = NSDate()
        let stringOfDate = dateFormate.string(from: date as Date)
        toTextField.text = stringOfDate
        
        let todayDate = dateWithOutTime(datDate: NSDate())
        defaults.set(todayDate, forKey: "ToDate")
        
        let _ = toTextField.resignFirstResponder()
    }
    
    @objc func selectDoneFromButton(_ sender: UIBarButtonItem) {
        
        let _ = fromTextField.resignFirstResponder()
        
    }
    
    @objc func DoneToButton(_ sender: UIBarButtonItem) {
        
        let _ = toTextField.resignFirstResponder()
        
    }
    
    @objc func selectDoneDateButton(_ sender: UIBarButtonItem) {
        
        let _ = dobTextFIeld.resignFirstResponder()
        
    }
    
    @objc func selectDefaultBtn(_ sender: UIBarButtonItem) {
        
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "dd MMMM yyyy"
        let date = NSDate()
        let stringOfDate = dateFormate.string(from: date as Date)
        dobTextFIeld.text = stringOfDate
        
        let _ = dobTextFIeld.resignFirstResponder()
    }
    
    @IBAction func fromTextFieldBeginEditing(_ sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(FilterScheduledAppointments.FromDateValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func FromDateValueChanged(sender:UIDatePicker){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        defaults.set(dateWithOutTime(datDate: sender.date as NSDate!), forKey: "FromDate")
        fromTextField.text = dateFormatter.string(from: sender.date)
        
    }
    
    @IBAction func toTextFieldBeginEditing(_ sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        datePickerView.addTarget(self, action: #selector(FilterScheduledAppointments.ToDateValueChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func ToDateValueChanged(sender:UIDatePicker){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        defaults.set(dateWithOutTime(datDate: sender.date as NSDate!), forKey: "ToDate")
        toTextField.text = dateFormatter.string(from: sender.date)
        
    }
    
    @IBAction func dobBeginEditing(_ sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "dd MMMM yyyy"
        let date = NSDate()
        let todayDate = dateWithOutTime(datDate: date)
        let stringOfDate = dateFormate.string(from: todayDate as Date)
        dobTextFIeld.text = stringOfDate
        
        datePickerView.addTarget(self, action: #selector(FilterScheduledAppointments.datePickerDateValueChanged), for: UIControlEvents.valueChanged)
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
            
            let _ = dobTextFIeld.resignFirstResponder()
            
        } else {
            
            dobTextFIeld.text = dateFormatter.string(from: sender.date)
        }
        
    }
    @IBAction func closePressed(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        
        if firstNameTextField.text == "" && lastNameTextField.text == "" && dobTextFIeld.text == "" {
            
            let alert = UIAlertController(title: "Notice", message: "Search with either First Name, Last Name or Dob.", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil);
            
        } else {
            
            
            let uid = defaults.value(forKey: "UserID")
            let fromDate = defaults.value(forKey: "FromDate") as! NSDate
            let toDate = defaults.value(forKey: "ToDate") as! NSDate
            
            tasks.removeAll()
            let _ =  fromTextField.resignFirstResponder()
            let _ =  toTextField.resignFirstResponder()
            
            let fetchRequest:NSFetchRequest<Appointments> = Appointments.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "dateSchedule", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            let predicate = NSPredicate(format: "(userID = %@) AND (dateSchedule >= %@ OR dateSchedule <= %@) AND (isRecording == false) AND (firstName = %@ || lastName == %@ || dateBirth == %@)", uid as! CVarArg, fromDate, toDate, firstNameTextField.text!, lastNameTextField.text!, dobTextFIeld.text!)
            fetchRequest.predicate = predicate
   
            do {
                
                let count = try getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
                
                if count > 0 {
                    
                    let fetchResult = try getContext().fetch(fetchRequest)
                    
                    for item in fetchResult {
                        
                        tasks.append(item)
                        
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "scheduledappointments") as! ScheduledAppointments
                        nextViewController.selection = true
                        nextViewController.filteredAppointments = tasks
                        self.present(nextViewController, animated:true, completion:nil)
                        
                    }
                } else {
                    
                    tasks.removeAll()
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "scheduledappointments") as! ScheduledAppointments
                    nextViewController.selection = true
                    nextViewController.filteredAppointments = tasks
                    self.present(nextViewController, animated:true, completion:nil)
                    
                }
                
            }catch {
                print(error.localizedDescription)
            }
            
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
    
    func getContext () -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dateWithOutTime( datDate: NSDate) -> NSDate {
        let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
        calendar.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone
        return calendar.startOfDay(for: datDate as Date) as (Date) as NSDate
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let currentDate = dateWithOutTime(datDate: NSDate())
        defaults.set(currentDate, forKey: "FromDate")
        defaults.set(currentDate, forKey: "ToDate")
    }
}

