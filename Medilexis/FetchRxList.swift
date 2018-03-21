//
//  RxList.swift
//  Medilexis
//
//  Created by iOS Developer on 08/08/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit
import CoreData

class FetchRxList: UIViewController, UITableViewDataSource, UITableViewDelegate , UISearchResultsUpdating {
    
    @IBOutlet var rxList: UITableView!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var saveLabel: UILabel!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var cancelLabel: UILabel!
    @IBOutlet var saveLine: UIView!
    @IBOutlet var cancelLine: UIView!
    

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var medicines = [RxList]()
    var searchController: UISearchController!
    var searchResults:[RxList] = []
    let defaults = UserDefaults.standard
    var rxSelected = Array(repeating: false, count: 1000)
    var RxSelected: Bool!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor =  UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        self.rxList.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        
        // Add a search bar
        searchController = UISearchController(searchResultsController: nil)
        rxList.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Medications"
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.barTintColor = UIColor(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1.0)
        UISearchBar.appearance().tintColor = UIColor.black
        definesPresentationContext = true
        
        self.rxList.reloadData()
        
        fetchMedicines()
        
        saveButton.isHidden = true
        saveLabel.isHidden = true
        saveLine.isHidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive {
            return searchResults.count
        } else {
            return medicines.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FetchRxCell") as! FetchRxCell
        let medicine = (searchController.isActive) ? searchResults[indexPath.row] : medicines[indexPath.row]
        cell.medicineName?.text = medicine.medicineName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectMedicine = medicines[indexPath.row]
        let cell = rxList.cellForRow(at: indexPath)
        
        if self.rxSelected[indexPath.row] == false {
            
            let fetchRequest:NSFetchRequest<Medicines> = Medicines.fetchRequest()
            let predicate = NSPredicate(format: "(medicineID = %@)", selectMedicine.medicineID!)
            fetchRequest.predicate = predicate
            
            do {
                let count = try getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
                
                if count > 0 {
                    
                    DispatchQueue.main.async {
                        
                        let alert = UIAlertController(title: "Notice", message: "\(String(describing: selectMedicine.medicineName!)) already exist", preferredStyle: UIAlertControllerStyle.alert)
                        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                        alert.addAction(action)
                        
                        self.present(alert, animated: true, completion: nil);
                        
                        self.rxList.reloadData()
                        
                        return
                    }
          
                } else {
                    
                    saveButton.isHidden = false
                    saveLabel.isHidden = false
                    saveLine.isHidden = false
                    cancelButton.isHidden = true
                    cancelLabel.isHidden = true
                    cancelLine.isHidden = true
                    
                    self.rxSelected[indexPath.row] = self.rxSelected[indexPath.row] ? false : true
                    cell?.accessoryType = self.rxSelected[indexPath.row] ? .checkmark : .none
                    cell?.tintColor = UIColor(red: 0/255.0, green: 172/255.0, blue: 233/255.0, alpha: 1.0)
                    
                    let userID = defaults.value(forKey: "UserID") as! Int32
                    let AppointmentID = defaults.value(forKey: "AppointmentID")
                    
                    let context = getContext()
                    
                    let entity = NSEntityDescription.entity(forEntityName: "Medicines", in: context)
                    
                    let managedObj = NSManagedObject(entity: entity!, insertInto: context)
                    
                    managedObj.setValue(selectMedicine.medicineID!, forKey: "medicineID")
                    managedObj.setValue(userID, forKey: "userID")
                    managedObj.setValue(AppointmentID, forKey: "AppointmentID")
                    managedObj.setValue(selectMedicine.medicineName!, forKey: "medicineName")
                    
                    RxSelected = true
                    
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
            
            let alert = UIAlertController(title: "Notice", message: "Are you sure you want to unselect the medicine?", preferredStyle: UIAlertControllerStyle.alert)
            
            let ok = UIAlertAction(title: "Ok", style: .default, handler: {
                (action : UIAlertAction!) -> Void in
                
                self.rxSelected[indexPath.row] = self.rxSelected[indexPath.row] ? false : true
                cell?.accessoryType = self.rxSelected[indexPath.row] ? .checkmark : .none
                cell?.tintColor = UIColor(red: 0/255.0, green: 172/255.0, blue: 233/255.0, alpha: 1.0)
                
                let fetchRequest: NSFetchRequest<Medicines> = Medicines.fetchRequest()
                let predicate = NSPredicate(format: "(medicineID = %@)", selectMedicine.medicineID!)
                fetchRequest.predicate = predicate
                
                do {
                    let fetchResult = try self.getContext().fetch(fetchRequest)
                    
                    for item in fetchResult {
                        
                        self.context.delete(item)
                        
                        try self.context.save()
                        
                        self.rxList.reloadData()
                        
                        
                    }
                }catch {
                    print(error.localizedDescription)
                }
                
            })
            
            
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: {
                (action : UIAlertAction!) -> Void in
                
                self.rxList.reloadData()
                
            })
            
            alert.addAction(ok)
            alert.addAction(cancel)
            
            self.present(alert, animated: true, completion: nil);
            
        }
    }
    
    func fetchMedicines(){
        
        medicines.removeAll()
        
        let fetchRequest:NSFetchRequest<RxList> = RxList.fetchRequest()
  
        do {
            
            let count = try getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            if count > 0 {
                
                let fetchResult = try getContext().fetch(fetchRequest)
                
                for item in fetchResult {
                    
                    medicines.append(item)
                    rxList.reloadData()
            
                }
            } else {
                medicines.removeAll()
                rxList.reloadData()
            }
            
        }catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Search Controller
    
    func filterContent(for searchText: String) {
        searchResults = medicines.filter({ (medicine) -> Bool in
            if let name = medicine.medicineName{
                let isMatch = name.localizedCaseInsensitiveContains(searchText)
                return isMatch
            }
            
            return false
        })
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            rxList.reloadData()
        }
    }
    
    @IBAction func save(_ sender: UIButton) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "updateRX") as! UpdateRX
        nextViewController.selection = RxSelected
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    

    
    func getContext () -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    @IBAction func navigateToHome(_ sender: UIBarButtonItem) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
}
