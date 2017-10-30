//
//  Dx.swift
//  Medilexis
//
//  Created by iOS Developer on 19/05/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit
import CoreData
import XLActionController
import SkyFloatingLabelTextField

class Dx: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var dxTableView: UITableView!
    @IBOutlet var saveExitButton: UIButton!
    @IBOutlet var saveExitLabel: UILabel!

    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults.standard
    var DXCodes = [DiagnosticList]()
    var dxDescription = ["Infectious and parasitic diseases", "Neoplasms", "Mental disorders", "Diseases of the nervous system", "Diseases of the sense organs", "Diseases of the circulatory system", "Diseases of the respiratory system" , "Congenital anomalies", "Symptoms, signs, and ill-defined conditions",  "Injury and poisoning"]
    var dxCode = ["001-139", "140-239", "290-319", "320-359", "360-389", "390-459", "460-519","740-759", "780-799", "800-999"]
    var dxIsSelected = Array(repeating: false, count: 1000)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let DxCodesGenerated = "DxCodesGenerated"
        let codesValue = defaults.bool(forKey: DxCodesGenerated)
        
        if !codesValue {
            defaults.set(true, forKey: DxCodesGenerated)
            
            let context = getContext()
            
            let entity = NSEntityDescription.entity(forEntityName: "DiagnosticList", in: context)
            
            for (name, code) in zip(dxDescription, dxCode){
                
                let managedObj = NSManagedObject(entity: entity!, insertInto: context)
                
                let codeId = NSUUID().uuidString.lowercased() as String
                
                managedObj.setValue(name, forKey: "name")
                managedObj.setValue(code, forKey: "code")
                managedObj.setValue(codeId, forKey: "codeID")
                managedObj.setValue("DX", forKey: "type")
                
                do {
                    try context.save()
                    print("Done")
                    
                    
                } catch {
                    print(error.localizedDescription)
                }
                
            }
        }
        
        saveExitButton.isEnabled = false
        saveExitLabel.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return DXCodes.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DX") as! DxCell
        
        let detail = DXCodes[indexPath.row]
        cell.descriptionTextField?.text = detail.name
        cell.codeTextFIeld.text = detail.code
        cell.accessoryType = dxIsSelected[indexPath.row] ? .checkmark : .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detail = DXCodes[indexPath.row]
        let cell = dxTableView.cellForRow(at: indexPath)
        
        
        if self.dxIsSelected[indexPath.row] == false {

            saveExitButton.isEnabled = true
            saveExitLabel.isEnabled = true
            
            // Toggle check-in and undo-check-in
            self.dxIsSelected[indexPath.row] = self.dxIsSelected[indexPath.row] ? false : true
            cell?.accessoryType = self.dxIsSelected[indexPath.row] ? .checkmark : .none
            cell?.tintColor = UIColor(red: 0/255.0, green: 172/255.0, blue: 233/255.0, alpha: 1.0)
            
            let userID = defaults.value(forKey: "UserID") as! Int32
            let AppointmentID = defaults.value(forKey: "AppointmentID")
            
            let context = getContext()
            
            let entity = NSEntityDescription.entity(forEntityName: "Diagnostics", in: context)
            
            let managedObj = NSManagedObject(entity: entity!, insertInto: context)
            
            managedObj.setValue(detail.codeID!, forKey: "diagnosticID")
            managedObj.setValue(userID, forKey: "userID")
            managedObj.setValue(AppointmentID, forKey: "appointmentID")
            managedObj.setValue(detail.name, forKey: "discription")
            managedObj.setValue(detail.code!, forKey: "code")
            managedObj.setValue("DX", forKey: "type")
            
            do {
                try context.save()
                
                
            } catch {
                print(error.localizedDescription)
            }
            
            
        } else {
       
            // Toggle check-in and undo-check-in
            self.dxIsSelected[indexPath.row] = self.dxIsSelected[indexPath.row] ? false : true
            cell?.accessoryType = self.dxIsSelected[indexPath.row] ? .checkmark : .none
            cell?.tintColor = UIColor(red: 0/255.0, green: 172/255.0, blue: 233/255.0, alpha: 1.0)
            
            let fetchRequest: NSFetchRequest<Diagnostics> = Diagnostics.fetchRequest()
            let predicate = NSPredicate(format: "(diagnosticID = %@) AND (type = %@)", detail.codeID!, "DX")
            fetchRequest.predicate = predicate
            
            do {
                let fetchResult = try getContext().fetch(fetchRequest)
                
                for item in fetchResult {
                    
                    context.delete(item)
                    
                    try context.save()
                    
                    checkDX()
                    
                }
            }catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    
    func getDXCodes(){
        
        DXCodes.removeAll()
        
        let fetchRequest:NSFetchRequest<DiagnosticList> = DiagnosticList.fetchRequest()
        let predicate = NSPredicate(format: "(type = %@)", "DX")
        fetchRequest.predicate = predicate
        
        do {
            let count = try getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            if count > 0 {
                
                let fetchResult = try getContext().fetch(fetchRequest)
                
                for item in fetchResult {
                    
                    DXCodes.append(item)
                    dxTableView.reloadData()
                }
            } else {
                DXCodes.removeAll()
                dxTableView.reloadData()

            }
            
        }catch {
            print(error.localizedDescription)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        dxTableView.reloadData()
        getDXCodes()
        
        saveExitButton.isEnabled = false
        saveExitButton.isEnabled = false
    }

    func getContext () -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    @IBAction func addDX(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Add New DX", message: "", preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
            alert -> Void in
            
            let descriptionTextField = alertController.textFields![0] as UITextField
            let codeTextField = alertController.textFields![1] as UITextField
            
            if descriptionTextField.text == "" || codeTextField.text == "" {
                
                let alert = UIAlertController(title: "Notice", message: "Please fill all the fields", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil);
                
            } else {
                
                let description = descriptionTextField.text?.capitalized
                let codesId = NSUUID().uuidString.lowercased() as String
                
                let context = self.getContext()
                
                let entity = NSEntityDescription.entity(forEntityName: "DiagnosticList", in: context)
                
                let managedObj = NSManagedObject(entity: entity!, insertInto: context)
                
                managedObj.setValue(description, forKey: "name")
                managedObj.setValue(codeTextField.text, forKey: "code")
                managedObj.setValue(codesId, forKey: "codeID")
                managedObj.setValue("DX", forKey: "type")
                
                do {
                    try context.save()
                    
                    descriptionTextField.text = ""
                    codeTextField.text = ""
                    self.getDXCodes()
                    self.dxTableView.reloadData()
                    
                } catch {
                    print(error.localizedDescription)
                }
                
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: {
            (action : UIAlertAction!) -> Void in
            
        })
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Description"
        }
        
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Code"
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func saveExit(_ sender: UIButton) {
        
        if defaults.value(forKey: "qaTranscription") != nil{
            let switchON: Bool = defaults.value(forKey: "qaTranscription")  as! Bool
           
            if switchON == true{
               
                let alert = UIAlertController(title: "Completed", message: "Encounter completed.Do you want this encounter to be Transcribed?", preferredStyle: UIAlertControllerStyle.alert)
                let yes = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: done)
                let no = UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: noTranscribe)
                alert.addAction(yes)
                alert.addAction(no)
                self.present(alert, animated: true, completion: nil);
                
            }
            else if switchON == false{
              
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
                self.present(nextViewController, animated:true, completion:nil)
                
            }
        }
        
     
    }
    
    func done(alert: UIAlertAction){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    
    func noTranscribe(alert: UIAlertAction){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    
    func checkDX(){
        
        let AppointmentID = defaults.value(forKey: "AppointmentID")
        let fetchRequest: NSFetchRequest<Diagnostics> = Diagnostics.fetchRequest()
        let predicate = NSPredicate(format: "(appointmentID = %@) AND (type = %@)", AppointmentID! as! CVarArg, "DX")
        fetchRequest.predicate = predicate
        
        do {
            let count = try self.getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            if count == 0 {
           
                self.saveExitButton.isEnabled = false
                self.saveExitLabel.isEnabled = false
            }
            
        }catch {
            print(error.localizedDescription)
        }
        
    }
    
    
    
}
