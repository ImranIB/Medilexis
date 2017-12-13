//
//  UpdateDx.swift
//  Medilexis
//
//  Created by iOS Developer on 31/05/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit
import CoreData
import XLActionController

class UpdateDx: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var dxTableView: UITableView!
    @IBOutlet var noRecordLabel: UILabel!
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
    var dxDetail = [Diagnostics]()
    var searchController: UISearchController!
    var searchResults:[Diagnostics] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor =  UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        self.dxTableView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        
        defaults.set("DX", forKey: "DiagnosticType")
        
        // Add a search bar
        searchController = UISearchController(searchResultsController: nil)
        dxTableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search DX"
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.barTintColor = UIColor(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1.0)
        UISearchBar.appearance().tintColor = UIColor.black
        definesPresentationContext = true
        
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
            return dxDetail.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpdateDX") as! UpdateDxCell
        
        let dx = (searchController.isActive) ? searchResults[indexPath.row] : dxDetail[indexPath.row]
        cell.descriptionLabel?.text = dx.discription
        cell.codeLabel.text = dx.code
        return cell
    }
    
    func fetchDXList(){
        
        let uid = defaults.value(forKey: "UserID")
        let AppointmentID = defaults.value(forKey: "AppointmentID") as! String
        
        dxDetail.removeAll()
        
        let fetchRequest:NSFetchRequest<Diagnostics> = Diagnostics.fetchRequest()
        let predicate = NSPredicate(format: "(userID = %@) AND (appointmentID = %@) AND (type = %@) ", uid as! CVarArg, AppointmentID, "DX")
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

    func done(alert: UIAlertAction){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        
        saveLine.isHidden = true
        nextLine.isHidden = false
        exitLine.isHidden = true
    }
    
    @IBAction func nextPressed(_ sender: UIButton) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func skipPressed(_ sender: UIButton) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    
    @IBAction func saveExit(_ sender: UIButton) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func morePressed(_ sender: UIBarButtonItem) {
        
        let actionController = YoutubeActionController()
        
        actionController.addAction(Action(ActionData(title: "DX List", image: UIImage(named: "list")!), style: .default, handler: { action in
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "fetchdxlist") as! FetchDxList
            self.present(nextViewController, animated:true, completion:nil)
            
        }))
        
        
        actionController.addAction(Action(ActionData(title: "Add New DX", image: UIImage(named: "add")!), style: .default, handler: { action in
            
            let alertController = UIAlertController(title: "Enter DX", message: "", preferredStyle: .alert)
            
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
                    managedObj.setValue("DX", forKey: "type")
                    managedObj.setValue(userID, forKey: "userID")
                    managedObj.setValue(AppointmentID, forKey: "appointmentID")
                    
                    do {
                        try context.save()
                        
                        descriptionTextField.text = ""
                        codeTextField.text = ""
                        self.fetchDXList()
                        self.checkDx()
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
            
        }))
        
        actionController.addAction(Action(ActionData(title: "Cancel", image: UIImage(named: "cancel")!), style: .default, handler: { action in
        }))
        
        present(actionController, animated: true, completion: nil)
    }
    
    
    
    func filterContent(for searchText: String) {
        searchResults = dxDetail.filter({ (dx) -> Bool in
            if let name = dx.discription, let id = dx.code{
                let isMatch = name.localizedCaseInsensitiveContains(searchText) || id.localizedCaseInsensitiveContains(searchText)
                return isMatch
            }
            
            return false
        })
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchText = searchController.searchBar.text {
            filterContent(for: searchText)
            dxTableView.reloadData()
        }
    }

}
