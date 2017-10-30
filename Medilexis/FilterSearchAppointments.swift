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

class FilterSearchAppointments: UIViewController {
    
    @IBOutlet var firstname: SkyFloatingLabelTextField!
    @IBOutlet var lastname: SkyFloatingLabelTextField!
    @IBOutlet var dob: SkyFloatingLabelTextField!
    @IBOutlet var startdate: SkyFloatingLabelTextField!
    @IBOutlet var enddate: SkyFloatingLabelTextField!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults.standard
    var dobPickDate: NSDate!
    var startPickDate: NSDate!
    var endPickDate: NSDate!
    
    var searchTasks = [Appointments]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstname.title = "First Name"
        firstname.titleFormatter = { $0 }
        firstname.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        self.view.addSubview(firstname)
        
        lastname.title = "Last Name"
        lastname.titleFormatter = { $0 }
        lastname.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        self.view.addSubview(lastname)
        
        dob.title = "DOB"
        dob.titleFormatter = { $0 }
        dob.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        self.view.addSubview(dob)
        
        startdate.title = "Start Date"
        startdate.titleFormatter = { $0 }
        startdate.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        self.view.addSubview(startdate)
        
        enddate.title = "End Date"
        enddate.titleFormatter = { $0 }
        enddate.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        self.view.addSubview(enddate)
        
        startPickDate = dateWithOutTime(datDate: NSDate())
        
        print(startPickDate)
        
        
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
        
        
        let defaultButton2 = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.plain, target: self, action: #selector(FilterSearchAppointments.startDefaultBtn))
        
        let doneButton2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(FilterSearchAppointments.selectDoneStartButton))
        
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func searchPressed(_ sender: UIButton) {
        
        defaults.set("FilterSearchAppointments", forKey: "ComingFrom")
        
        deleteAllData(entity: "FilterAppointments")
        
        let uid = defaults.value(forKey: "UserID")
        
        //let fromDate = defaults.value(forKey: "SearchFromDate") as! NSDate
        //let toDate = defaults.value(forKey: "SearchToDate") as! NSDate
        
        let fetchRequest:NSFetchRequest<Appointments> = Appointments.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "dateSchedule", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate(format: "(userID = %@) AND (firstName = %@) OR (lastName = %@)", uid as! CVarArg, firstname.text!, lastname.text!)
        fetchRequest.predicate = predicate
        
        
        do {
            
            let count = try getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            if count > 0 {
                
                let fetchResult = try getContext().fetch(fetchRequest)
                
                for item in fetchResult {
                    
                    let entity = NSEntityDescription.entity(forEntityName: "FilterAppointments", in: context)
                    
                    let managedObj = NSManagedObject(entity: entity!, insertInto: context)
                    
                    managedObj.setValue(item.firstName, forKey: "firstname")
                    managedObj.setValue(item.lastName, forKey: "lastName")
                    managedObj.setValue(startPickDate, forKey: "startDate")
                    managedObj.setValue(uid, forKey: "userID")
                    
                    do {
                        
                        try context.save()
                        
                        print("saved")
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                }
            } else {
                // searchTasks.removeAll()
                
                
            }
            
        }catch {
            print(error.localizedDescription)
        }
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
        dob.text = stringOfDate
        
        datePickerView.addTarget(self, action: #selector(FilterSearchAppointments.datePickerDateValueChanged), for: UIControlEvents.valueChanged)
    }
    
    func datePickerDateValueChanged(sender:UIDatePicker) {
        
        let date = NSDate()
        let todayDate = dateWithOutTime(datDate: date)
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd MMMM yyyy"
        
        dobPickDate = dateWithOutTime(datDate: sender.date as NSDate!)
        
        print(dobPickDate)
        
        switch dobPickDate.compare(todayDate as Date) {
        case .orderedAscending     :   print("Date A is earlier than date B")
        case .orderedDescending    :   print("Date A is later than date B")
        case .orderedSame          :   print("The two dates are the same")
        }
        
        if dobPickDate.compare(todayDate as Date) == .orderedDescending {
            
            let alert = UIAlertController(title: "Notice", message: "Schedule date should not be selected before today's date", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil);
            
            let _ = dob.resignFirstResponder()
            
        } else {
            
            dob.text = dateFormatter.string(from: sender.date)
        }
        
    }
    
    @IBAction func startdateBeginEditing(_ sender: UITextField) {
        
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
    
    func startDateChanged(sender:UIDatePicker) {
        
        let date = NSDate()
        let todayDate = dateWithOutTime(datDate: date)
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd MMMM yyyy"
        
        startPickDate = dateWithOutTime(datDate: sender.date as NSDate!)
        
        print(startPickDate)
        
        switch startPickDate.compare(todayDate as Date) {
        case .orderedAscending     :   print("Date A is earlier than date B")
        case .orderedDescending    :   print("Date A is later than date B")
        case .orderedSame          :   print("The two dates are the same")
        }
        
        if startPickDate.compare(todayDate as Date) == .orderedAscending {
            
            let alert = UIAlertController(title: "Notice", message: "Start date should not be selected after today's date", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil);
            
            let _ = startdate.resignFirstResponder()
            
        } else {
            
            startdate.text = dateFormatter.string(from: sender.date)
        }
        
    }
    
    @IBAction func enddateBeginEditing(_ sender: UITextField) {
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
    
    func dobDefaultBtn(_ sender: UIBarButtonItem) {
        
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "dd MMMM yyyy"
        let date = NSDate()
        let stringOfDate = dateFormate.string(from: date as Date)
        dob.text = stringOfDate
        
        let _ = dob.resignFirstResponder()
    }
    
    func selectDoneDobButton(_ sender: UIBarButtonItem) {
        
        let _ = dob.resignFirstResponder()
        
    }
    
    func startDefaultBtn(_ sender: UIBarButtonItem) {
        
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "dd MMMM yyyy"
        let date = NSDate()
        let stringOfDate = dateFormate.string(from: date as Date)
        startdate.text = stringOfDate
        startPickDate = dateWithOutTime(datDate: NSDate())
        let _ = startdate.resignFirstResponder()
    }
    
    func selectDoneStartButton(_ sender: UIBarButtonItem) {
        
        let _ = startdate.resignFirstResponder()
        
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
    
    
}
