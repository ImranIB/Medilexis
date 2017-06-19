//
//  Dx.swift
//  Medilexis
//
//  Created by iOS Developer on 19/05/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit
import CoreData
import SkyFloatingLabelTextField

class Dx: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var dxTableView: UITableView!
    @IBOutlet weak var descriptionTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var codeTextField: SkyFloatingLabelTextField!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults.standard
    var DXCodes = [DiagnosticList]()
    var dxDescription = ["Infectious and parasitic diseases", "Neoplasms", "Mental disorders", "Diseases of the nervous system", "Congenital anomalies", "Injury and poisoning"]
    var dxCode = ["001-139", "140-239", "290-319", "320-359", "740-759", "800-999"]
    var dxIsSelected = Array(repeating: false, count: 1000)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.view.backgroundColor =  UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
       // self.dxTableView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        
        descriptionTextField.title = "Description"
        descriptionTextField.titleFormatter = { $0 }
        descriptionTextField.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        self.view.addSubview(descriptionTextField)
        
        codeTextField.title = "Code"
        codeTextField.titleFormatter = { $0 }
        codeTextField.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        self.view.addSubview(codeTextField)
        
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

            // Toggle check-in and undo-check-in
            self.dxIsSelected[indexPath.row] = self.dxIsSelected[indexPath.row] ? false : true
            cell?.accessoryType = self.dxIsSelected[indexPath.row] ? .checkmark : .none
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
            managedObj.setValue("DX", forKey: "type")
            
            do {
                try context.save()
                
                
            } catch {
                print(error.localizedDescription)
            }
            
            
        } else {
       
            // Toggle check-in and undo-check-in
            self.dxIsSelected[indexPath.row] = self.dxIsSelected[indexPath.row] ? false : true
            
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
    
    @IBAction func addDX(_ sender: UIButton) {
        
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
            managedObj.setValue("DX", forKey: "type")
            
            do {
                try context.save()
                
                descriptionTextField.text = ""
                codeTextField.text = ""
                getDXCodes()
                dxTableView.reloadData()
                
            } catch {
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
    }

    func getContext () -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }

}
