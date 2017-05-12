//
//  SearchPatients.swift
//  Medilexis
//
//  Created by iOS Developer on 05/04/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit
import CoreData
import SkyFloatingLabelTextField

class SearchPatients: UIViewController, UITableViewDataSource, UITableViewDelegate {

    

    @IBOutlet weak var fromTextField: SkyFloatingLabelTextFieldWithIcon!
 
    @IBOutlet weak var toTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var noSearchPatients: UILabel!
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults.standard
    var searchTasks = [Patients]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchTableView.reloadData()
        
        self.view.backgroundColor =  UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        self.searchTableView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        
        fromTextField.iconFont = UIFont(name: "FontAwesome", size: 12)
        fromTextField.iconText = "\u{f274}"
        fromTextField.iconColor = UIColor.lightGray
        fromTextField.title = ""
        fromTextField.titleFormatter = { $0 }
        fromTextField.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        fromTextField.iconMarginBottom = 1.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        fromTextField.iconMarginLeft = 2.0
        self.view.addSubview(fromTextField)
        
        toTextField.iconFont = UIFont(name: "FontAwesome", size: 11)
        toTextField.iconText = "\u{f274}"
        toTextField.iconColor = UIColor.lightGray
        toTextField.title = ""
        toTextField.titleFormatter = { $0 }
        toTextField.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        toTextField.iconMarginBottom = 1.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        toTextField.iconMarginLeft = 2.0
        self.view.addSubview(toTextField)
        
