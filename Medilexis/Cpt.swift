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


class Cpt: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var cptTableView: UITableView!
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
    @IBOutlet var seperatorLine: UIView!
    @IBOutlet var noCptLabel: UILabel!
    @IBOutlet var cptNavigationItem: UINavigationItem!
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults.standard
    var codes = [DiagnosticList]()
    var searchResults:[DiagnosticList] = []
    var cptName = ["Evaluation and Management", "Anesthesia", "Surgery", "Radiology", "Pathology and Laboratory", "Medicine", "Composite measures", "Patient management", " Patient history", "Physical examination"]
    var cptCode = ["99201 – 99499", "99100 – 9914", "10021 – 69990", "70010 – 79999", "80047 – 89398", "90281 – 99199", "0001F-0015F", "0500F-0575F", "1000F-1220F", "2000F-2050F"]
    var searchController: UISearchController!
    var cptIsSelected = Array(repeating: false, count: 1000)
    var fileCptStored = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 450, height: 50))
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = UIColor(red: 0/255.0, green: 172/255.0, blue: 233/255.0, alpha: 1.0)
        label.font = UIFont(name: "Lato-Regular", size: 20.0)
        label.text = "CURRENT PROCEDURAL\nTERMINOLOGY"
        self.cptNavigationItem.titleView = label
        
        seperatorLine.frame.origin = CGPoint(x: 0, y: 550)
        cptTableView.frame = CGRect(x: 0, y: 68, width: self.view.frame.size.width, height: 470)
        
        // Add a search bar
        searchController = UISearchController(searchResultsController: nil)
        cptTableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search CPT"
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.isTranslucent = false
        searchController.searchBar.barTintColor = UIColor(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1.0)
        UISearchBar.appearance().tintColor = UIColor.black
        definesPresentationContext = true
        
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
        saveNextButton.isHidden = true
        saveButton.isHidden = true
        saveNextLabel.isHidden = true
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
            return codes.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CPT") as! CptCell
        let cpt = (searchController.isActive) ? searchResults[indexPath.row] : codes[indexPath.row]
        cell.descriptionFIeld.text = cpt.name
        cell.code.text = cpt.code
        cell.accessoryType = cptIsSelected[indexPath.row] ? .checkmark : .none
        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        let detail = codes[indexPath.row]
        let cell = cptTableView.cellForRow(at: indexPath)
        fileCptStored = "false"
        
        seperatorLine.frame.origin = CGPoint(x: 0, y: 475)
        cptTableView.frame = CGRect(x: 0, y: 68, width: self.view.frame.size.width, height: 391)
        
        if self.cptIsSelected[indexPath.row] == false {
            
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
    
    // MARK: - Search Controller
    
    func filterContent(for searchText: String) {
        searchResults = codes.filter({ (code) -> Bool in
            if let name = code.name, let id = code.code{
                let isMatch = name.localizedCaseInsensitiveContains(searchText) || id.localizedCaseInsensitiveContains(searchText)
                return isMatch
            }
            
            return false
        })
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            cptTableView.reloadData()
        }
    }
    
    func getCodes(){
        
        codes.removeAll()
        
        let fetchRequest:NSFetchRequest<DiagnosticList> = DiagnosticList.fetchRequest()
        let predicate = NSPredicate(format: "(type = %@)", "CPT")
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
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
    
    @IBAction func saveNextPressed(_ sender: UIButton) {
        
        
        if self.fileCptStored == "false" {
            
            let alert = UIAlertController(title: "Hold On", message: "Changes have not been saved. Do you want to leave without saving?", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: self.yesExit)
            let cancel = UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            alert.addAction(cancel)
            
            
            self.present(alert, animated: true, completion: nil);
            
        } else {
            
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "dxCodes") as! Dx
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
  
    
    @IBAction func skipPressed(_ sender: UIButton) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "dxCodes") as! Dx
        self.present(nextViewController, animated:true, completion:nil)
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
    }
    
    func noTranscribe(alert: UIAlertAction){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    
    func checkCPT(){
        
        let AppointmentID = defaults.value(forKey: "AppointmentID")
        let fetchRequest: NSFetchRequest<Diagnostics> = Diagnostics.fetchRequest()
        let predicate = NSPredicate(format: "(appointmentID = %@) AND (type = %@)", AppointmentID! as! CVarArg, "CPT")
        fetchRequest.predicate = predicate
        
        do {
            let count = try self.getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            if count == 0 {
                
                seperatorLine.frame.origin = CGPoint(x: 0, y: 550)
                cptTableView.frame = CGRect(x: 0, y: 68, width: self.view.frame.size.width, height: 470)
                
                saveNextButton.isHidden = true
                saveButton.isHidden = true
                skipButton.isHidden = false
                skipLabel.isHidden = false
                saveNextLabel.isHidden = true
                saveLabel.isHidden = true
                saveLine.isHidden = true
                nextLine.isHidden = true
                exitLine.isHidden = true
                skipLine.isHidden = false
            }
            
        }catch {
            print(error.localizedDescription)
        }
        
    }
    
    @IBAction func morePressed(_ sender: UIBarButtonItem) {
        
        let actionController = YoutubeActionController()
        
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
        
        actionController.addAction(Action(ActionData(title: "Cancel", image: UIImage(named: "cancel")!), style: .default, handler: { action in
        }))
        
        present(actionController, animated: true, completion: nil)
    }
    
    
    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
}
