//
//  Cpt.swift
//  Medilexis
//
//  Created by iOS Developer on 19/05/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
import CoreData

class Cpt: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var cptTableView: UITableView!
    @IBOutlet weak var descriptionTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var codeTextField: SkyFloatingLabelTextField!
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults.standard
    var codes = [DiagnosticList]()
    var cptName = ["Evaluation and Management", "Anesthesia", "Surgery", "Radiology", "Pathology and Laboratory", "Medicine"]
    var cptCode = ["99201 – 99499", "99100 – 9914", "10021 – 69990", "70010 – 79999", "80047 – 89398", "90281 – 99199"]
    var cptIsSelected = Array(repeating: false, count: 1000)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // self.view.backgroundColor =  UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        //self.cptTableView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        
        descriptionTextField.title = "Description"
        descriptionTextField.titleFormatter = { $0 }
        descriptionTextField.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        self.view.addSubview(descriptionTextField)
        
        codeTextField.title = "Code"
        codeTextField.titleFormatter = { $0 }
        codeTextField.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        self.view.addSubview(codeTextField)
        
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
        
        
        if self.cptIsSelected[indexPath.row] == false {
    
            // Toggle check-in and undo-check-in
            self.cptIsSelected[indexPath.row] = self.cptIsSelected[indexPath.row] ? false : true
            cell?.accessoryType = self.cptIsSelected[indexPath.row] ? .checkmark : .none
            cell?.tintColor = UIColor(red: 0/255.0, green: 172/255.0, blue: 233/255.0, alpha: 1.0)
            
            let userID = defaults.value(forKey: "UserID") as! Int32
            let patientID = defaults.value(forKey: "PatientID")
            
            let context = getContext()
            
            let entity = NSEntityDescription.entity(forEntityName: "Diagnostics", in: context)
            
            let managedObj = NSManagedObject(entity: entity!, insertInto: context)
            
            managedObj.setValue(detail.codeID!, forKey: "diagnosticID")
            managedObj.setValue(userID, forKey: "userID")
            managedObj.setValue(patientID, forKey: "patientID")
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
            
            let fetchRequest: NSFetchRequest<Diagnostics> = Diagnostics.fetchRequest()
            let predicate = NSPredicate(format: "(diagnosticID = %@)", detail.codeID!)
            fetchRequest.predicate = predicate
            
            do {
                let fetchResult = try getContext().fetch(fetchRequest)
                
                for item in fetchResult {
                    
                    context.delete(item)
                    
                    try context.save()
                    
                }
            }catch {
                print(error.localizedDescription)
            }

        }

    }
    
    @IBAction func addCPT(_ sender: UIButton) {
        
        
        if descriptionTextField.text == "" || codeTextField.text == "" {
            
            let alert = UIAlertController(title: "Notice", message: "Please fill all the fields", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil);
            
        } else {
            
            let codesId = NSUUID().uuidString.lowercased() as String
            
            let context = getContext()
            
            let entity = NSEntityDescription.entity(forEntityName: "DiagnosticList", in: context)
            
            let managedObj = NSManagedObject(entity: entity!, insertInto: context)
            
            managedObj.setValue(descriptionTextField.text, forKey: "name")
            managedObj.setValue(codeTextField.text, forKey: "code")
            managedObj.setValue(codesId, forKey: "codeID")
            managedObj.setValue("CPT", forKey: "type")
            
            do {
                try context.save()
                
                descriptionTextField.text = ""
                codeTextField.text = ""
                getCodes()
                cptTableView.reloadData()
                
            } catch {
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
    

}
