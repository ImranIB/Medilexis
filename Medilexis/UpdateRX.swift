//
//  UpdateRX.swift
//  Medilexis
//
//  Created by iOS Developer on 23/05/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import CoreData
import SwiftSpinner
import XLActionController

class UpdateRX: UIViewController, UITableViewDataSource, UITableViewDelegate , UISearchResultsUpdating{

    @IBOutlet weak var updateRXTableView: UITableView!
    @IBOutlet weak var noMedicineLabel: UILabel!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var saveLabel: UILabel!
    @IBOutlet var saveLine: UIView!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var nextLabel: UILabel!
    @IBOutlet var nextLine: UIView!
    @IBOutlet var exitButton: UIButton!
    @IBOutlet var exitLabel: UILabel!
    @IBOutlet var exitLine: UIView!
    @IBOutlet var skipButton: UIButton!
    @IBOutlet var skipLabel: UILabel!
    @IBOutlet var skipLine: UIView!
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults.standard
    var medicines = [Medicines]()
    var searchController: UISearchController!
    var searchResults:[Medicines] = []
    var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor =  UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        self.updateRXTableView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        
        // Add a search bar
        searchController = UISearchController(searchResultsController: nil)
        updateRXTableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Medications"
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.barTintColor = UIColor(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1.0)
        UISearchBar.appearance().tintColor = UIColor.black
        definesPresentationContext = true
        
        self.updateRXTableView.reloadData()
        
        getMedicines()
        