        let currentDate = dateWithOutTime(datDate: NSDate())
        defaults.set(currentDate, forKey: "SearchFromDate")
        defaults.set(currentDate, forKey: "SearchToDate")
        
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
        
        
        let defaultButton1 = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SearchPatients.FromDefaultBtn))
        
        let doneButton1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(SearchPatients.selectDoneFromButton))
        
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
        
        
        let defaultButton2 = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.plain, target: self, action: #selector(SearchPatients.ToDefaultBtn))
        
        let doneButton2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(SearchPatients.DoneToButton))
        
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
    
    func FromDefaultBtn(_ sender: UIBarButtonItem) {
        
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "dd MMMM yyyy"
        let date = NSDate()
        let stringOfDate = dateFormate.string(from: date as Date)
        fromTextField.text = stringOfDate
        
        let todayDate = dateWithOutTime(datDate: NSDate())
        defaults.set(todayDate, forKey: "SearchFromDate")
        
        let _ = fromTextField.resignFirstResponder()
    }
    
    func ToDefaultBtn(_ sender: UIBarButtonItem) {
        
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "dd MMMM yyyy"
        let date = NSDate()
        let stringOfDate = dateFormate.string(from: date as Date)
        toTextField.text = stringOfDate
        
        let todayDate = dateWithOutTime(datDate: NSDate())
        defaults.set(todayDate, forKey: "SearchToDate")
        
        let _ = toTextField.resignFirstResponder()
    }
    
    func selectDoneFromButton(_ sender: UIBarButtonItem) {
        
        let _ = fromTextField.resignFirstResponder()
        
    }
    
    func DoneToButton(_ sender: UIBarButtonItem) {
        
        let _ = toTextField.resignFirstResponder()
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
         return searchTasks.count
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchPatients", for: indexPath) as! SearchPatientsCell
        
        let task = searchTasks[indexPath.row]
        
        if let myName = task.patientName {
            cell.patientName?.text = myName
            
        }
        
        if let date = task.dateSchedule {
            
            let dateFormate = DateFormatter()
            dateFormate.dateFormat = "dd MMMM yyyy"
            let stringOfDate = dateFormate.string(from: date as Date)
            cell.patientSchedule?.text = stringOfDate
            
        }
        
       if task.recordingStatus == "true"{
            let image : UIImage = UIImage(named: "track-play-icon")!
            cell.recordingIcon.image = image
        }
        
        if task.isTranscribed == true {
            
            let image : UIImage = UIImage(named: "transcribe-icon")!
            cell.transcriptionIcon.image = image
            
        }
        return cell
        
        
   }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectTask = searchTasks[indexPath.row]
        
        if selectTask.type == nil {
            
            defaults.set(selectTask.patientID!, forKey: "PatientID")
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Dictation") as! selectDictation
            self.present(nextViewController, animated:true, completion:nil)
        
        } else if selectTask.type == "Letter" {
            
            
            let fetchRequest:NSFetchRequest<Sounds> = Sounds.fetchRequest()
            let predicate = NSPredicate(format: "(patientID = %@)", selectTask.patientID!)
            fetchRequest.predicate = predicate
            
            do {
                    
                    let fetchResult = try getContext().fetch(fetchRequest)
                    
                    for item in fetchResult {
                  
                        defaults.set(item.patientID!, forKey: "PatientID")
                        defaults.set(item.recordingName, forKey: "RecordingName")
                        defaults.set(item.transcription, forKey: "Transcription")
                        defaults.set(selectTask.patientName, forKey: "PatientName")
                        defaults.set(selectTask.dateBirth, forKey: "DOB")
                        defaults.set(selectTask.dateSchedule, forKey: "DOS")
                        
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RecordingPlay") as! RecordingPlayback
                        self.present(nextViewController, animated:true, completion:nil)
                        
                    }
               
                
            }catch {
                print(error.localizedDescription)
            }
            
            
        } else if selectTask.type == "Chart" {
            
            let type = "CC"
            let fetchRequest:NSFetchRequest<Sounds> = Sounds.fetchRequest()
            let predicate = NSPredicate(format: "(patientID = %@) AND (type = %@)", selectTask.patientID!, type)
            fetchRequest.predicate = predicate
            
            do {
                
                let count = try getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
                
                if count > 0 {
                    
                    let fetchResult = try getContext().fetch(fetchRequest)
                    
                    for item in fetchResult {
                        
                        defaults.set(item.patientID!, forKey: "PatientID")
                        defaults.set(selectTask.patientName, forKey: "PatientName")
                        defaults.set(selectTask.dateBirth, forKey: "DOB")
                        defaults.set(selectTask.dateSchedule, forKey: "DOS")
                        defaults.set(item.recordingName, forKey: "RecordingName")
                        //defaults.set(item.transcription, forKey: "Transcription")
                        
                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PlaybackTabBar") as! UITabBarController
                        self.present(nextViewController, animated:true, completion:nil)
                        
                    }
                    
                } else {
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "PlaybackTabBar") as! UITabBarController
                    self.present(nextViewController, animated:true, completion:nil)
                }
                
                
                
            }catch {
                print(error.localizedDescription)
            }
            
          
        }
    }
    
    func getContext () -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func FetchSearchData() {
        
        let todayDate = dateWithOutTime(datDate: NSDate())
        let uid = defaults.value(forKey: "UserID")
        searchTasks.removeAll()
        
        let fetchRequest:NSFetchRequest<Patients> = Patients.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "dateSchedule", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate(format: "(userID = %@) AND (dateSchedule = %@)", uid as! CVarArg, todayDate)
        fetchRequest.predicate = predicate
        
        do {
            let count = try getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            if count > 0 {
                
                let fetchResult = try getContext().fetch(fetchRequest)
                
                for item in fetchResult {
                    
                    searchTasks.append(item)
                    searchTableView.reloadData()
                    checkSearchPatients()
                }
            } else {
                searchTasks.removeAll()
                searchTableView.reloadData()
                checkSearchPatients()
            }
            
        }catch {
            print(error.localizedDescription)
        }
        
    }
    
    @IBAction func fromTextFieldBeginEditing(_ sender: UITextField) {
        
         fromTextField.title = "Start Date"
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(SearchPatients.FromDateValueChanged), for: UIControlEvents.valueChanged)
        
    }
    
    func FromDateValueChanged(sender:UIDatePicker){
        
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd MMMM yyyy"
        
        defaults.set(dateWithOutTime(datDate: sender.date as NSDate!), forKey: "SearchFromDate")
        
        fromTextField.text = dateFormatter.string(from: sender.date)
        
    }
    
    @IBAction func toTextFieldBeginEditing(_ sender: UITextField) {
        
         toTextField.title = "End Date"
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(SearchPatients.ToDateValueChanged), for: UIControlEvents.valueChanged)
    }
   
    
    func ToDateValueChanged(sender:UIDatePicker){
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd MMMM yyyy"
        
        defaults.set(dateWithOutTime(datDate: sender.date as NSDate!), forKey: "SearchToDate")
        
        toTextField.text = dateFormatter.string(from: sender.date)
        
    }
    
    @IBAction func searchPatients(_ sender: UIButton) {
        
        let uid = defaults.value(forKey: "UserID")
        let fromDate = defaults.value(forKey: "SearchFromDate") as! NSDate
        let toDate = defaults.value(forKey: "SearchToDate") as! NSDate
        
        searchTasks.removeAll()
        let _ =  fromTextField.resignFirstResponder()
        let _ =  toTextField.resignFirstResponder()
        
        let fetchRequest:NSFetchRequest<Patients> = Patients.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "dateSchedule", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate(format: "(userID = %@) AND (dateSchedule >= %@) AND (dateSchedule <= %@)", uid as! CVarArg, fromDate, toDate)
        fetchRequest.predicate = predicate
        
        do {
            
            let count = try getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            if count > 0 {
                
                let fetchResult = try getContext().fetch(fetchRequest)
                
                for item in fetchResult {
                    
                    searchTasks.append(item)
                    searchTableView.reloadData()
                    checkSearchPatients()
                }
            } else {
                searchTasks.removeAll()
                searchTableView.reloadData()
                checkSearchPatients()
            }
            
        }catch {
            print(error.localizedDescription)
        }
        
    }
    
    @IBAction func navigateToHome(_ sender: UIBarButtonItem) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        searchTableView.reloadData()
        FetchSearchData()
        
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "dd MMMM yyyy"
        let date = NSDate()
        let stringOfDate = dateFormate.string(from: date as Date)
        fromTextField.text = stringOfDate
        toTextField.text = stringOfDate
    }
    
    func dateWithOutTime( datDate: NSDate) -> NSDate {
        let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
        calendar.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone
        return calendar.startOfDay(for: datDate as Date) as (Date) as NSDate
    }
    
    func checkSearchPatients(){
        
        if searchTasks.count == 0 {
            
            noSearchPatients.isHidden = false
            noSearchPatients.text = "No Patients exists in the selected dates."
            
        } else {
            
            noSearchPatients.isHidden = true
            noSearchPatients.text = ""
        }
    }

}