//
//  PatientsVC.swift
//  Medilexis
//
//  Created by iOS Developer on 20/02/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit
import CoreData
import SkyFloatingLabelTextField
import XLActionController

class ScheduledAppointments: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    @IBOutlet var fromTextField: SkyFloatingLabelTextField!
    @IBOutlet var toTextField: SkyFloatingLabelTextField!
    @IBOutlet var firstNameTextField: SkyFloatingLabelTextField!
    @IBOutlet var lastNameTextField: SkyFloatingLabelTextField!
    @IBOutlet var dobTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noPatients: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults.standard
    
    var tasks = [Appointments]()
    var searchController: UISearchController!
    var shouldShowSearchResults = false
    var searchResults:[Appointments] = []
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        self.view.backgroundColor =  UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        self.tableView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        
        // Add a search bar
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Appointments"
        searchController.searchBar.tintColor = UIColor.black
        searchController.searchBar.barTintColor = UIColor(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1.0)
        searchController.searchBar.backgroundImage = UIImage()
        UISearchBar.appearance().tintColor = UIColor.black
        definesPresentationContext = true
        
        tableView.reloadData()
        
        checkPatients()
        
        fromTextField.title = ""
        fromTextField.titleFormatter = { $0 }
        fromTextField.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        self.view.addSubview(fromTextField)
        
        toTextField.title = ""
        toTextField.titleFormatter = { $0 }
        toTextField.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        self.view.addSubview(toTextField)
        
        firstNameTextField.title = ""
        firstNameTextField.titleFormatter = { $0 }
        firstNameTextField.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        self.view.addSubview(firstNameTextField)
        
        lastNameTextField.title = ""
        lastNameTextField.titleFormatter = { $0 }
        lastNameTextField.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        self.view.addSubview(lastNameTextField)
        
        dobTextField.title = ""
        dobTextField.titleFormatter = { $0 }
        dobTextField.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        self.view.addSubview(dobTextField)
        
        let today = NSDate()
        let cal = NSCalendar(calendarIdentifier: NSCalendar.Identifier(rawValue: NSGregorianCalendar))!
        let nextWeek = cal.date(byAdding: NSCalendar.Unit.day, value: -14, to: today as Date, options: NSCalendar.Options.matchLast)
        let previousDate = dateWithOutTime(datDate: nextWeek! as NSDate)
        
        let currentDate = dateWithOutTime(datDate: NSDate())
        defaults.set(previousDate, forKey: "FromDate")
        defaults.set(currentDate, forKey: "ToDate")
        
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "dd MMMM yyyy"
        let date = NSDate()
        let stringOfDate = dateFormate.string(from: date as Date)
        toTextField.text = stringOfDate
        
        let previousDateFormate = DateFormatter()
        previousDateFormate.dateFormat = "dd MMMM yyyy"
        let newFromDate = dateFormate.string(from: previousDate as Date)
        fromTextField.text = newFromDate
        
        let toolBar1 = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        
        toolBar1.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar1.barStyle = UIBarStyle.blackTranslucent
        
        toolBar1.tintColor = UIColor.white
        
        toolBar1.backgroundColor = UIColor.black
        
        
        let defaultButton1 = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ScheduledAppointments.FromDefaultBtn))
        
        let doneButton1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(ScheduledAppointments.selectDoneFromButton))
        
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
        
        
        let defaultButton2 = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ScheduledAppointments.ToDefaultBtn))
        
        let doneButton2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(ScheduledAppointments.DoneToButton))
        
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
        
        
        let defaultButton3 = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.plain, target: self, action: #selector(ScheduledAppointments.selectDefaultBtn))
        
        let doneButton3 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(ScheduledAppointments.selectDoneDateButton))
        
        let flexSpace3 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let label3 = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label3.font = UIFont(name: "FontAwesome", size: 16)
        
        label3.backgroundColor = UIColor.clear
        
        label3.textColor = UIColor.white
        
        label3.text = "Birth Date"
        
        label3.textAlignment = NSTextAlignment.center
        
        let textBtn3 = UIBarButtonItem(customView: label3)
        
        toolBar3.setItems([defaultButton3,flexSpace3,textBtn3,flexSpace3,doneButton3], animated: true)
        
        dobTextField.inputAccessoryView = toolBar3
        
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
    
    func selectDoneDateButton(_ sender: UIBarButtonItem) {
        
        let _ = dobTextField.resignFirstResponder()
        
    }
    
    func selectDefaultBtn(_ sender: UIBarButtonItem) {
        
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "dd MMMM yyyy"
        let date = NSDate()
        let stringOfDate = dateFormate.string(from: date as Date)
        dobTextField.text = stringOfDate
        
        let _ = dobTextField.resignFirstResponder()
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
        dobTextField.text = stringOfDate
        
        datePickerView.addTarget(self, action: #selector(NewAppointment.datePickerDateValueChanged), for: UIControlEvents.valueChanged)
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
            
            let _ = dobTextField.resignFirstResponder()
            
        } else {
            
            dobTextField.text = dateFormatter.string(from: sender.date)
        }
        
    }
    
    @IBAction func fromTextFieldBeginEditing(_ sender: UITextField) {
        
        fromTextField.title = "Start Date"
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datePickerView
        
        datePickerView.addTarget(self, action: #selector(ScheduledAppointments.FromDateValueChanged), for: UIControlEvents.valueChanged)
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
        
        datePickerView.addTarget(self, action: #selector(ScheduledAppointments.ToDateValueChanged), for: UIControlEvents.valueChanged)
    }
  
    func ToDateValueChanged(sender:UIDatePicker){
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "dd MMMM yyyy"
        
        defaults.set(dateWithOutTime(datDate: sender.date as NSDate!), forKey: "ToDate")
        
        toTextField.text = dateFormatter.string(from: sender.date)
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       if searchController.isActive {
            return searchResults.count
        } else {
            return tasks.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Patients", for: indexPath) as! PatientCell
        
        // Determine if we get the restaurant from search result or the original array
        let task = (searchController.isActive) ? searchResults[indexPath.row] : tasks[indexPath.row]
        
        let fullName = task.firstName! + " " + task.lastName!
        cell.patientName?.text = fullName
        cell.appointmentTime.text = task.appointmentTime
        
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

    }
    
    @IBAction func navigateToHome(_ sender: UIBarButtonItem) {
        
        let actionController = YoutubeActionController()
        
        actionController.addAction(Action(ActionData(title: "Home", image: UIImage(named: "home-icon")!), style: .default, handler: { action in
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
            self.present(nextViewController, animated:true, completion:nil)
            
        }))
        actionController.addAction(Action(ActionData(title: "Search", image: UIImage(named: "search")!), style: .default, handler: { action in
            
            self.configureCustomSearchController()
            
        }))
        
        actionController.addAction(Action(ActionData(title: "Cancel", image: UIImage(named: "cancel")!), style: .default, handler: { action in
        }))
        
        present(actionController, animated: true, completion: nil)
        
    }
    
    func configureCustomSearchController() {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Appointments"
        searchController.searchResultsUpdater = self
        searchController.searchBar.sizeToFit()
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.tintColor = UIColor.black
        searchController.searchBar.barTintColor = UIColor(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1.0)
        searchController.searchBar.backgroundImage = UIImage()
        UISearchBar.appearance().tintColor = UIColor.black
        searchController.searchBar.showsCancelButton = true
        
        self.present(searchController, animated: true, completion: nil)
    }
    
    func getContext () -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    
    func getData() {
    
        let todayDate = dateWithOutTime(datDate: NSDate())
        let fromDate = defaults.value(forKey: "FromDate") as! NSDate
        let uid = defaults.value(forKey: "UserID")
        tasks.removeAll()
        
        let fetchRequest:NSFetchRequest<Appointments> = Appointments.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "dateSchedule", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate(format: "(userID = %@) AND (dateSchedule >= %@ AND dateSchedule <= %@) AND (isRecording == false)", uid as! CVarArg, fromDate, todayDate)
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
        
        
        if firstNameTextField.text == "" && lastNameTextField.text == "" && dobTextField.text == "" {
            
            let alert = UIAlertController(title: "Notice", message: "Search with either First Name, Last Name or Dob.", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil);
            
        } else {
            
            
            let uid = defaults.value(forKey: "UserID")
            let fromDate = defaults.value(forKey: "SearchFromDate") as! NSDate
            let toDate = defaults.value(forKey: "SearchToDate") as! NSDate
            
            tasks.removeAll()
            let _ =  fromTextField.resignFirstResponder()
            let _ =  toTextField.resignFirstResponder()
            
            let fetchRequest:NSFetchRequest<Appointments> = Appointments.fetchRequest()
            let sortDescriptor = NSSortDescriptor(key: "dateSchedule", ascending: true)
            fetchRequest.sortDescriptors = [sortDescriptor]
            let predicate = NSPredicate(format: "(userID = %@) AND (dateSchedule >= %@ AND dateSchedule <= %@ AND firstName = %@ || lastName == %@ || dateBirth == %@)", uid as! CVarArg, fromDate, toDate, firstNameTextField.text!, lastNameTextField.text!, dobTextField.text!)
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

        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        let selectTask = tasks[indexPath.row]

        defaults.set(selectTask.firstName!, forKey: "PatientName")
        defaults.set(selectTask.appointmentID!, forKey: "AppointmentID")
        
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
            noPatients.text = "No appointments exists in the selected dates."
        
        } else {
            
            noPatients.isHidden = true
            noPatients.text = ""
        }
    }
    
    // MARK: - Search Controller
    
    func filterContent(for searchText: String) {
        searchResults = tasks.filter({ (task) -> Bool in
            
            if let firstname = task.firstName, let lastname = task.lastName {
                let isMatch = firstname.localizedCaseInsensitiveContains(searchText) || lastname.localizedCaseInsensitiveContains(searchText)
                return isMatch
            }
            
            return false
        })
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            tableView.reloadData()
        }
    }
    
}



