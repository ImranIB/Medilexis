//
//  UpdateCpt.swift
//  Medilexis
//
//  Created by iOS Developer on 31/05/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit
import CoreData
import XLActionController

class UpdateCpt: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var cptTableView: UITableView!
    @IBOutlet var noRecordLabel: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults.standard
    var diagnosticDetail = [Diagnostics]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor =  UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        self.cptTableView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        
        defaults.set("CPT", forKey: "DiagnosticType")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return diagnosticDetail.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpdateCpt") as! UpdateCptCell
        
        let detail = diagnosticDetail[indexPath.row]
        cell.descriptionLabel?.text = detail.discription
        cell.codeLabel.text = detail.code
        return cell
    }

    func fetchList(){
        
        let uid = defaults.value(forKey: "UserID")
        let AppointmentID = defaults.value(forKey: "AppointmentID") as! String
        
        diagnosticDetail.removeAll()
        
        let fetchRequest:NSFetchRequest<Diagnostics> = Diagnostics.fetchRequest()
        let predicate = NSPredicate(format: "(userID = %@) AND (appointmentID = %@) AND (type = %@) ", uid as! CVarArg, AppointmentID, "CPT")
        fetchRequest.predicate = predicate
        
        do {
            
            let count = try getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            if count > 0 {
                
                let fetchResult = try getContext().fetch(fetchRequest)
                
                for item in fetchResult {
                    diagnosticDetail.append(item)
                    cptTableView.reloadData()
                    checkCPT()
   
                }
            } else {
           
                diagnosticDetail.removeAll()
                cptTableView.reloadData()
                checkCPT()

            }
            
        }catch {
            print(error.localizedDescription)
        }
        
    }
    
    func checkCPT(){
        
        if diagnosticDetail.count == 0 {
            noRecordLabel.isHidden = false
            noRecordLabel.text = "No CPT exists."
            
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
        
        self.cptTableView.reloadData()
        fetchList()
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
                
                let codesId = NSUUID().uuidString.lowercased() as String
                let userID = self.defaults.value(forKey: "UserID") as! Int32
                let AppointmentID = self.defaults.value(forKey: "AppointmentID") as! String
                let description = descriptionTextField.text?.capitalized
                
                let context = self.getContext()
                
                let entity = NSEntityDescription.entity(forEntityName: "Diagnostics", in: context)
                
                let managedObj = NSManagedObject(entity: entity!, insertInto: context)
                
                managedObj.setValue(description, forKey: "discription")
                managedObj.setValue(codeTextField.text, forKey: "code")
                managedObj.setValue(codesId, forKey: "diagnosticID")
                managedObj.setValue("CPT", forKey: "type")
                managedObj.setValue(userID, forKey: "userID")
                managedObj.setValue(AppointmentID, forKey: "appointmentID")
                
                do {
                    try context.save()
                    
                    descriptionTextField.text = ""
                    codeTextField.text = ""
                    self.fetchList()
                    self.checkCPT()
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
    
    @IBAction func saveExit(_ sender: UIButton) {
        
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
  
    
}
