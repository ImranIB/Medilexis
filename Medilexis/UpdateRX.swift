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

class UpdateRX: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var medicineTextField: SkyFloatingLabelTextFieldWithIcon!
    @IBOutlet weak var updateRXTableView: UITableView!
    @IBOutlet weak var noMedicineLabel: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults.standard
    var medicines = [Medicines]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor =  UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        self.updateRXTableView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        
        medicineTextField.iconFont = UIFont(name: "FontAwesome", size: 12)
        medicineTextField.iconText = "\u{f0fa}"
        medicineTextField.iconColor = UIColor.lightGray
        medicineTextField.title = "Medicine Name"
        medicineTextField.titleFormatter = { $0 }
        medicineTextField.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        medicineTextField.iconMarginBottom = 1.0 // more precise icon positioning. Usually needed to tweak on a per font basis.
        medicineTextField.iconMarginLeft = 2.0
        self.view.addSubview(medicineTextField)
        
        self.updateRXTableView.reloadData()
        
        getMedicines()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return medicines.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpdateRX") as! UpdateRXCell
        
        let medicine = medicines[indexPath.row]
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
        let patientid = defaults.value(forKey: "PatientID") as! String
        
        medicines.removeAll()
        
        let fetchRequest:NSFetchRequest<Medicines> = Medicines.fetchRequest()
        let predicate = NSPredicate(format: "(userID = %@) AND (patientID = %@)", uid as! CVarArg, patientid)
        fetchRequest.predicate = predicate
        
        do {
            
            let count = try getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            if count > 0 {
                
                let fetchResult = try getContext().fetch(fetchRequest)
                
                for item in fetchResult {
                    
                    //print(item.patientID! + " " + item.medicineName!)
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
    
    @IBAction func addMedicine(_ sender: UIButton) {
        
        if medicineTextField.text == "" {
            
            let alert = UIAlertController(title: "Notice", message: "Add Medicine name", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil);
            
        } else {
            
            let medicineId = NSUUID().uuidString.lowercased() as String
            let patientid = defaults.value(forKey: "PatientID") as! String
            let userID = defaults.value(forKey: "UserID") as! Int32
            
            let context = getContext()
            
            let entity = NSEntityDescription.entity(forEntityName: "Medicines", in: context)
            
            let managedObj = NSManagedObject(entity: entity!, insertInto: context)
            
            managedObj.setValue(medicineId, forKey: "medicineID")
            managedObj.setValue(medicineTextField.text, forKey: "medicineName")
            managedObj.setValue(patientid, forKey: "patientID")
            managedObj.setValue(userID, forKey: "userID")
            
            do {
                try context.save()
                
                medicineTextField.text = ""
                getMedicines()
                updateRXTableView.reloadData()
                checkMedicines()
                
                
            } catch {
                print(error.localizedDescription)
            }
            
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
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func dismissUpdateRX(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    

}
