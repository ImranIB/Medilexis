//
//  AddRX.swift
//  Medilexis
//
//  Created by iOS Developer on 19/05/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import XLActionController
import SwiftSpinner
import CoreData

class AddRX: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var medicineTableView: UITableView!
    @IBOutlet weak var noMedicineLabel: UILabel!
    @IBOutlet var saveNextButton: UIButton!
    @IBOutlet var saveExitButton: UIButton!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var skipButton: UIButton!
    @IBOutlet var saveNextLabel: UILabel!
    @IBOutlet var saveExitLabel: UILabel!
    @IBOutlet var saveLabel: UILabel!
    @IBOutlet var skipLabel: UILabel!
    @IBOutlet var saveLine: UIView!
    @IBOutlet var nextLine: UIView!
    @IBOutlet var exitLine: UIView!
    @IBOutlet var skipLine: UIView!
    
    
    var RxName = ["Acetaminophen", "Adderall", "Alprazolam" , "Amitriptyline", "Amoxicillin", "Ciprofloxacin" , "Codeine", "Doxycycline", "Gabapentin", "Hydrochlorothiazide", "Ibuprofen", "Lexapro", "Losartan", "Meloxicam", "Naproxen", "Oxycodone", "Prednisone", "Tramadol", "Wellbutrin", "Xanax", "Zoloft"]

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults.standard
    var medicines = [RxList]()
    var searchController: UISearchController!
    var searchResults:[RxList] = []
    var restaurantIsVisited = Array(repeating: false, count: 1000)
    var fileRxStored = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add a search bar
        searchController = UISearchController(searchResultsController: nil)
        medicineTableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Medicines"
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.isTranslucent = false
        searchController.searchBar.barTintColor = UIColor(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1.0)
        UISearchBar.appearance().tintColor = UIColor.black
        definesPresentationContext = true
        
        let RxGenerated = "RxGenerated"
        let RxValue = defaults.bool(forKey: RxGenerated)
        
        if !RxValue {
            defaults.set(true, forKey: RxGenerated)
            
            let context = getContext()
            
            let entity = NSEntityDescription.entity(forEntityName: "RxList", in: context)
            
            for name in RxName {
                

                let managedObj = NSManagedObject(entity: entity!, insertInto: context)
                
                let medicineId = NSUUID().uuidString.lowercased() as String
                
                managedObj.setValue(medicineId, forKey: "medicineID")
                managedObj.setValue(name, forKey: "medicineName")
                
                do {
                    try context.save()
                    print("Done")
                    
                    
                } catch {
                    print(error.localizedDescription)
                }
                
            }
        }
        
        saveNextButton.isHidden = true
        saveExitButton.isHidden = true
        saveButton.isHidden = true
        saveNextLabel.isHidden = true
        saveExitLabel.isHidden = true
        saveLabel.isHidden = true
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "RX") as! RXCell
        let medicine = (searchController.isActive) ? searchResults[indexPath.row] : medicines[indexPath.row]
       //let medicine = medicines[indexPath.row]
       cell.medicineName?.text = medicine.medicineName
       cell.accessoryType = restaurantIsVisited[indexPath.row] ? .checkmark : .none
        
       return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let selectMedicine = medicines[indexPath.row]
        let cell = medicineTableView.cellForRow(at: indexPath)
        fileRxStored = "false"
        
        if self.restaurantIsVisited[indexPath.row] == false {
           
            defaults.set(selectMedicine.medicineName!, forKey: "MedicineName")
            defaults.set(selectMedicine.medicineID!, forKey: "medicineID")
            
            saveNextButton.isHidden = false
            saveExitButton.isHidden = false
            saveButton.isHidden = false
            skipButton.isHidden = true
            saveNextLabel.isHidden = false
            saveExitLabel.isHidden = false
            saveLabel.isHidden = false
            skipLabel.isHidden = true
            saveLine.isHidden = false
            nextLine.isHidden = true
            exitLine.isHidden = true
            skipLine.isHidden = true
            
            self.restaurantIsVisited[indexPath.row] = self.restaurantIsVisited[indexPath.row] ? false : true
            cell?.accessoryType = self.restaurantIsVisited[indexPath.row] ? .checkmark : .none
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
             
             do {
             try context.save()
             
             let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
             let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RxDetail") as! RXDetail
             self.present(nextViewController, animated:true, completion:nil)
             
             } catch {
             print(error.localizedDescription)
             }
            
        } else {
            
            let alert = UIAlertController(title: "Notice", message: "Are you sure you want to unselect the medicine?", preferredStyle: UIAlertControllerStyle.alert)
            
            let ok = UIAlertAction(title: "Ok", style: .default, handler: {
                (action : UIAlertAction!) -> Void in
                
                self.restaurantIsVisited[indexPath.row] = self.restaurantIsVisited[indexPath.row] ? false : true
                cell?.accessoryType = self.restaurantIsVisited[indexPath.row] ? .checkmark : .none
                cell?.tintColor = UIColor(red: 0/255.0, green: 172/255.0, blue: 233/255.0, alpha: 1.0)
                
                let fetchRequest: NSFetchRequest<Medicines> = Medicines.fetchRequest()
                 let predicate = NSPredicate(format: "(medicineID = %@)", selectMedicine.medicineID!)
                 fetchRequest.predicate = predicate
                 
                 do {
                 let fetchResult = try self.getContext().fetch(fetchRequest)
                 
                 for item in fetchResult {
                 
                 self.context.delete(item)
                 
                 try self.context.save()
                    
                 self.medicineTableView.reloadData()
                    
                self.checkRecord()
                    
                 }
                 }catch {
                 print(error.localizedDescription)
                 }
                
            })
            
            
            let cancel = UIAlertAction(title: "Cancel", style: .default, handler: {
                (action : UIAlertAction!) -> Void in
                
                self.medicineTableView.reloadData()
                
            })
            
            alert.addAction(ok)
            alert.addAction(cancel)
            
            self.present(alert, animated: true, completion: nil);
            
        }
        
      
    }
    
    func getMedicines(){
        
        medicines.removeAll()
        
        let fetchRequest:NSFetchRequest<RxList> = RxList.fetchRequest()
        
        do {
            
            let count = try getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            if count > 0 {
                
                let fetchResult = try getContext().fetch(fetchRequest)
                
                for item in fetchResult {
 
                    medicines.append(item)
                    medicineTableView.reloadData()
                    checkMedicines()

 
                }
            } else {
                 medicines.removeAll()
                 medicineTableView.reloadData()
                 checkMedicines()

            }
            
        }catch {
            print(error.localizedDescription)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller = segue.destination as! RXDetail
        
        if segue.identifier == "showDetail" {
            let selectedItem: RxList = medicines[self.medicineTableView.indexPathForSelectedRow!.row] as RxList
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
    
    @IBAction func navigateToHome(_ sender: UIBarButtonItem) {
        
        let actionController = YoutubeActionController()
        
        actionController.addAction(Action(ActionData(title: "Home", image: UIImage(named: "home-icon")!), style: .default, handler: { action in
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
            self.present(nextViewController, animated:true, completion:nil)
            
        }))
        
        actionController.addAction(Action(ActionData(title: "Add New Medication", image: UIImage(named: "add")!), style: .default, handler: { action in
            
            let alertController = UIAlertController(title: "Enter Medication Name", message: "", preferredStyle: .alert)
            
            let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
                alert -> Void in
                
                let medicineTextField = alertController.textFields![0] as UITextField
                
                if medicineTextField.text == "" {
                    
                    let alert = UIAlertController(title: "Notice", message: "Please fill all the fields", preferredStyle: UIAlertControllerStyle.alert)
                    let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                    alert.addAction(action)
                    
                    self.present(alert, animated: true, completion: nil);
                    
                } else {
                    
                    let medicine = medicineTextField.text?.capitalized
                    let medicineId = NSUUID().uuidString.lowercased() as String
                    
                    let context = self.getContext()
                    
                    let entity = NSEntityDescription.entity(forEntityName: "RxList", in: context)
                    
                    let managedObj = NSManagedObject(entity: entity!, insertInto: context)
                    
                    managedObj.setValue(medicineId, forKey: "medicineID")
                    managedObj.setValue(medicine, forKey: "medicineName")
                    
                    do {
                        try context.save()
                        
                        self.getMedicines()
                        self.medicineTableView.reloadData()
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
    
    @IBAction func dismissRX(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func getContext () -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
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
            medicineTableView.reloadData()
        }
    }
    
    @IBAction func saveNext(_ sender: UIButton) {
        
        if self.fileRxStored == "false" {
            
            let alert = UIAlertController(title: "Hold On", message: "Changes have not been saved. Do you want to leave without saving?", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: self.yesExit)
            let cancel = UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            alert.addAction(cancel)
            
            
            self.present(alert, animated: true, completion: nil);
            
        } else {
            
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "codes") as! Codes
            self.present(nextViewController, animated:true, completion:nil)
            
            saveNextButton.isHidden = true
            saveExitButton.isHidden = true
            saveButton.isHidden = true
            skipLine.isHidden = false
            saveNextLabel.isHidden = true
            saveExitLabel.isHidden = true
            saveLabel.isHidden = true
            skipLabel.isHidden = false
            saveLine.isHidden = true
            nextLine.isHidden = true
            exitLine.isHidden = true
            skipLine.isHidden = false
         
        }
        
    }
    
    func yesExit(alert: UIAlertAction){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    
    @IBAction func saveExit(_ sender: UIButton) {
        
        if self.fileRxStored == "false" {
            
            let alert = UIAlertController(title: "Hold On", message: "Changes have not been saved. Do you want to leave without saving?", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: self.yesExit)
            let cancel = UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            alert.addAction(cancel)
            
            
            self.present(alert, animated: true, completion: nil);
            
        } else {
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
            self.present(nextViewController, animated:true, completion:nil)
            
        }
    }

    @IBAction func skipPressed(_ sender: UIButton) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "codes") as! Codes
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        
        fileRxStored = "true"
        saveLine.isHidden = true
        nextLine.isHidden = false
        exitLine.isHidden = true
    }
    
    
    func checkRecord(){
        
        let AppointmentID = defaults.value(forKey: "AppointmentID")
        let fetchRequest: NSFetchRequest<Medicines> = Medicines.fetchRequest()
        let predicate = NSPredicate(format: "(appointmentID = %@)", AppointmentID! as! CVarArg)
        fetchRequest.predicate = predicate
        
        do {
            let count = try self.getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            if count == 0 {
                
                self.saveNextButton.isEnabled = false
                self.saveExitButton.isEnabled = false
                self.saveNextLabel.isEnabled = false
                self.saveExitLabel.isEnabled = false
            }
            
        }catch {
            print(error.localizedDescription)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        getMedicines()
        
        SwiftSpinner.show("Proceeding to next screen")
        
        if defaults.value(forKey: "rx") != nil{
            let switchON: Bool = defaults.value(forKey: "rx")  as! Bool
            if switchON == false{
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Updatecodes") as! UpdateCodes
                self.present(nextViewController, animated:true, completion:nil)
                SwiftSpinner.hide()
            } else {
                SwiftSpinner.hide()
            }
        }
    }

}
