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
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noPatients: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults.standard
    
    var tasks = [Appointments]()
    var searchController: UISearchController!
    var shouldShowSearchResults = false
    var searchResults:[Appointments] = []
    var selection: Bool!
    var filteredAppointments = [Appointments]()
    
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        self.view.backgroundColor =  UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        self.tableView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        
        // Add a search bar
        searchController = UISearchController(searchResultsController: nil)
        tableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search Appointments"
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.isTranslucent = false
        searchController.searchBar.barTintColor = UIColor(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1.0)
        UISearchBar.appearance().tintColor = UIColor.black
        definesPresentationContext = true
        
        tableView.reloadData()
        
        checkPatients()
        
        let today = NSDate()
        let cal = NSCalendar(calendarIdentifier: NSCalendar.Identifier(rawValue: NSGregorianCalendar))!
        let nextWeek = cal.date(byAdding: NSCalendar.Unit.day, value: -14, to: today as Date, options: NSCalendar.Options.matchLast)
        let previousDate = dateWithOutTime(datDate: nextWeek! as NSDate)
        
        let currentDate = dateWithOutTime(datDate: NSDate())
        defaults.set(previousDate, forKey: "FromDate")
        defaults.set(currentDate, forKey: "ToDate")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if selection == true {
            
            for a in filteredAppointments {
                
                defaults.set(a.firstName, forKey: "FirstName")
                tasks.append(a)
                getFilterData()
                checkPatients()
            }
       
        } else {
            
            getData()
            checkPatients()
        }

    }
    
    @IBAction func navigateToHome(_ sender: UIBarButtonItem) {
        
        let actionController = YoutubeActionController()
        
        actionController.addAction(Action(ActionData(title: "Home", image: UIImage(named: "home-icon")!), style: .default, handler: { action in
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
            self.present(nextViewController, animated:true, completion:nil)
            
        }))
        actionController.addAction(Action(ActionData(title: "Advanced Search", image: UIImage(named: "search")!), style: .default, handler: { action in
            
            self.noPatients.isHidden = true
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "filterScheduled") as! FilterScheduledAppointments
            self.present(nextViewController, animated:true, completion:nil)
            
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
    
        let uid = defaults.value(forKey: "UserID")
        tasks.removeAll()
        
        let fetchRequest:NSFetchRequest<Appointments> = Appointments.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "dateSchedule", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate(format: "(userID = %@) AND (isRecording == false)", uid as! CVarArg)
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
    
    func getFilterData() {
        
        let uid = defaults.value(forKey: "UserID")
        let firstname = defaults.value(forKey: "FirstName") as! String
        
        tasks.removeAll()
        
        let fetchRequest:NSFetchRequest<Appointments> = Appointments.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "dateSchedule", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate(format: "(userID = %@) AND (isRecording == false) AND (firstName = %@)", uid as! CVarArg, firstname)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      
        let selectTask = tasks[indexPath.row]

        defaults.set(selectTask.dateSchedule, forKey: "DOS")
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



