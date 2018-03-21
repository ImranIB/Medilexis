//
//  Popup.swift
//  Medilexis
//
//  Created by iOS Developer on 17/08/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit
import CoreData
import SkyFloatingLabelTextField

class FilterSearchAppointments: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var firstname: SkyFloatingLabelTextField!
    @IBOutlet var lastname: SkyFloatingLabelTextField!
    @IBOutlet var dob: SkyFloatingLabelTextField!
    @IBOutlet var startdate: SkyFloatingLabelTextField!
    @IBOutlet var enddate: SkyFloatingLabelTextField!
    @IBOutlet weak var filterView: UIView!
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults.standard
    var dobPickDate: NSDate!
    var startPickDate: NSDate!
    var endPickDate: NSDate!
    
    var searchTasks = [Appointments]()
    var tasks = [Appointments]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        filterView.layer.borderWidth = 1.0
        filterView.layer.borderColor = UIColor.darkGray.cgColor
        
        firstname.title = ""
        firstname.titleFormatter = { $0 }
        firstname.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        
        lastname.title = ""
        lastname.titleFormatter = { $0 }
        lastname.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        
        dob.title = ""
        dob.titleFormatter = { $0 }
        dob.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        
        startdate.title = ""
        startdate.titleFormatter = { $0 }
        startdate.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
   
        enddate.title = ""
        enddate.titleFormatter = { $0 }
        enddate.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
       
        startPickDate = dateWithOutTime(datDate: NSDate())
        
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "dd MMMM yyyy"
        let date = NSDate()
        let stringOfDate = dateFormate.string(from: date as Date)
        startdate.text = stringOfDate
        
        let previousDateFormate = DateFormatter()
        previousDateFormate.dateFormat = "dd MMMM yyyy"
        let newFromDate = dateFormate.string(from: date as Date)
        enddate.text = newFromDate
        
        // DOB Toolbar
        
        let toolBar1 = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        
        toolBar1.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar1.barStyle = UIBarStyle.blackTranslucent
        
        toolBar1.tintColor = UIColor.white
        
        toolBar1.backgroundColor = UIColor.black
        
        
        let defaultButton1 = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.plain, target: self, action: #selector(FilterSearchAppointments.dobDefaultBtn))
        
        let doneButton1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(FilterSearchAppointments.selectDoneDobButton))
        
        let flexSpace1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let label1 = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label1.font = UIFont(name: "FontAwesome", size: 16)
        
        label1.backgroundColor = UIColor.clear
        
        label1.textColor = UIColor.white
        
        label1.text = "DOB"
        
        label1.textAlignment = NSTextAlignment.center
        
        let textBtn1 = UIBarButtonItem(customView: label1)
        
        toolBar1.setItems([defaultButton1,flexSpace1,textBtn1,flexSpace1,doneButton1], animated: true)
        
        dob.inputAccessoryView = toolBar1
        
        // Start Date Toolbar
        
        let toolBar2 = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        
        toolBar2.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar2.barStyle = UIBarStyle.blackTranslucent
        
        toolBar2.tintColor = UIColor.white
        
        toolBar2.backgroundColor = UIColor.black
        
        
        let defaultButton2 = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.plain, target: self, action: #selector(FilterSearchAppointments.FromDefaultBtn))
        
        let doneButton2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(FilterSearchAppointments.selectDoneFromButton))
        
        let flexSpace2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let label2 = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label2.font = UIFont(name: "FontAwesome", size: 16)
        
        label2.backgroundColor = UIColor.clear
        
        label2.textColor = UIColor.white
        
        label2.text = "Start Date"
        
        label2.textAlignment = NSTextAlignment.center
        
        let textBtn2 = UIBarButtonItem(customView: label2)
        
        toolBar2.setItems([defaultButton2,flexSpace2,textBtn2,flexSpace2,doneButton2], animated: true)
        
        startdate.inputAccessoryView = toolBar2
        
        // End Date Toolbar
        
        let toolBar3 = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        
        toolBar3.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar3.barStyle = UIBarStyle.blackTranslucent
        
        toolBar3.tintColor = UIColor.white
        
        toolBar3.backgroundColor = UIColor.black
        
        
        let defaultButton3 = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.plain, target: self, action: #selector(FilterSearchAppointments.ToDefaultBtn))
        
        let doneButton3 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(FilterSearchAppointments.selectDoneToButton))
        
        let flexSpace3 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let label3 = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label3.font = UIFont(name: "FontAwesome", size: 16)
        
        label3.backgroundColor = UIColor.clear
        
        label3.textColor = UIColor.white
        
        label3.text = "End Date"
        
        label3.textAlignment = NSTextAlignment.center
        
        let textBtn3 = UIBarButtonItem(customView: label3)
        
        toolBar3.setItems([defaultButton3,flexSpace3,textBtn3,flexSpace3,doneButton3], animated: true)
        
        enddate.inputAccessoryView = toolBar3
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func FromDefaultBtn(_ sender: UIBarButtonItem) {
        
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "dd MMMM yyyy"
        let date = NSDate()
        let stringOfDate = dateFormate.string(from: date as Date)
        startdate.text = stringOfDate
        
        let todayDate = dateWithOutTime(datDate: NSDate())
        defaults.set(todayDate, forKey: "SearchFromDate")
        
        let _ = startdate.resignFirstResponder()
    }
    
    @objc func ToDefaultBtn(_ sender: UIBarButtonItem) {
        
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "dd MMMM yyyy"
        let date = NSDate()
        let stringOfDate = dateFormate.string(from: date as Date)
        enddate.text = stringOfDate
        
        let todayDate = dateWithOutTime(datDate: NSDate())
        defaults.set(todayDate, forKey: "SearchToDate")
        
        let _ = enddate.resignFirstResponder()
    }
    
    @objc func selectDoneFromButton(_ sender: UIBarButtonItem) {
        
        let _ = startdate.resignFirstResponder()
        
    }
    
    @objc func selectDoneToButton(_ sender: UIBarButtonItem) {
        
        let _ = enddate.resignFirstResponder()
        
    }
    
    @objc func DoneToButton(_ sender: UIBarButtonItem) {
        
        let _ = enddate.resignFirstResponder()
        
    }
    
    @objc func selectDoneDateButton(_ sender: UIBarButtonItem) {
        
        let _ = dob.resignFirstResponder()
        
    }
    
    @objc func selectDefaultBtn(_ sender: UIBarButtonItem) {
        
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "dd MMMM yyyy"
        let date = NSDate()
        let stringOfDate = dateFormate.string(from: date as Date)
        dob.text = stringOfDate
        
        let _ = dob.resignFirstResponder()
    }
    
    @IBAction func searchButtonPressed(_ sender: UIButton) {
        
        if firstname.text == "" && lastname.text == "" && dob.text == "" {
            
            let alert = UIAlertController(title: "Notice", message: "Search with either First Name, Last Name or Dob.", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil);
            
        } else {
            
            let uid = defaults.value(forKey: "UserID")
            let fromDate = defaults.value(forKey: "SearchFromDate") as! NSDate
            let toDate = defaults.value(forKey: "SearchToDate") as! NSDate
            
            tasks.removeAll()
            let _ =  startdate.resignFirstResponder()
            let _ =  enddate.resignFirstResponder()
            
            let fetchRequest:NSFetchRequest<Appointments> = Appointments.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "dateSchedule", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            let predicate = NSPredicate(format: "(userID = %@) AND (dateSchedule >= %@ OR dateSchedule <= %@) AND (firstName = %@ || lastName == %@ || dateBirth == %@)", uid as! CVarArg, fromDate, toDate, firstname.text!, lastname.text!, dob.text!)
            fetchRequest.predicate = predicate
            
            do {
                
                let count = try getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
                
                if count > 0 {
                    
                    let fetchResult = try getContext().fetch(fetchRequest)
                    
                    for item in fetchResult {
                        
                        tasks.append(item)
                        
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "searchappointments") as! SearchAppointments
                        nextViewController.selection = true
                        nextViewController.filteredSearchAppointments = tasks
                        self.present(nextViewController, animated:true, completion:nil)
                        
                    }
                } else {
                    
                    tasks.removeAll()
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "searchappointments") as! SearchAppointments
                    nextViewController.selection = true
                    nextViewController.filteredSearchAppointments = tasks
                    self.present(nextViewController, animated:true, completion:nil)
                    
                }
                
            }catch {
                print(error.localizedDescription)
            }
            
        }
    }
    
    @IBAction func dobEditing(_ sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        datePickerView.datePickerMode = UIDatePickerMode.date
        sender.inputView = datePickerView
        
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "dd MMMM yyyy"
        let date = NSDate()
        let todayDate = dateWithOutTime(datDate: date)
        let stringOfDate = dateFormate.string(from: todayDate as Date)
        dob.text = stringOfDate
        
        datePickerView.addTarget(self, action: #selector(NewAppointment.datePickerDateValueChanged), for: UIControlEvents.valueChanged)
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
    
    @IBAction func startdateEditing(_ sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datePickerView
        
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "dd MMMM yyyy"
        let date = NSDate()
        let todayDate = dateWithOutTime(datDate: date)
        let stringOfDate = dateFormate.string(from: todayDate as Date)
        startdate.text = stringOfDate
        
        datePickerView.addTarget(self, action: #selector(FilterSearchAppointments.startDateChanged), for: UIControlEvents.valueChanged)
    }
    
    @objc func startDateChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        defaults.set(dateWithOutTime(datDate: sender.date as NSDate!), forKey: "SearchFromDate")
        startdate.text = dateFormatter.string(from: sender.date)
    }
    
    @IBAction func endDateEditing(_ sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datePickerView
        
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "dd MMMM yyyy"
        let date = NSDate()
        let todayDate = dateWithOutTime(datDate: date)
        let stringOfDate = dateFormate.string(from: todayDate as Date)
        enddate.text = stringOfDate
        
        datePickerView.addTarget(self, action: #selector(FilterSearchAppointments.endDateChanged), for: UIControlEvents.valueChanged)
    }
   
    @objc func endDateChanged(sender:UIDatePicker) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        defaults.set(dateWithOutTime(datDate: sender.date as NSDate!), forKey: "SearchToDate")
        enddate.text = dateFormatter.string(from: sender.date)
        
    }
    @IBAction func homePressed(_ sender: UIBarButtonItem) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func getContext () -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    @objc func dobDefaultBtn(_ sender: UIBarButtonItem) {
        
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "dd MMMM yyyy"
        let date = NSDate()
        let stringOfDate = dateFormate.string(from: date as Date)
        dob.text = stringOfDate
        
        let _ = dob.resignFirstResponder()
    }
    
    @objc func selectDoneDobButton(_ sender: UIBarButtonItem) {
        
        let _ = dob.resignFirstResponder()
        
    }
   
    func dateWithOutTime( datDate: NSDate) -> NSDate {
        let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
        calendar.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone
        return calendar.startOfDay(for: datDate as Date) as (Date) as NSDate
    }
    
    func deleteAllData(entity: String)
    {
        let ReqVar = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let DelAllReqVar = NSBatchDeleteRequest(fetchRequest: ReqVar)
        do { try context.execute(DelAllReqVar) }
        catch { print(error) }
    }
    
    @IBAction func closePressed(_ sender: UIButton) {
        
         dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let currentDate = dateWithOutTime(datDate: NSDate())
        defaults.set(currentDate, forKey: "SearchFromDate")
        defaults.set(currentDate, forKey: "SearchToDate")
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
}
