//
//  FetchCptList.swift
//  Medilexis
//
//  Created by iOS Developer on 10/08/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit
import CoreData

class FetchCptList: UIViewController, UITableViewDataSource, UITableViewDelegate , UISearchResultsUpdating {
    
    
    @IBOutlet var fetchCptTable: UITableView!
    @IBOutlet var save: UIButton!
    @IBOutlet var saveLabel: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var searchCpt = [DiagnosticList]()
    var searchController: UISearchController!
    var searchResults:[DiagnosticList] = []
    let defaults = UserDefaults.standard
    var cptSelected = Array(repeating: false, count: 1000)

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor =  UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        self.fetchCptTable.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        
        // Add a search bar
        searchController = UISearchController(searchResultsController: nil)
        fetchCptTable.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Cpt"
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.tintColor = UIColor.white
        searchController.searchBar.barTintColor = UIColor(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1.0)
        
        self.fetchCptTable.reloadData()
        
        fetchCpt()
        
        save.isEnabled = false
        saveLabel.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive {
            return searchResults.count
        } else {
            return searchCpt.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FetchCptCell") as! FetchCptCell
        let cpt = (searchController.isActive) ? searchResults[indexPath.row] : searchCpt[indexPath.row]
        cell.descriptionLabel?.text = cpt.name
        cell.codeLabel?.text = cpt.code
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
      
        let selectCpt = searchCpt[indexPath.row]
        print(selectCpt.name!)
        let cell = fetchCptTable.cellForRow(at: indexPath)
        
        if self.cptSelected[indexPath.row] == false {
            
            let fetchRequest:NSFetchRequest<Diagnostics> = Diagnostics.fetchRequest()
            let predicate = NSPredicate(format: "(diagnosticID = %@)", selectCpt.codeID!)
            fetchRequest.predicate = predicate
            
            do {
                let count = try getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
                
                if count > 0 {
                    
                    DispatchQueue.main.async {
                        
                        let alert = UIAlertController(title: "Notice", message: "\(String(describing: selectCpt.name!)) already exist", preferredStyle: UIAlertControllerStyle.alert)
                        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                        alert.addAction(action)
                        
                        self.present(alert, animated: true, completion: nil);
                        
                        self.fetchCptTable.reloadData()
                        
                        return
                    }
                    
                } else {
                    
                    save.isEnabled = true
                    saveLabel.isEnabled = true
                    
                    self.cptSelected[indexPath.row] = self.cptSelected[indexPath.row] ? false : true
                    cell?.accessoryType = self.cptSelected[indexPath.row] ? .checkmark : .none
                    cell?.tintColor = UIColor(red: 0/255.0, green: 172/255.0, blue: 233/255.0, alpha: 1.0)
                    
                    let userID = defaults.value(forKey: "UserID") as! Int32
                    let AppointmentID = defaults.value(forKey: "AppointmentID")
                    
                    let context = getContext()
                    
                    let entity = NSEntityDescription.entity(forEntityName: "Diagnostics", in: context)
                    
                    let managedObj = NSManagedObject(entity: entity!, insertInto: context)
                    
                    managedObj.setValue(selectCpt.codeID, forKey: "diagnosticID")
                    managedObj.setValue(userID, forKey: "userID")
                    managedObj.setValue(AppointmentID, forKey: "appointmentID")
                    managedObj.setValue(selectCpt.name, forKey: "discription")
                    managedObj.setValue(selectCpt.code!, forKey: "code")
                    managedObj.setValue("CPT", forKey: "type")
                    
                    do {
                        try context.save()
                        
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }catch {
                print(error.localizedDescription)
            }
            
        } else {
            
            let alert = UIAlertController(title: "Notice", message: "Are you sure you want to unselect the Cpt?", preferredStyle: UIAlertControllerStyle.alert)
            
            let ok = UIAlertAction(title: "Ok", style: .default, handler: {
                (action : UIAlertAction!) -> Void in
                
                self.cptSelected[indexPath.row] = self.cptSelected[indexPath.row] ? false : true
                cell?.accessoryType = self.cptSelected[indexPath.row] ? .checkmark : .none
                cell?.tintColor = UIColor(red: 0/255.0, green: 172/255.0, blue: 233/255.0, alpha: 1.0)
                
                let fetchRequest: NSFetchRequest<Diagnostics> = Diagnostics.fetchRequest()
                let predicate = NSPredicate(format: "(diagnosticID = %@)", selectCpt.codeID!)
                fetchRequest.predicate = predicate
                
                do {
                    let fetchResult = try self.getContext().fetch(fetchRequest)
                    
                    for item in fetchResult {
                        
                        self.context.delete(item)
                        
                        try self.context.save()
                        
                        self.fetchCptTable.reloadData()
                        
                        
                    }
                }catch {
                    print(error.localizedDescription)
                }
                
            })
            
            
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: {
                (action : UIAlertAction!) -> Void in
                
                self.fetchCptTable.reloadData()
                
            })
            
            alert.addAction(ok)
            alert.addAction(cancel)
            
            self.present(alert, animated: true, completion: nil);
            
        }
    }
    
    func fetchCpt(){
        
        searchCpt.removeAll()
        
        let fetchRequest:NSFetchRequest<DiagnosticList> = DiagnosticList.fetchRequest()
        let predicate = NSPredicate(format: "(type = %@)", "CPT")
        fetchRequest.predicate = predicate
        
        do {
            
            let count = try getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            if count > 0 {
                
                let fetchResult = try getContext().fetch(fetchRequest)
                
                for item in fetchResult {
                    
                    searchCpt.append(item)
                    fetchCptTable.reloadData()
                    
                }
            } else {
                searchCpt.removeAll()
                fetchCptTable.reloadData()
            }
            
        }catch {
            print(error.localizedDescription)
        }
    }
    
    func getContext () -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    // MARK: - Search Controller
    
    func filterContent(for searchText: String) {
        searchResults = searchCpt.filter({ (cpt) -> Bool in
            if let name = cpt.name{
                let isMatch = name.localizedCaseInsensitiveContains(searchText)
                return isMatch
            }
            
            return false
        })
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            fetchCptTable.reloadData()
        }
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Updatecodes") as! UpdateCodes
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func homePressed(_ sender: UIBarButtonItem) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        
         dismiss(animated: true, completion: nil)
    }
    
    

}
