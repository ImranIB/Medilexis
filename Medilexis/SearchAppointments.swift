//
//  SearchPatients.swift
//  Medilexis
//
//  Created by iOS Developer on 05/04/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit
import AWSS3
import AWSCore
import CoreData
import SwiftSpinner
import SkyFloatingLabelTextField
import XLActionController

class SearchAppointments: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var noSearchPatients: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults.standard
    var searchTasks = [Appointments]()
    var searchController: UISearchController!
    var searchResults:[Appointments] = []
    var publicURL: URL!
    var type: String!
    var selection: Bool!
     var filteredSearchAppointments = [Appointments]()
    
    var shouldShowSearchResults = false
    var customSearchController: CustomSearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController = UISearchController(searchResultsController: nil)
        searchTableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = true
        searchController.searchBar.placeholder = "Search Appointments"
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.isTranslucent = false
        searchController.searchBar.barTintColor = UIColor(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1.0)
        UISearchBar.appearance().tintColor = UIColor.black
        definesPresentationContext = true
        
        let today = NSDate()
        let cal = NSCalendar(calendarIdentifier: NSCalendar.Identifier(rawValue: NSGregorianCalendar))!
        let nextWeek = cal.date(byAdding: NSCalendar.Unit.day, value: -14, to: today as Date, options: NSCalendar.Options.matchLast)
        let previousDate = dateWithOutTime(datDate: nextWeek! as NSDate)
        
        self.view.backgroundColor =  UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        self.searchTableView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        
        searchTableView.reloadData()
        
        checkSearchPatients()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if selection == true {
            
            for a in filteredSearchAppointments {
                
                defaults.set(a.firstName, forKey: "FirstName")
                searchTasks.append(a)
                getFilterData()
                checkSearchPatients()
            }
            
        } else {
            
            FetchSearchData()
            checkSearchPatients()
        }
    }
    
    func getFilterData() {
        
        let uid = defaults.value(forKey: "UserID")
        let firstname = defaults.value(forKey: "FirstName") as! String
        
        searchTasks.removeAll()
        
        let fetchRequest:NSFetchRequest<Appointments> = Appointments.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "dateSchedule", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let predicate = NSPredicate(format: "(userID = %@) AND (firstName = %@)", uid as! CVarArg, firstname)
        fetchRequest.predicate = predicate
        
        do {
            let count = try getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            if count > 0 {
                
                let fetchResult = try getContext().fetch(fetchRequest)
                
                for item in fetchResult {
                    
                    searchTasks.append(item)
                    searchTableView.reloadData()
                }
            } else {
                searchTasks.removeAll()
                searchTableView.reloadData()
            }
            
        }catch {
            print(error.localizedDescription)
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive {
            return searchResults.count
        } else {
            return searchTasks.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchPatients", for: indexPath) as! SearchPatientsCell
        
        // Determine if we get the restaurant from search result or the original array
        let task = (searchController.isActive) ? searchResults[indexPath.row] : searchTasks[indexPath.row]
        
        cell.uploadStatus.text = ""
        cell.recordingIcon.image = nil
        cell.transcriptionIcon.image = nil
        cell.upload.setBackgroundImage(nil, for: .normal)
        
        let fullName = task.firstName! + " " + task.lastName!
        cell.patientName?.text = fullName
        
        if let date = task.dateSchedule {
            
            let dateFormate = DateFormatter()
            dateFormate.dateFormat = "dd MMMM yyyy"
            let stringOfDate = dateFormate.string(from: date as Date)
            cell.patientSchedule?.text = stringOfDate
            
        }
        
        if let time = task.appointmentTime {
            
            cell.appointmentTime?.text = time
            
        }
        
        if task.recordingStatus == "true"{
            let image : UIImage = UIImage(named: "track-play-icon")!
            cell.recordingIcon.image = image
            
        }
        
        if task.isRecording == true || task.image != nil || task.anotherImage != nil {
            
            cell.upload.setBackgroundImage(UIImage(named: "sync"), for: UIControlState.normal)
            cell.upload.tag = indexPath.row
            
        }
        
        if task.isTranscribed == true {
            
            let image : UIImage = UIImage(named: "transcribe-icon")!
            cell.transcriptionIcon.image = image
            
        }
        
        if task.isUploading == true {
            cell.uploadStatus.text = "Completed"
            cell.upload.isEnabled = false
        } else {
            
            cell.upload.isEnabled = true
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectTask = searchTasks[indexPath.row]
        
        if selectTask.type == nil {
            
            defaults.set(selectTask.appointmentID!, forKey: "AppointmentID")
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Dictation") as! selectDictation
            self.present(nextViewController, animated:true, completion:nil)
            
        } else if selectTask.type == "Letter" {
            
            
            let fetchRequest:NSFetchRequest<Sounds> = Sounds.fetchRequest()
            let predicate = NSPredicate(format: "(appointmentID = %@)", selectTask.appointmentID!)
            fetchRequest.predicate = predicate
            
            do {
                
                let fetchResult = try getContext().fetch(fetchRequest)
                
                for item in fetchResult {
                    
                    defaults.set(item.appointmentID!, forKey: "AppointmentID")
                    defaults.set(item.recordingName, forKey: "RecordingName")
                    defaults.set(item.transcription, forKey: "Transcription")
                    defaults.set(selectTask.firstName, forKey: "PatientName")
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
            let predicate = NSPredicate(format: "(appointmentID = %@) AND (type = %@)", selectTask.appointmentID!, type)
            fetchRequest.predicate = predicate
            
            do {
                
                let count = try getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
                
                if count > 0 {
                    
                    let fetchResult = try getContext().fetch(fetchRequest)
                    
                    for item in fetchResult {
                        
                        defaults.set(item.appointmentID!, forKey: "AppointmentID")
                        defaults.set(selectTask.firstName, forKey: "PatientName")
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
        
       // let todayDate = dateWithOutTime(datDate: NSDate())
        //let fromDate = defaults.value(forKey: "SearchFromDate") as! NSDate
        let uid = defaults.value(forKey: "UserID")
        searchTasks.removeAll()
        
        let fetchRequest:NSFetchRequest<Appointments> = Appointments.fetchRequest()
        let sortDescriptorTime = NSSortDescriptor(key: "appointmentTime", ascending: false)
        let sortDescriptor = NSSortDescriptor(key: "dateSchedule", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor, sortDescriptorTime]
        let predicate = NSPredicate(format: "(userID = %@)", uid as! CVarArg)
        fetchRequest.predicate = predicate
        
        do {
            let count = try getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            if count > 0 {
                
                let fetchResult = try getContext().fetch(fetchRequest)
                
                for item in fetchResult {
                    
                    searchTasks.append(item)
                    searchTableView.reloadData()
                    //checkSearchPatients()
                }
            } else {
                searchTasks.removeAll()
                searchTableView.reloadData()
                //checkSearchPatients()
            }
            
        }catch {
            print(error.localizedDescription)
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
            
            self.noSearchPatients.isHidden = true
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "filterSearch") as! FilterSearchAppointments
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
    
    // MARK: - Search Controller
    
    func filterContent(for searchText: String) {
        searchResults = searchTasks.filter({ (task) -> Bool in
            
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
            searchTableView.reloadData()
        }
    }
    
    func dateWithOutTime( datDate: NSDate) -> NSDate {
        let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
        calendar.timeZone = NSTimeZone(forSecondsFromGMT: 0) as TimeZone
        return calendar.startOfDay(for: datDate as Date) as (Date) as NSDate
    }
    
    func checkSearchPatients(){
        
        if searchTasks.count == 0 {
            
            noSearchPatients.isHidden = false
            noSearchPatients.text = "No appointments exists in the selected dates."
            
        } else {
            
            noSearchPatients.isHidden = true
            noSearchPatients.text = ""
        }
    }
    
    @IBAction func syncData(_ sender: UIButton) {
        
        let username = defaults.value(forKey: "Username") as? String
        
        if currentReachabilityStatus == .reachableViaWiFi ||  currentReachabilityStatus == .reachableViaWWAN {
            
            let buttonRow = sender.tag
            let detail = searchTasks[buttonRow]
            
            let fetchRequest:NSFetchRequest<Appointments> = Appointments.fetchRequest()
            let predicate = NSPredicate(format: "(appointmentID = %@)", detail.appointmentID!)
            fetchRequest.predicate = predicate
            
            do {
                let fetchResult = try getContext().fetch(fetchRequest)
                
                for item in fetchResult {
                    
                    if item.isUploading == false {
                        
                        let alert = UIAlertController(title: "Sync Data", message: "This will sync the patient encounter with the server. Do you wish to continue?", preferredStyle: UIAlertControllerStyle.alert)
                        
                        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler:{ action in
                            
                            let fetchRequest:NSFetchRequest<Appointments> = Appointments.fetchRequest()
                            let predicate = NSPredicate(format: "(appointmentID = %@)", detail.appointmentID!)
                            fetchRequest.predicate = predicate
                            self.defaults.set(detail.appointmentID!, forKey: "AppointmentID")
                            
                            do {
                                let fetchResult = try self.getContext().fetch(fetchRequest)
                                
                                for item in fetchResult {
                                    
                                    SwiftSpinner.show("Uploading patient encounter to server")
                                    
                                    let fetchRequest:NSFetchRequest<Sounds> = Sounds.fetchRequest()
                                    
                                    let predicate = NSPredicate(format: "(appointmentID = %@)", item.appointmentID!)
                                    
                                    fetchRequest.predicate = predicate
                                    
                                    do {
                                        let fetchResult = try self.getContext().fetch(fetchRequest)
                                        
                                        for item in fetchResult {
                                            
                                            
                                            let fileManager = FileManager.default
                                            let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
                                            let documentsDirectoryURL: URL = urls.first!
                                            let audioURL = documentsDirectoryURL.appendingPathComponent(item.recordingName! + ".m4a")
                                            
                                            // Configure AWS Cognito Credentials
                                            let myIdentityPoolId = "us-west-2:567c2436-bfc7-41ee-9a62-8efa08645dc2"
                                            
                                            let credentialsProvider:AWSCognitoCredentialsProvider = AWSCognitoCredentialsProvider(regionType:AWSRegionType.usWest2, identityPoolId: myIdentityPoolId)
                                            
                                            let configuration = AWSServiceConfiguration(region:AWSRegionType.usWest2, credentialsProvider:credentialsProvider)
                                            
                                            AWSServiceManager.default().defaultServiceConfiguration = configuration
                                            
                                            let S3BucketName = "medilexis"
                                            let remoteName = username! + "/" + item.recordingName!
                                            let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(remoteName)
                                            
                                            let uploadRequest = AWSS3TransferManagerUploadRequest()!
                                            uploadRequest.body = audioURL
                                            uploadRequest.key =  remoteName
                                            uploadRequest.bucket = S3BucketName
                                            uploadRequest.contentType = "audio/mpeg"
                                            uploadRequest.acl = .publicRead
                                            
                                            let transferManager = AWSS3TransferManager.default()
                                            transferManager?.upload(uploadRequest).continue({ [weak self] (task: AWSTask<AnyObject>) -> Any? in
                                                
                                                if let error = task.error {
                                                    print("Upload failed with error: (\(error.localizedDescription))")
                                                }
                                                if let exception = task.exception {
                                                    print("Upload failed with exception (\(exception))")
                                                }
                                                
                                                if task.result != nil {
                                                    let url = AWSS3.default().configuration.endpoint.url
                                                    self?.publicURL = url?.appendingPathComponent(uploadRequest.bucket!).appendingPathComponent(uploadRequest.key!)
                                                    // print("Uploaded to:\(self?.publicURL)")
                                                    
                                                    ///update into encounter
                                                    
                                                    let AppointmentId = self?.defaults.value(forKey: "AppointmentID")
                                                    let serverUrlString: String = self!.publicURL!.absoluteString
                                                    
                                                    let encounterFetchRequest:NSFetchRequest<Encounter> = Encounter.fetchRequest()
                                                    let encounterPredicate = NSPredicate(format: "(appointmentID = %@)", AppointmentId as! CVarArg)
                                                    encounterFetchRequest.predicate = encounterPredicate
                                                    
                                                    do {
                                                        let count = try self?.getContext().count(for: encounterFetchRequest as! NSFetchRequest<NSFetchRequestResult>)
                                                        
                                                        if count! > 0 {
                                                            
                                                            let fetchResult = try self?.context.fetch(encounterFetchRequest)
                                                            
                                                            for data in fetchResult! {
                                                                
                                                                if item.type == "Letter"{
                                                                    
                                                                    data.letterServerURL = serverUrlString
                                                                    
                                                                } else if item.type  == "CC" {
                                                                    
                                                                    data.ccServerURL = serverUrlString
                                                                    
                                                                } else if item.type  == "HPI" {
                                                                    
                                                                    data.hpiServerURL = serverUrlString
                                                                    
                                                                }else if item.type  == "HX" {
                                                                    
                                                                    data.hxServerURL = serverUrlString
                                                                    
                                                                }else if item.type  == "ROS" {
                                                                    
                                                                    data.rosServerURL = serverUrlString
                                                                    
                                                                }else if item.type  == "PLAN" {
                                                                    
                                                                    data.planServerURL = serverUrlString
                                                                }
                                                                
                                                                
                                                                try self?.context.save()
                                                                
                                                            }
                                                            
                                                            
                                                        } else {
                                                            
                                                            print("no record")
                                                        }
                                                    }catch {
                                                        print(error.localizedDescription)
                                                    }
                                                    
                                                    ///update into patients
                                                    let AppointmentID = self?.defaults.value(forKey: "AppointmentID") as! String
                                                    let fetchRequest:NSFetchRequest<Appointments> = Appointments.fetchRequest()
                                                    
                                                    let predicate = NSPredicate(format: "(appointmentID = %@)", AppointmentID as CVarArg)
                                                    fetchRequest.predicate = predicate
                                                    
                                                    do {
                                                        let fetchResult = try self?.context.fetch(fetchRequest)
                                                        
                                                        for item in fetchResult! {
                                                            
                                                            item.isUploading = true
                                                            
                                                            try self?.context.save()
                                                            
                                                        }
                                                        
                                                        DispatchQueue.main.async {
                                                            
                                                            SwiftSpinner.hide()
                                                            self?.searchTableView.reloadData()
                                                            //self?.FetchObject()
                                                          
                                                        }
                                                        
                                                    }catch {
                                                        print(error.localizedDescription)
                                                    }
                                                    
                                                }
                                                
                                                return nil
                                            })
                                            
                                        }
                                        
                                        // self.uploadImages()
                                        
                                    }catch {
                                        print(error.localizedDescription)
                                    }
                                    
                                }
                            }catch {
                                print(error.localizedDescription)
                            }
                            
                        }))
                        
                        let no = UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: dismiss)
                        alert.addAction(no)
                        
                        self.present(alert, animated: true, completion: nil);
                        
                    }
                }
                
                   self.uploadImages()
                
                
            }catch {
                print(error.localizedDescription)
            }
            
        } else {
            
            DispatchQueue.main.async {
                
                let alert = UIAlertController(title: "No Connection", message: "Please check your internet connection and try again!", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil);
            }
        }
        
    }
    
    func dismiss(alert: UIAlertAction){
        searchTableView.reloadData()
    }
    
    func uploadImages(){
        
        let appointmentID = self.defaults.value(forKey: "AppointmentID")
      //  let username = defaults.value(forKey: "Username") as? String
        
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        let newFile = formatter.string(from: currentDateTime)+""
        let fileName = newFile + ".png"
        
        let myIdentityPoolId = "us-west-2:567c2436-bfc7-41ee-9a62-8efa08645dc2"
        
        let credentialsProvider:AWSCognitoCredentialsProvider = AWSCognitoCredentialsProvider(regionType:AWSRegionType.usWest2, identityPoolId: myIdentityPoolId)
        
        let configuration = AWSServiceConfiguration(region:AWSRegionType.usWest2, credentialsProvider:credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        let fetchRequest:NSFetchRequest<Appointments> = Appointments.fetchRequest()
        let predicate = NSPredicate(format: "(appointmentID = %@)", appointmentID as! CVarArg)
        fetchRequest.predicate = predicate
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            
            for item in fetchResult {
                
                if item.image != nil {
                    
                    let S3BucketName = "medilexis"
                    let remoteName = fileName
                    let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(remoteName)
                    let imageData = UIImage(data:item.image! as Data , scale:1.0)
                    let data = UIImagePNGRepresentation(imageData!)
                    do {
                        try data?.write(to: fileURL)
                    }
                    catch {}
                    
                    let uploadRequest = AWSS3TransferManagerUploadRequest()!
                    uploadRequest.body = fileURL
                    uploadRequest.key = remoteName
                    uploadRequest.bucket = S3BucketName
                    uploadRequest.contentType = "image/jpeg/png"
                    uploadRequest.acl = .publicRead
                    
                    let transferManager = AWSS3TransferManager.default()
                    transferManager?.upload(uploadRequest).continue({ [weak self] (task: AWSTask<AnyObject>) -> Any? in
                        
                        if let error = task.error {
                            print("Upload failed with error: (\(error.localizedDescription))")
                        }
                        if let exception = task.exception {
                            print("Upload failed with exception (\(exception))")
                        }
                        
                        if task.result != nil {
                            let url = AWSS3.default().configuration.endpoint.url
                            let image1URL = url?.appendingPathComponent(uploadRequest.bucket!).appendingPathComponent(uploadRequest.key!)
                            // print("Uploaded to:\(image1URL)")
                            
                            // Update Image Url in Encounter
                            
                            let appointmentID = self?.defaults.value(forKey: "AppointmentID")
                            let serverUrlString: String = image1URL!.absoluteString
                            
                            let encounterFetchRequest:NSFetchRequest<Encounter> = Encounter.fetchRequest()
                            let encounterPredicate = NSPredicate(format: "(appointmentID = %@)", appointmentID as! CVarArg)
                            fetchRequest.predicate = encounterPredicate
                            
                            do {
                                let count = try self?.getContext().count(for: encounterFetchRequest as! NSFetchRequest<NSFetchRequestResult>)
                                
                                if count! > 0 {
                                    
                                    let fetchResult = try self?.context.fetch(encounterFetchRequest)
                                    
                                    for item in fetchResult! {
                                        
                                        item.serverImage1 = serverUrlString
                                    }
                                    
                                } else {
                                    
                                    print("no record")
                                }
                            }catch {
                                print(error.localizedDescription)
                            }
                            
                            ///update into patients
                            
                            let fetchRequest:NSFetchRequest<Appointments> = Appointments.fetchRequest()
                            
                            let predicate = NSPredicate(format: "(appointmentID = %@)", appointmentID as! CVarArg)
                            fetchRequest.predicate = predicate
                            
                            do {
                                let fetchResult = try self?.context.fetch(fetchRequest)
                                
                                for item in fetchResult! {
                                    
                                    item.isUploading = true
                                    
                                    try self?.context.save()
                                    
                                }
                                
                            }catch {
                                print(error.localizedDescription)
                            }
                            
                        }
                        
                        return nil
                    })
                    
                } else {
                    DispatchQueue.main.async {
                        SwiftSpinner.hide()
                        self.searchTableView.reloadData()
                        self.anotherImage()
                        return
                    }
                }
                
                
            }
            
             self.anotherImage()
            
        }catch {
            print(error.localizedDescription)
        }
        
        
    }
    
    func anotherImage(){
        
        print("another image")
        
        let AppointmentId = self.defaults.value(forKey: "AppointmentID")
        //let username = defaults.value(forKey: "Username") as? String
        
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        let newFile = formatter.string(from: currentDateTime)+""
        let fileName = newFile + ".png"
        
        let myIdentityPoolId = "us-west-2:567c2436-bfc7-41ee-9a62-8efa08645dc2"
        
        let credentialsProvider:AWSCognitoCredentialsProvider = AWSCognitoCredentialsProvider(regionType:AWSRegionType.usWest2, identityPoolId: myIdentityPoolId)
        
        let configuration = AWSServiceConfiguration(region:AWSRegionType.usWest2, credentialsProvider:credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
        
        let fetchRequest:NSFetchRequest<Appointments> = Appointments.fetchRequest()
        let predicate = NSPredicate(format: "(appointmentID = %@)", AppointmentId as! CVarArg)
        fetchRequest.predicate = predicate
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            
            for item in fetchResult {
                
                if item.anotherImage != nil {
                    
                    let S3BucketName = "medilexis"
                    let remoteName = fileName
                    let fileURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(remoteName)
                    let imageData = UIImage(data:item.anotherImage! as Data , scale:1.0)
                    let data = UIImagePNGRepresentation(imageData!)
                    do {
                        try data?.write(to: fileURL)
                    }
                    catch {}
                    
                    let uploadRequest = AWSS3TransferManagerUploadRequest()!
                    uploadRequest.body = fileURL
                    uploadRequest.key = remoteName
                    uploadRequest.bucket = S3BucketName
                    uploadRequest.contentType = "image/jpeg/png"
                    uploadRequest.acl = .publicRead
                    
                    let transferManager = AWSS3TransferManager.default()
                    transferManager?.upload(uploadRequest).continue({ [weak self] (task: AWSTask<AnyObject>) -> Any? in
                        
                        if let error = task.error {
                            print("Upload failed with error: (\(error.localizedDescription))")
                        }
                        if let exception = task.exception {
                            print("Upload failed with exception (\(exception))")
                        }
                        
                        if task.result != nil {
                            let url = AWSS3.default().configuration.endpoint.url
                            let image2URL = url?.appendingPathComponent(uploadRequest.bucket!).appendingPathComponent(uploadRequest.key!)
                            //print("Uploaded to:\(publicURL)")
                            
                            
                            // Update Image Url in Encounter
                            
                            let AppointmentId = self?.defaults.value(forKey: "AppointmentID")
                            let serverUrlString: String = image2URL!.absoluteString
                            
                            let encounterFetchRequest:NSFetchRequest<Encounter> = Encounter.fetchRequest()
                            let encounterPredicate = NSPredicate(format: "(appointmentID = %@)", AppointmentId as! CVarArg)
                            fetchRequest.predicate = encounterPredicate
                            
                            do {
                                let count = try self?.getContext().count(for: encounterFetchRequest as! NSFetchRequest<NSFetchRequestResult>)
                                
                                if count! > 0 {
                                    
                                    let fetchResult = try self?.context.fetch(encounterFetchRequest)
                                    
                                    for item in fetchResult! {
                                        
                                        item.serverImage2 = serverUrlString
                                    }
                                    
                                } else {
                                    
                                    print("no record")
                                }
                            }catch {
                                print(error.localizedDescription)
                            }
                            
                            ///update into appointments
                            let appointmentID = self?.defaults.value(forKey: "AppointmentID")
                            let fetchRequest:NSFetchRequest<Appointments> = Appointments.fetchRequest()
                            
                            let predicate = NSPredicate(format: "(appointmentID = %@)", appointmentID as! CVarArg)
                            fetchRequest.predicate = predicate
                            
                            do {
                                let fetchResult = try self?.context.fetch(fetchRequest)
                                
                                for item in fetchResult! {
                                    
                                    item.isUploading = true
                                    
                                    try self?.context.save()
                                    
                                    
                                    
                                }
                            }catch {
                                print(error.localizedDescription)
                            }
                        }
                        
                        return nil
                    })
                    
                } else {
                    DispatchQueue.main.async {
                        
                        SwiftSpinner.hide()
                        self.searchTableView.reloadData()
                        self.FetchObject()
                        return
                    }
                }
                
                
            }
        }catch {
            print(error.localizedDescription)
        }
        
        
    }
    
    func FetchObject(){
        
        let AppointmentId = self.defaults.value(forKey: "AppointmentID")
        
        let fetchRequest:NSFetchRequest<Encounter> = Encounter.fetchRequest()
        let predicate = NSPredicate(format: "(appointmentID = %@)", AppointmentId as! CVarArg)
        fetchRequest.predicate = predicate
        
        do {
            let count = try getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            if count > 0 {
                
                let fetchResult = try context.fetch(fetchRequest)
                
                for item in fetchResult {
                    
                    let Object = [
                        "Details" : [
                            "UserID" : item.userID,
                            "AppointmentID" : item.appointmentID!,
                        ],
                        "Letter" : [
                            "RecordingName" : item.letterRecordingName!,
                            "RecordingURL" : item.letterServerURL!,
                            "Type" : item.recordingTypeLetter!,
                            "Transcription" : item.letterTranscription!,
                        ],
                        "Chart Note": [ "CC" : [
                            "RecordingName" : item.ccRecordingName!,
                            "RecordingURL" : item.ccServerURL!,
                            "Type" : item.recordingType1!,
                            "Transcription" : item.ccTranscription!,
                            ], "HPI" : [
                                "RecordingName" : item.hpiRecordingName!,
                                "RecordingURL" : item.hpiServerURL!,
                                "Type" : item.recordingType2!,
                                "Transcription" : item.hpiTranscription!,
                            ], "HX" : [
                                "RecordingName" : item.hxRecordingName!,
                                "RecordingURL" : item.hxServerURL!,
                                "Type" : item.recordingType3!,
                                "Transcription" : item.hxTranscription!,
                            ], "ROS" : [
                                "RecordingName" : item.rosRecordingName!,
                                "RecordingURL" : item.rosServerURL!,
                                "Type" : item.recordingType4!,
                                "Transcription" : item.rosTranscription!,
                            ], "PLAN" : [
                                "RecordingName" : item.planRecordingName!,
                                "RecordingURL" : item.planServerURL!,
                                "Type" : item.recordingType5!,
                                "Transcription" : item.planTranscription!,
                            ]],
                        "Images" : [
                            "Image1" : item.serverImage1!,
                            "Image2" : item.serverImage2!,
                        ], "Medicines" : [
                            "MedicineName" : item.medicineName!,
                        ], "Cpt" : [
                            "CptName" : item.cptDescription!,
                            "CptCode" : item.cptCode!,
                        ], "DX" : [
                            "DxName" : item.dxDescription!,
                            "DxCode" : item.dxCode!,
                        ]
                    ]
                    
                    print(Object)
                }
                
            } else {
                
                print("no record")
            }
        }catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    
}

