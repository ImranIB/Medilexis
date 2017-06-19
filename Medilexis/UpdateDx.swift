//
//  UpdateDx.swift
//  Medilexis
//
//  Created by iOS Developer on 31/05/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit
import CoreData
import SkyFloatingLabelTextField

class UpdateDx: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var dxTableView: UITableView!
    @IBOutlet weak var descriptionTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var codeTextField: SkyFloatingLabelTextField!
    @IBOutlet var noRecordLabel: UILabel!
    

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults.standard
    var dxDetail = [Diagnostics]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor =  UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        self.dxTableView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        
        descriptionTextField.title = "Description"
        descriptionTextField.titleFormatter = { $0 }
        descriptionTextField.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        self.view.addSubview(descriptionTextField)
        
        codeTextField.title = "Code"
        codeTextField.titleFormatter = { $0 }
        codeTextField.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        self.view.addSubview(codeTextField)
        
        self.dxTableView.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dxDetail.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpdateDx") as! UpdateDxCell
        
        let detail = dxDetail[indexPath.row]
        cell.descriptionLabel?.text = detail.discription
        cell.codeLabel.text = detail.code
        return cell
    }
    
    func fetchDXList(){
        
        let uid = defaults.value(forKey: "UserID")
        let patientid = defaults.value(forKey: "PatientID") as! String
        
        dxDetail.removeAll()
        
        let fetchRequest:NSFetchRequest<Diagnostics> = Diagnostics.fetchRequest()
        let predicate = NSPredicate(format: "(userID = %@) AND (patientID = %@) AND (type = %@) ", uid as! CVarArg, patientid, "DX")
        fetchRequest.predicate = predicate
        
        do {
            
            let count = try getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            if count > 0 {
                
                let fetchResult = try getContext().fetch(fetchRequest)
                
                for item in fetchResult {
    
                    dxDetail.append(item)
                    dxTableView.reloadData()
                    checkDx()
                }
            } else {
                
                dxDetail.removeAll()
                dxTableView.reloadData()
                checkDx()
                
            }
            
        }catch {
            print(error.localizedDescription)
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
            let userID = defaults.value(forKey: "UserID") as! Int32
            let patientID = defaults.value(forKey: "PatientID")
            
            let context = getContext()
            
            let entity = NSEntityDescription.entity(forEntityName: "Diagnostics", in: context)
            
            let managedObj = NSManagedObject(entity: entity!, insertInto: context)
            
            managedObj.setValue(descriptionTextField.text, forKey: "discription")
            managedObj.setValue(codeTextField.text, forKey: "code")
            managedObj.setValue(codesId, forKey: "diagnosticID")
            managedObj.setValue("DX", forKey: "type")
            managedObj.setValue(userID, forKey: "userID")
            managedObj.setValue(patientID, forKey: "patientID")
            
            do {
                try context.save()
                
                descriptionTextField.text = ""
                codeTextField.text = ""
                fetchDXList()
                checkDx()
                dxTableView.reloadData()
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func checkDx(){
        
        if dxDetail.count == 0 {
            noRecordLabel.isHidden = false
            noRecordLabel.text = "No DX exists."
            
        } else {
            noRecordLabel.isHidden = true
            noRecordLabel.text = ""
        }
    }
    
    func getContext () -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.dxTableView.reloadData()
        fetchDXList()
    }


}
