//
//  PatientsVC.swift
//  Medilexis
//
//  Created by iOS Developer on 20/02/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit
import CoreData
import SCLAlertView
import SkyFloatingLabelTextField

class PatientsData: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet weak var fromTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var toTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noPatients: UILabel!
    
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults.standard
    
    var tasks = [Patients]()
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        self.view.backgroundColor =  UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        self.tableView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        
        tableView.reloadData()
        
        checkPatients()
        
        fromTextField.iconFont = UIFont(name: "FontAwesome", size: 12)
        fromTextField.iconText = "\u{f274}"
        fromTextField.iconColor = UIColor.lightGray
        fromTextField.title = ""
        fromTextField.titleFormatter = { $0 }
        fromTextField.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        fromTextField.iconMarginBottom = 1.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        fromTextField.iconMarginLeft = 2.0
        self.view.addSubview(fromTextField)
        
        toTextField.iconFont = UIFont(name: "FontAwesome", size: 12)
        toTextField.iconText = "\u{f274}"
        toTextField.iconColor = UIColor.lightGray
        toTextField.title = ""
        toTextField.titleFormatter = { $0 }
        toTextField.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        toTextField.iconMarginBottom = 1.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        toTextField.iconMarginLeft = 2.0
        self.view.addSubview(toTextField)
        
        
        let currentDate = dateWithOutTime(datDate: NSDate())
        defaults.set(currentDate, forKey: "FromDate")
        defaults.set(currentDate, forKey: "ToDate")
        
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "dd MMMM yyyy"
        let date = NSDate()
        let stringOfDate = dateFormate.string(from: date as Date)
        fromTextField.text = stringOfDate
        toTextField.text = stringOfDate
        
        let toolBar1 = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        
        toolBar1.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar1.barStyle = UIBarStyle.blackTranslucent
        
        toolBar1.tintColor = UIColor.white
        
        toolBar1.backgroundColor = UIColor.black
        
        
        let defaultButton1 = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.plain, target: self, action: #selector(PatientsData.FromDefaultBtn))
        
        let doneButton1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(PatientsData.selectDoneFromButton))
        
        let flexSpace1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let label1 = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label1.font = UIFont(name: "Helvetica", size: 12)
        
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
        
        
        let defaultButton2 = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.plain, target: self, action: #selector(PatientsData.ToDefaultBtn))
        
        let doneButton2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(PatientsData.DoneToButton))
        
        let flexSpace2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let label2 = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label2.font = UIFont(name: "Helvetica", size: 12)
        
        label2.backgroundColor = UIColor.clear
        
        label2.textColor = UIColor.white
        
        label2.text = "End Date"
        
        label2.textAlignment = NSTextAlignment.center
        
        let textBtn2 = UIBarButtonItem(customView: label2)
        
        toolBar2.setItems([defaultButton2,flexSpace2,textBtn2,flexSpace2,doneButton2], animated: true)
        
        toTextField.inputAccessoryView = toolBar2
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func FromDefaultBtn(_ sender: UIBarButtonItem) {
        
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "dd MMMM yyyy"
        let date = NSDate()
        let stringOfDate = dateFormate.string(from: date as Date)
        fromTextField.text = stringOfDate
        
        let todayDate = dateWithOutTime(datDate: NSDate())
        defaults.set(todayDate, forKey: "FromDate")
        
        let _ = fromTextField.resignFirstResponder()
    }
    
    func ToDefaultBtn(_ sender: UIBarButtonItem) {
        
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "dd MMMM yyyy"
        let date = NSDate()
        let stringOfDate = dateFormate.string(from: date as Date)
        toTextField.text = stringOfDate
        
        let todayDate = dateWithOutTime(datDate: NSDate())
        defaults.set(todayDate, forKey: "ToDate")
        
        let _ = toTextField.resignFirstResponder()
    }
    
    func selectDoneFromButton(_ sender: UIBarButtonItem) {
        
        let _ = fromTextField.resignFirstResponder()
        
    }
    
    func DoneToButton(_ sender: UIBarButtonItem) {
        
        let _ = toTextField.resignFirstResponder()
        
    }
    
    @IBAction func fromTextFieldBeginEditing(_ sender: UITextField) {
        
        fromTextField.title = "Start Date"
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(PatientsData.FromDateValueChanged), for: UIControlEvents.valueChanged)
    }
    
    func FromDateValueChanged(sender:UIDatePicker){
        
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd MMMM yyyy"
        
        defaults.set(dateWithOutTime(datDate: sender.date as NSDate!), forKey: "FromDate")
        
        fromTextField.text = dateFormatter.string(from: sender.date)
        
    }
    
    @IBAction func toTextFieldBeginEditing(_ sender: UITextField) {
        
        toTextField.title = "End Date"
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(PatientsData.ToDateValueChanged), for: UIControlEvents.valueChanged)
    }
  
    func ToDateValueChanged(sender:UIDatePicker){
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd MMMM yyyy"
        
        defaults.set(dateWithOutTime(datDate: sender.date as NSDate!), forKey: "ToDate")
        
        toTextField.text = dateFormatter.string(from: sender.date)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // return filteredArray.count
        return tasks.count
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
           let cell = tableView.dequeueReusableCell(withIdentifier: "Patients", for: indexPath) as! PatientCell
        
        let task = tasks[indexPath.row]
        
        if let myName = task.patientName {
            cell.patientName?.text = myName
    
        }
        
        if let date = task.dateSchedule {
            
            let dateFormate = DateFormatter()
            dateFormate.dateFormat = "dd MMMM yyyy"
            let stringOfDate = dateFormate.string(from: date as Date)
           cell.patientSchedule?.text = stringOfDate
       
        }
       
        return cell
        
        
    }
    
    
    @IBAction func searchPatientsBarButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        getData()
        checkPatients()
        
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "dd MMMM yyyy"
        let date = NSDate()
        let stringOfDate = dateFormate.string(from: date as Date)
        fromTextField.text = stringOfDate
        toTextField.text = stringOfDate
    }
    
    @IBAction func navigateToHome(_ sender: UIBarButtonItem) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    
    func getContext () -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    
    func getData() {
    
        let todayDate = dateWithOutTime(datDate: NSDate())
        let uid = defaults.value(forKey: "UserID")
        tasks.removeAll()
        
        let fetchRequest:NSFetchRequest<Patients> = Patients.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "dateSchedule", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate(format: "(userID = %@) AND (dateSchedule = %@) AND (isRecording == false)", uid as! CVarArg, todayDate)
        fetchRequest.predicate = predicate
        
        do {
            let count = try getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            if count > 0 {
                
                let fetchResult = try getContext().fetch(fetchRequest)
                
                for item in fetchResult {
                
                    tasks.append(item)
                    tableView.reloadData()
                }
            } else {
                tasks.removeAll()
                tableView.reloadData()
            }
            
        }catch {
            print(error.localizedDescription)
        }
     
    }
    
    func dateWithOutTime( datDate: NSDate) -> NSDate {
        let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
        calendar.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone
        return calendar.startOfDay(for: datDate as Date) as (Date) as NSDate
    }
    
    @IBAction func searchPatient(_ sender: UIButton) {
        
        let uid = defaults.value(forKey: "UserID")
        let fromDate = defaults.value(forKey: "FromDate") as! NSDate
        let toDate = defaults.value(forKey: "ToDate") as! NSDate
    
        tasks.removeAll()
    
        let fetchRequest:NSFetchRequest<Patients> = Patients.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "dateSchedule", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate(format: "(userID = %@) AND (dateSchedule >= %@) AND (dateSchedule <= %@) AND (isRecording == false)", uid as! CVarArg, fromDate, toDate)
        fetchRequest.predicate = predicate
        
        do {
            
            let count = try getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            if count > 0 {
                
                let fetchResult = try getContext().fetch(fetchRequest)
                
                for item in fetchResult {
                    
                    tasks.append(item)
                    tableView.reloadData()
                    checkPatients()
                }
            } else {
                tasks.removeAll()
                tableView.reloadData()
                checkPatients()
            }
            
        }catch {
            print(error.localizedDescription)
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        let selectTask = tasks[indexPath.row]
        defaults.set(selectTask.patientName!, forKey: "PatientName")
        defaults.set(selectTask.patientID!, forKey: "PatientID")
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Dictation") as! selectDictation
        self.present(nextViewController, animated:true, completion:nil)
       
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    func checkPatients(){
        
        if tasks.count == 0 {
         
            noPatients.isHidden = false
            noPatients.text = "No Patients exists in the selected dates."
        
        } else {
            
            noPatients.isHidden = true
            noPatients.text = ""
        }
    }
    
}



