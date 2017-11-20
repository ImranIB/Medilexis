//
//  Cpt.swift
//  Medilexis
//
//  Created by iOS Developer on 19/05/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import XLActionController
import CoreData


class Cpt: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var cptTableView: UITableView!
    @IBOutlet var saveExitBUtton: UIButton!
    @IBOutlet var saveExitLabel: UILabel!
    @IBOutlet var exitLine: UIView!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var saveLabel: UILabel!
    @IBOutlet var saveLine: UIView!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var nextLabel: UILabel!
    @IBOutlet var nextLine: UIView!
    @IBOutlet var skipButton: UIButton!
    @IBOutlet var skipLabel: UILabel!
    @IBOutlet var skipLine: UIView!
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults.standard
    var codes = [DiagnosticList]()
    var cptName = ["Evaluation and Management", "Anesthesia", "Surgery", "Radiology", "Pathology and Laboratory", "Medicine", "Composite measures", "Patient management", " Patient history", "Physical examination"]
    var cptCode = ["99201 – 99499", "99100 – 9914", "10021 – 69990", "70010 – 79999", "80047 – 89398", "90281 – 99199", "0001F-0015F", "0500F-0575F", "1000F-1220F", "2000F-2050F"]
    var cptIsSelected = Array(repeating: false, count: 1000)
    var fileCptStored = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let codesGenerated = "codesGenerated"
        let codesValue = defaults.bool(forKey: codesGenerated)
        
        if !codesValue {
            defaults.set(true, forKey: codesGenerated)
            
            let context = getContext()
            
            let entity = NSEntityDescription.entity(forEntityName: "DiagnosticList", in: context)
            
            for (name, code) in zip(cptName, cptCode){
                    
               let managedObj = NSManagedObject(entity: entity!, insertInto: context)
                    
                let codeId = NSUUID().uuidString.lowercased() as String
         
                managedObj.setValue(name, forKey: "name")
                managedObj.setValue(code, forKey: "code")
                managedObj.setValue(codeId, forKey: "codeID")
                managedObj.setValue("CPT", forKey: "type")
                
                do {
                    try context.save()
                    print("Done")
                    
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
          
        }
        
        saveButton.isHidden = true
        saveLabel.isHidden = true
        saveLine.isHidden = true
        nextButton.isHidden = true
        nextLabel.isHidden = true
        nextLine.isHidden = true
        saveExitBUtton.isHidden = true
        saveExitLabel.isHidden = true
        exitLine.isHidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return codes.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CPT") as! CptCell
        
        let cpt = codes[indexPath.row]
        cell.descriptionFIeld.text = cpt.name
        cell.code.text = cpt.code
        cell.accessoryType = cptIsSelected[indexPath.row] ? .checkmark : .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let detail = codes[indexPath.row]
        let cell = cptTableView.cellForRow(at: indexPath)
        fileCptStored = "false"
        
        if self.cptIsSelected[indexPath.row] == false {
    
            saveExitBUtton.isEnabled = true
            saveExitLabel.isEnabled = true
            
            saveButton.isHidden = false
            saveLabel.isHidden = false
            saveLine.isHidden = false
            nextButton.isHidden = false
            nextLabel.isHidden = false
            nextLine.isHidden = true
            saveExitBUtton.isHidden = false
            saveExitLabel.isHidden = false
            exitLine.isHidden = true
            skipButton.isHidden = true
            skipLabel.isHidden = true
            skipLine.isHidden = true
            
            // Toggle check-in and undo-check-in
            self.cptIsSelected[indexPath.row] = self.cptIsSelected[indexPath.row] ? false : true
            cell?.accessoryType = self.cptIsSelected[indexPath.row] ? .checkmark : .none
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
            managedObj.setValue("CPT", forKey: "type")
            
            do {
                try context.save()
                
                
            } catch {
                print(error.localizedDescription)
            }

            
        } else {
     
       
            // Toggle check-in and undo-check-in
            self.cptIsSelected[indexPath.row] = self.cptIsSelected[indexPath.row] ? false : true
            cell?.accessoryType = self.cptIsSelected[indexPath.row] ? .checkmark : .none
            cell?.tintColor = UIColor(red: 0/255.0, green: 172/255.0, blue: 233/255.0, alpha: 1.0)
            
            let fetchRequest: NSFetchRequest<Diagnostics> = Diagnostics.fetchRequest()
            let predicate = NSPredicate(format: "(diagnosticID = %@) AND (type = %@)", detail.codeID!, "CPT")
            fetchRequest.predicate = predicate
            
            do {
                let fetchResult = try getContext().fetch(fetchRequest)
                
                for item in fetchResult {
                    
                    context.delete(item)
                    
                    try context.save()
                    
                    checkCPT()
                    
                }
            }catch {
                print(error.localizedDescription)
            }

        }

    }
    
    func getCodes(){
        
        codes.removeAll()
        
        let fetchRequest:NSFetchRequest<DiagnosticList> = DiagnosticList.fetchRequest()
        let predicate = NSPredicate(format: "(type = %@)", "CPT")
        fetchRequest.predicate = predicate
        
        do {
            let count = try getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            if count > 0 {
                
                let fetchResult = try getContext().fetch(fetchRequest)
                
                for item in fetchResult {
                    
                    codes.append(item)
                    cptTableView.reloadData()
                }
            } else {
                codes.removeAll()
                cptTableView.reloadData()
                
            }
            
        }catch {
            print(error.localizedDescription)
        }
    }

    
    override func viewWillAppear(_ animated: Bool) {
        cptTableView.reloadData()
        getCodes()
    }
    
    func getContext () -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func done(alert: UIAlertAction){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    
    @IBAction func nextButton(_ sender: UIButton) {
        
        if self.fileCptStored == "false" {
            
            let alert = UIAlertController(title: "Hold On", message: "Changes have not been saved. Do you want to leave without saving?", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: self.yesExit)
            let cancel = UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            alert.addAction(cancel)
            
            
            self.present(alert, animated: true, completion: nil);
            
        } else {
            
            
            saveButton.isHidden = true
            saveLabel.isHidden = true
            saveLine.isHidden = true
            nextButton.isHidden = true
            nextLabel.isHidden = true
            nextLine.isHidden = true
            saveExitBUtton.isHidden = true
            saveExitLabel.isHidden = true
            exitLine.isHidden = true
            skipButton.isHidden = false
            skipLabel.isHidden = false
            skipLine.isHidden = false
            
        }
    }
    
    func yesExit(alert: UIAlertAction){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        
        fileCptStored = "true"
        saveLine.isHidden = true
        nextLine.isHidden = false
        exitLine.isHidden = true
    }
    
    @IBAction func skipBtton(_ sender: UIButton) {
    }
    
    @IBAction func saveExit(_ sender: UIButton) {
        
        if self.fileCptStored == "false" {
            
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
        
        if defaults.value(forKey: "qaTranscription") != nil{
            let switchON: Bool = defaults.value(forKey: "qaTranscription")  as! Bool
            print(switchON)
            
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
    
    func noTranscribe(alert: UIAlertAction){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    
    @IBAction func addCPT(_ sender: UIButton) {
        
        let alertController = UIAlertController(title: "Add New CPT", message: "", preferredStyle: .alert)
        
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
                managedObj.setValue("CPT", forKey: "type")
                
                do {
                    try context.save()
                    
                    descriptionTextField.text = ""
                    codeTextField.text = ""
                    self.getCodes()
                    self.cptTableView.reloadData()
                    
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
    
    func checkCPT(){
        
        let AppointmentID = defaults.value(forKey: "AppointmentID")
        let fetchRequest: NSFetchRequest<Diagnostics> = Diagnostics.fetchRequest()
        let predicate = NSPredicate(format: "(appointmentID = %@) AND (type = %@)", AppointmentID! as! CVarArg, "CPT")
        fetchRequest.predicate = predicate
        
        do {
            let count = try self.getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            if count == 0 {
                
                self.saveExitBUtton.isEnabled = false
                self.saveExitLabel.isEnabled = false
            }
            
        }catch {
            print(error.localizedDescription)
        }
        
    }

}