        saveButton.isHidden = true
        nextButton.isHidden = true
        exitButton.isHidden = false
        saveLabel.isHidden = true
        nextLabel.isHidden = true
        exitLabel.isHidden = false
        saveLine.isHidden = true
        nextLine.isHidden = true
        exitLine.isHidden = true
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpdateRX") as! UpdateRXCell
        let medicine = (searchController.isActive) ? searchResults[indexPath.row] : medicines[indexPath.row]
        cell.medicineName?.text = medicine.medicineName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectMedicine = medicines[indexPath.row]
        defaults.set(selectMedicine.medicineID!, forKey: "medicineID")
        defaults.set(selectMedicine.medicineName!, forKey: "medicineName")
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "UpdateRXDetail") as! UpdateRXDetail
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    func getMedicines(){
        
        let uid = defaults.value(forKey: "UserID")
        let AppointmentID = defaults.value(forKey: "AppointmentID")
        
        medicines.removeAll()
        
        let fetchRequest:NSFetchRequest<Medicines> = Medicines.fetchRequest()
        let predicate = NSPredicate(format: "(userID = %@) AND (appointmentID = %@)", uid as! CVarArg, AppointmentID as! CVarArg)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "medicineName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            
            let count = try getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            if count > 0 {
                
                let fetchResult = try getContext().fetch(fetchRequest)
                
                for item in fetchResult {
                    
                    medicines.append(item)
                    updateRXTableView.reloadData()
                    checkMedicines()
                  
                }
            } else {
                medicines.removeAll()
                updateRXTableView.reloadData()
                checkMedicines()
            }
            
        }catch {
            print(error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! UpdateRXDetail
        
        if segue.identifier == "updateRXDetail" {
            let selectedItem: Medicines = medicines[self.updateRXTableView.indexPathForSelectedRow!.row] as Medicines
            controller.selectedRX = selectedItem.value(forKey: "medicineName") as! String
            
        }
    }
    
    func checkMedicines(){
        
        if medicines.count == 0 {
            noMedicineLabel.isHidden = false
            noMedicineLabel.text = "No Medicines exists."
            
        } else {
            
            noMedicineLabel.isHidden = true
            noMedicineLabel.text = ""
        }
    }
    
    func getContext () -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.updateRXTableView.reloadData()
        getMedicines()
        
    }
    
    @IBAction func navigateToHome(_ sender: UIBarButtonItem) {
        
        let actionController = YoutubeActionController()
        
        actionController.addAction(Action(ActionData(title: "Medications List", image: UIImage(named: "list")!), style: .default, handler: { action in
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RxList") as! FetchRxList
            self.present(nextViewController, animated:true, completion:nil)
            
        }))
        
        actionController.addAction(Action(ActionData(title: "Add New Medication", image: UIImage(named: "add")!), style: .default, handler: { action in
            
            let alertController = UIAlertController(title: "Enter Medication Name", message: "", preferredStyle: .alert)
            
            let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
                alert -> Void in
                
                let medicineTextField = alertController.textFields![0] as UITextField
                
                
                if medicineTextField.text == "" {
                    
                    let alert = UIAlertController(title: "Notice", message: "Please fill the field", preferredStyle: UIAlertControllerStyle.alert)
                    let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                    alert.addAction(action)
                    
                    self.present(alert, animated: true, completion: nil);
                    
                } else {
                    
                    self.saveButton.isHidden = false
                    self.nextButton.isHidden = false
                    self.exitButton.isHidden = false
                    self.skipButton.isHidden = true
                    self.saveLabel.isHidden = false
                    self.nextLabel.isHidden = false
                    self.exitLabel.isHidden = false
                    self.skipLabel.isHidden = true
                    self.saveLine.isHidden = false
                    self.nextLine.isHidden = true
                    self.exitLine.isHidden = true
                    self.skipLine.isHidden = true
                    
                    let medicine = medicineTextField.text?.capitalized
                    let medicineId = NSUUID().uuidString.lowercased() as String
                    let AppointmentID = self.defaults.value(forKey: "AppointmentID") as! String
                    let userID = self.defaults.value(forKey: "UserID") as! Int32
                    
                    let context = self.getContext()
                    
                    let entity = NSEntityDescription.entity(forEntityName: "Medicines", in: context)
                    
                    let managedObj = NSManagedObject(entity: entity!, insertInto: context)
                    
                    managedObj.setValue(medicineId, forKey: "medicineID")
                    managedObj.setValue(medicine, forKey: "medicineName")
                    managedObj.setValue(AppointmentID, forKey: "appointmentID")
                    managedObj.setValue(userID, forKey: "userID")
                    
                    do {
                        try context.save()
                        
                        medicineTextField.text = ""
                        self.getMedicines()
                        self.updateRXTableView.reloadData()
                        self.checkMedicines()
                    
                        
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                }
            })
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
                (action : UIAlertAction!) -> Void in
                
            })
            
            alertController.addTextField { (textField : UITextField!) -> Void in
                textField.placeholder = "Medication Name"
            }
            
            alertController.addAction(saveAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        }))
        
        actionController.addAction(Action(ActionData(title: "Cancel", image: UIImage(named: "cancel")!), style: .default, handler: { action in
        }))
        
        present(actionController, animated: true, completion: nil)
       
    }
    
    @IBAction func dismissUpdateRX(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
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
            updateRXTableView.reloadData()
        }
    }
    
    @IBAction func save(_ sender: UIButton) {
        
        saveLine.isHidden = true
        nextLine.isHidden = false
        exitLine.isHidden = true
    }
    
    @IBAction func saveNext(_ sender: UIButton) {
        
        saveButton.isHidden = true
        nextButton.isHidden = true
        exitButton.isHidden = true
        skipButton.isHidden = false
        saveLabel.isHidden = true
        nextLabel.isHidden = true
        exitLabel.isHidden = true
        skipLabel.isHidden = false
        saveLine.isHidden = true
        nextLine.isHidden = true
        exitLine.isHidden = true
        skipLine.isHidden = false
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "updatecpt") as! UpdateCpt
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    
    @IBAction func saveExit(_ sender: UIButton) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func skip(_ sender: UIButton) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "updatecpt") as! UpdateCpt
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
       /* SwiftSpinner.show("Proceeding to next screen")
        
        if defaults.value(forKey: "rx") != nil{
            let switchON: Bool = defaults.value(forKey: "rx")  as! Bool
            if switchON == false{
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Updatecodes") as! UpdateCodes
                self.present(nextViewController, animated:true, completion:nil)
                
                    timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector:  #selector(UpdateRX.UpdateRXLoaderHide), userInfo: nil, repeats: true)
            } else {
                SwiftSpinner.hide()
            }
        }*/
    }
    
    func UpdateRXLoaderHide(){
        
        SwiftSpinner.hide()
    }
}
