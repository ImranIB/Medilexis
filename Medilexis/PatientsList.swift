//
//  PatientsList.swift
//  Medilexis
//
//  Created by iOS Developer on 07/07/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit
import CoreData
import SwiftSpinner
import XLActionController
import AlamofireImage
import SVProgressHUD
import Alamofire

class PatientsList: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UISearchBarDelegate, CustomSearchControllerDelegate, ImagePressedDelegate, IDCardPressedDelegate {
    
    @IBOutlet var patientsList: UITableView!
    @IBOutlet var noPatientLabel: UILabel!
    @IBOutlet var searchPatients: UINavigationItem!
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults.standard
    var searchTasks = [Patients]()
    var searchController: UISearchController!
    var searchResults:[Patients] = []
    var searchImages = [Images]()
    var searchPatientsArray = [SearchPatients]()
    var searchPatientsFilterArray:[SearchPatients] = []
    
    var shouldShowSearchResults = false
    var customSearchController: CustomSearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor =  UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        self.patientsList.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        //FetchServerPatients()
        
        SVProgressHUD.show()
        SVProgressHUD.setDefaultMaskType(.clear)
        //loadImages()
        FetchPatientsList()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        print("memory issue in patients List")
    }
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func Home(_ sender: UIBarButtonItem) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if shouldShowSearchResults {
            return searchPatientsFilterArray.count
        }
        else {
            return searchPatientsArray.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PatientsLists", for: indexPath) as! PatientsListCell
        
        
        if shouldShowSearchResults {
            let task = searchPatientsFilterArray[indexPath.row]
            
            if task.profileimage == "N/A" {
             
             cell.profileImage.image = UIImage(named: "thumb_image_not_available")
             cell.profileImage.layer.cornerRadius = 0.5 * cell.profileImage.bounds.size.width
             cell.profileImage.clipsToBounds = true
             
             } else {
             
             let fileManager = FileManager.default
             let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
             let documentsDirectoryURL: NSURL = urls.first! as NSURL
             let imageURL = documentsDirectoryURL.appendingPathComponent("ProfileImages/" + task.profileimage)
             cell.profileImage.af_setImage(withURL: imageURL! as URL, placeholderImage: UIImage(named: "placeHolder"), filter: nil, imageTransition: .crossDissolve(0.2))
             }
             
             if task.profileidimage == "N/A" {
             
             cell.profileIDImage.image = UIImage(named: "thumb_image_not_available")
             
             } else {
             
             let fileManager = FileManager.default
             let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
             let documentsDirectoryURL: NSURL = urls.first! as NSURL
             let imageURL = documentsDirectoryURL.appendingPathComponent("IDCardImages/" + task.profileidimage)
             cell.profileIDImage.af_setImage(withURL: imageURL! as URL, placeholderImage: UIImage(named: "placeHolder"), filter: nil, imageTransition: .crossDissolve(0.2))
             }

            let fullName = task.firstname + " " + task.lastname
            cell.nameLabel.text = fullName
            cell.dobLabel.text = task.dob
            cell.phoneLabel.text = task.phone
            cell.medicalNoLabel.text = task.medicalno
            cell.profileImage.tag = indexPath.row
            cell.profileIDImage.tag = indexPath.row
            cell.imageDelegate = self
            cell.idcardDelegate = self
            cell.indexPath = indexPath
            
        }
        else {
            
            let task = searchPatientsArray[indexPath.row]
          //  let images = searchImages[indexPath.row]
            
            
            if task.profileidimage == "N/A" {
                
                cell.profileIDImage.image = UIImage(named: "thumb_image_not_available")
                cell.profileIDImage.layer.cornerRadius = 0.5 * cell.profileImage.bounds.size.width
                cell.profileIDImage.clipsToBounds = true
                
            } else {
                
                let fileManager = FileManager.default
                let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
                let documentsDirectoryURL: NSURL = urls.first! as NSURL
                let imageURL = documentsDirectoryURL.appendingPathComponent("IDCardImages/" + task.profileidimage)
                cell.profileIDImage.af_setImage(withURL: imageURL! as URL, placeholderImage: UIImage(named: "placeHolder"), filter: nil, imageTransition: .crossDissolve(0.2))
                cell.profileIDImage.layer.cornerRadius = 0.5 * cell.profileImage.bounds.size.width
                cell.profileIDImage.clipsToBounds = true
            }
            
            if task.profileimage == "N/A" {
                
                cell.profileImage.image = UIImage(named: "thumb_image_not_available")
                cell.profileImage.layer.cornerRadius = 0.5 * cell.profileImage.bounds.size.width
                cell.profileImage.clipsToBounds = true
                
            } else {
                
                let fileManager = FileManager.default
                let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
                let documentsDirectoryURL: NSURL = urls.first! as NSURL
                let imageURL = documentsDirectoryURL.appendingPathComponent("ProfileImages/" + task.profileimage)
                cell.profileImage.af_setImage(withURL: imageURL! as URL, placeholderImage: UIImage(named: "placeHolder"), filter: nil, imageTransition: .crossDissolve(0.2))
                cell.profileImage.layer.cornerRadius = 0.5 * cell.profileImage.bounds.size.width
                cell.profileImage.clipsToBounds = true
            }
  
            let fullName = task.firstname + " " + task.lastname
            cell.nameLabel.text = fullName
            cell.dobLabel.text = task.dob
            cell.phoneLabel.text = task.phone
            cell.medicalNoLabel.text = task.medicalno
            cell.profileImage.tag = indexPath.row
            cell.profileIDImage.tag = indexPath.row
            cell.imageDelegate = self
            cell.idcardDelegate = self
            cell.indexPath = indexPath
        }
        
        return cell
        
    }
    
    func getContext () -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func loadImages(){
        
        let uid = defaults.value(forKey: "UserID")
        searchImages.removeAll()
        
        let fetchRequest:NSFetchRequest<Patients> = Patients.fetchRequest()
        let predicate = NSPredicate(format: "(userID = %@)", uid as! CVarArg)
        fetchRequest.predicate = predicate
        
        do {
            let count = try getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            if count > 0 {
                
                let fetchResult = try getContext().fetch(fetchRequest)
                
                for item in fetchResult {
                    
                    let data = Images(profileimage: item.profileImage!, profileidimage: item.idCardImage!)
                    self.searchImages.append(data)
                    SVProgressHUD.dismiss()
                }
                
                DispatchQueue.main.async {
                    
                    //self.patientsList.reloadData()
                    self.checkPatients()
                    
                }
                
            } else {
                searchImages.removeAll()
                SVProgressHUD.dismiss()
                
            }
            
        }catch {
            print(error.localizedDescription)
        }
        

    }
    
    func FetchPatientsList() {
        
        let uid = defaults.value(forKey: "UserID")
        searchPatientsFilterArray.removeAll()
        searchPatientsArray.removeAll()
        
        let fetchRequest:NSFetchRequest<Patients> = Patients.fetchRequest()
        let predicate = NSPredicate(format: "(userID = %@)", uid as! CVarArg)
        fetchRequest.predicate = predicate
        
        do {
            let count = try getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            if count > 0 {
                
                let fetchResult = try getContext().fetch(fetchRequest)
                
                for item in fetchResult {

                    let data = SearchPatients(patientid: item.id!, firstname: item.firstName!, lastname: item.lastName!, dob: item.dateBirth!, phone: item.phone!, medicalno: item.medicalNo!, email: item.email!, address: item.address!, profileimage: item.profileImage!, profileidimage: item.idCardImage!)
                    self.searchPatientsArray.append(data)
                    SVProgressHUD.dismiss()
                }
                
                DispatchQueue.main.async {
                    
                   self.patientsList.reloadData()
                   self.configureCustomSearchController()
                   self.checkPatients()
                }
                
            } else {
                searchPatientsArray.removeAll()
                checkPatients()
                SVProgressHUD.dismiss()
                
            }
            
        }catch {
            print(error.localizedDescription)
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if shouldShowSearchResults {
            
            let task = searchPatientsFilterArray[indexPath.row]
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "patientProfile") as! PatientProfile
            nextViewController.patientID = task.patientid
            self.present(nextViewController, animated:true, completion:nil)
            
        } else {
            
            let patientData = searchPatientsArray[indexPath.row]
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "patientProfile") as! PatientProfile
            nextViewController.patientID = patientData.patientid
            self.present(nextViewController, animated:true, completion:nil)
            
            
        }
    }
    
    func checkPatients(){
        
        if searchPatientsArray.count == 0 {
            
            noPatientLabel.isHidden = false
            noPatientLabel.text = "No Patients exists."
            
        } else {
            
            noPatientLabel.isHidden = true
            noPatientLabel.text = ""
        }
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
        
        customSearchController.customSearchBar.placeholder = "Type 3 letters to search...."
        patientsList.tableHeaderView = customSearchController.customSearchBar
        
        customSearchController.customDelegate = self
    }
    
    // MARK: UISearchBarDelegate functions
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        shouldShowSearchResults = true
        //patientsList.reloadData()
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
            //patientsList.reloadData()
        }
        
        searchController.searchBar.resignFirstResponder()
    }
    
    // MARK: - Search Controller
    
    func didChangeSearchText(_ searchText: String) {
        
        if searchText.count > 2 {
            
            searchPatientsFilterArray.removeAll()
            
            searchPatientsFilterArray = searchPatientsArray.filter({ (task) -> Bool in
                
                let firstname = task.firstname
                let lastname = task.lastname
                let number = task.phone
                let dob = task.dob
                let no = task.medicalno
                
                let isMatch = firstname.localizedCaseInsensitiveContains(searchText) || lastname.localizedCaseInsensitiveContains(searchText) || number.localizedCaseInsensitiveContains(searchText) || dob.localizedCaseInsensitiveContains(searchText) || no.localizedCaseInsensitiveContains(searchText)
                
                return isMatch
                
                return false
            })
    
            DispatchQueue.main.async {
                // Reload the tableview.
                self.patientsList.reloadData()
                
            }
        }
   
    }
    
    // MARK: UISearchResultsUpdating delegate function
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchText = searchController.searchBar.text {
            didChangeSearchText(searchText)
            //patientsList.reloadData()
        }
    }
    
    
    // MARK: CustomSearchControllerDelegate functions
    
    func didStartSearching() {
        print("didStartSearching")
        shouldShowSearchResults = true
       // patientsList.reloadData()
    }
    
    
    func didTapOnSearchButton() {
        if !shouldShowSearchResults {
            shouldShowSearchResults = true
           // patientsList.reloadData()
        }
    }
    
    
    func didTapOnCancelButton() {
        print("cancel")
        shouldShowSearchResults = false
        DispatchQueue.main.async {
            SVProgressHUD.show()
            self.FetchPatientsList()
            
        }
    }
    
    func imageTapped(at index: IndexPath, value: String) {
        
        let data = searchPatientsArray[index.row]
       
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "editImage") as! EditImage
        nextViewController.type = value
        nextViewController.id = data.patientid
        nextViewController.image = data.profileimage
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    func idTapped(at index: IndexPath, value: String) {
        
        let data = searchPatientsArray[index.row]
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "editImage") as! EditImage
        nextViewController.type = value
        nextViewController.image = data.profileidimage
        nextViewController.id = data.patientid
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    func FetchServerPatients(){
        
        let doctorID = defaults.value(forKey: "UserID") as! Int
        let token = defaults.value(forKey: "Token") as! String
        
        let url = URL(string: "http://muapp.com/medilixis_server/public/getselectedapppatient")!
        let jsonDict = ["id": doctorID, "token": token] as [String : Any]
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
                print("json:", json)
                
                
                
            } catch {
                print("error:", error)
                
            }
            
        }
        
        task.resume()
    }
    
}

