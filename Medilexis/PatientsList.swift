//
//  PatientsList.swift
//  Medilexis
//
//  Created by iOS Developer on 07/07/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit
import CoreData
import XLActionController

class PatientsList: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate, CustomSearchControllerDelegate {
    
    @IBOutlet var patientsList: UITableView!
    @IBOutlet var noPatientLabel: UILabel!
    @IBOutlet var searchPatients: UINavigationItem!
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults.standard
    var searchTasks = [Patients]()
    var searchController: UISearchController!
    var searchResults:[Patients] = []
    var patientsArray = [PatientModel]()
    
    var shouldShowSearchResults = false
    var customSearchController: CustomSearchController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor =  UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        self.patientsList.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        
        FetchPatientsList()
        configureCustomSearchController()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Home(_ sender: UIBarButtonItem) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if shouldShowSearchResults {
            return searchResults.count
        }
        else {
            return searchTasks.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PatientsLists", for: indexPath) as! PatientsListCell

        
        if shouldShowSearchResults {
            let task = searchResults[indexPath.row]
            let fullName = task.firstName! + " " + task.lastName!
            cell.nameLabel.text = fullName
            cell.dobLabel.text = task.dateBirth
            cell.phoneLabel.text = task.phone
        }
        else {
            let task = searchTasks[indexPath.row]
            let fullName = task.firstName! + " " + task.lastName!
            cell.nameLabel.text = fullName
            cell.dobLabel.text = task.dateBirth
            cell.phoneLabel.text = task.phone
        
        }
        
        return cell
        
    }

    func getContext () -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func FetchPatientsList() {
        
        let uid = defaults.value(forKey: "UserID")
        
       /* let url = URL(string: "http://muapp.com/medilixis_server/public/getselectedapppatient")!
        let jsonDict = ["id": uid, "token": "eRVmcwbtMqQfRZprBqn7N1vZNuvXrrxB"] as [String : Any]
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
                //print("json:", json)
                
                let responses = json["data"] as? [[String: Any]]
               
                if (responses?.count)! > 0 {
                    
                    for response in responses! {
                        
                        let patientID = response["id"] as? Int
                        let firstname = response["first_name"] as? String
                        let lastname = response["last_name"] as? String
                        let dob = response["date_of_birth"] as? String
                        let phone = response["phone"] as? String
                        
                        let data = PatientModel(id: patientID!, firstname: firstname!, lastname: lastname!, dob: dob!, phone: phone!)
                        self.patientsArray.append(data)
                        
                        DispatchQueue.main.async {
                            self.patientsList.reloadData()
                            self.checkPatients()
                        }
                    }
                    
                    
                }
                
                
            } catch {
                print("error:", error)
                
            }
            
        }
        
        task.resume()*/
       searchTasks.removeAll()
        
        let fetchRequest:NSFetchRequest<Patients> = Patients.fetchRequest()
        let predicate = NSPredicate(format: "(userID = %@)", uid as! CVarArg)
        fetchRequest.predicate = predicate
        
        do {
            let count = try getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            if count > 0 {
                
                let fetchResult = try getContext().fetch(fetchRequest)
                
                for item in fetchResult {
                    
                    searchTasks.append(item)
                    patientsList.reloadData()
                    checkPatients()
          
                }
            } else {
                searchTasks.removeAll()
                patientsList.reloadData()
                checkPatients()
        
            }
            
        }catch {
            print(error.localizedDescription)
        }
        
   }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
   
        let patientData = searchTasks[indexPath.row]
        
        defaults.set(patientData.firstName!, forKey: "FN")
        defaults.set(patientData.lastName!, forKey: "LN")
        defaults.set(patientData.dateBirth!, forKey: "DB")
        defaults.set(patientData.phone!, forKey: "PH")
        defaults.set(patientData.email!, forKey: "EM")
        defaults.set(patientData.address!, forKey: "AD")
        defaults.set(patientData.id!, forKey: "PKEY")
        
    }
    
    func checkPatients(){
        
        if searchTasks.count == 0 {
            
            noPatientLabel.isHidden = false
            noPatientLabel.text = "No Patients exists."
            
        } else {
            
            noPatientLabel.isHidden = true
            noPatientLabel.text = ""
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkPatients()
    }
    
    @IBAction func navigateHome(_ sender: UIBarButtonItem) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    func configureSearchController() {
        // Initialize and perform a minimum configuration to the search controller.
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Patients"
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        searchController.searchBar.showsCancelButton = false
        UISearchBar.appearance().tintColor = UIColor.black
        searchController.searchBar.barTintColor = UIColor(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1.0)
        
        // Place the search bar view to the tableview headerview.
        patientsList.tableHeaderView = searchController.searchBar
    }
    
    
    func configureCustomSearchController() {
        customSearchController = CustomSearchController(searchResultsController: self, searchBarFrame: CGRect(x: 0.0, y: 0.0, width: patientsList.frame.size.width, height: 43.0), searchBarFont: UIFont(name: "Lato-Light", size: 20.0)!, searchBarTextColor: UIColor.lightGray, searchBarTintColor: UIColor.white)
        
        customSearchController.customSearchBar.placeholder = "Search Patients"
        patientsList.tableHeaderView = customSearchController.customSearchBar
     
        customSearchController.customDelegate = self
    }
    
    // MARK: UISearchBarDelegate functions
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        patientsList.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
      
        shouldShowSearchResults = false
        patientsList.reloadData()
        
        searchBar.text = nil
        searchBar.setShowsCancelButton(false, animated: true)
        
        // Remove focus from the search bar.
        searchBar.endEditing(true)
        self.definesPresentationContext = true
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            patientsList.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    
    // MARK: - Search Controller
    
    func didChangeSearchText(_ searchText: String) {
        searchResults = searchTasks.filter({ (task) -> Bool in
            
            if let firstname = task.firstName, let lastname = task.lastName , let number = task.phone, let dob = task.dateBirth  {
                let isMatch = firstname.localizedCaseInsensitiveContains(searchText) || lastname.localizedCaseInsensitiveContains(searchText) || number.localizedCaseInsensitiveContains(searchText) || dob.localizedCaseInsensitiveContains(searchText)


                return isMatch
            }
            
            return false
        })
        
        
        // Reload the tableview.
        patientsList.reloadData()
    }
    
    // MARK: UISearchResultsUpdating delegate function
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchText = searchController.searchBar.text {
            didChangeSearchText(searchText)
            patientsList.reloadData()
        }
    }
    
    
    // MARK: CustomSearchControllerDelegate functions
    
    func didStartSearching() {
        shouldShowSearchResults = true
        patientsList.reloadData()
    }
    
    
    func didTapOnSearchButton() {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
            patientsList.reloadData()
        }
    }
    
    
    func didTapOnCancelButton() {
        shouldShowSearchResults = false
        patientsList.reloadData()
    }
    
}

