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
import SwiftSpinner
import XLActionController
import SimplePDFSwift

class UpdateRX: UIViewController, UITableViewDataSource, UITableViewDelegate , UISearchResultsUpdating, UIDocumentInteractionControllerDelegate{

    @IBOutlet weak var updateRXTableView: UITableView!
    @IBOutlet weak var noMedicineLabel: UILabel!
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
    var medicines = [Medicines]()
    var searchController: UISearchController!
    var searchResults:[Medicines] = []
    var timer: Timer!
    var fileRxStored = ""
    var selection: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor =  UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        self.updateRXTableView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        
     /*   // Add a search bar
        searchController = UISearchController(searchResultsController: nil)
        updateRXTableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Medications"
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.barTintColor = UIColor(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1.0)
        UISearchBar.appearance().tintColor = UIColor.black
        definesPresentationContext = true*/
        
        self.updateRXTableView.reloadData()
        
        getMedicines()
        
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
        
        return medicines.count
        
       /* if searchController.isActive {
            return searchResults.count
        } else {
            return medicines.count
        }*/
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpdateRX") as! UpdateRXCell
       // let medicine = (searchController.isActive) ? searchResults[indexPath.row] : medicines[indexPath.row]
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
        let AppointmentID = defaults.value(forKey: "AppointmentID")
        
        medicines.removeAll()
        
        let fetchRequest:NSFetchRequest<Medicines> = Medicines.fetchRequest()
        let predicate = NSPredicate(format: "(userID = %@) AND (appointmentID = %@)", uid as! CVarArg, AppointmentID as! CVarArg)
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "medicineName", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            
            let count = try getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            if count > 0 {
                
                let fetchResult = try getContext().fetch(fetchRequest)
                
                for item in fetchResult {
                    
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
        
        if selection == true {
            
            self.saveButton.isHidden = false
            self.nextButton.isHidden = false
            self.exitButton.isHidden = false
            self.skipButton.isHidden = true
            self.saveLabel.isHidden = false
            self.nextLabel.isHidden = false
            self.exitLabel.isHidden = false
            self.skipLabel.isHidden = true
            self.saveLine.isHidden = false
            self.nextLine.isHidden = true
            self.exitLine.isHidden = true
            self.skipLine.isHidden = true
        }
        
    }
    
    // MARK: - UIDocumentInteractionControllerDelegate
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    @IBAction func navigateToHome(_ sender: UIBarButtonItem) {
        
        let actionController = YoutubeActionController()
        
        actionController.addAction(Action(ActionData(title: "Medications List", image: UIImage(named: "list")!), style: .default, handler: { action in
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "RxList") as! FetchRxList
            self.present(nextViewController, animated:true, completion:nil)
            
        }))
        
        actionController.addAction(Action(ActionData(title: "Add New Medication", image: UIImage(named: "add")!), style: .default, handler: { action in
            
            let alertController = UIAlertController(title: "Enter Medication Name", message: "", preferredStyle: .alert)
            
            let saveAction = UIAlertAction(title: "Save", style: .default, handler: {
                alert -> Void in
                
                let medicineTextField = alertController.textFields![0] as UITextField
                
                
                if medicineTextField.text == "" {
                    
                    let alert = UIAlertController(title: "Notice", message: "Please fill the field", preferredStyle: UIAlertControllerStyle.alert)
                    let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                    alert.addAction(action)
                    
                    self.present(alert, animated: true, completion: nil);
                    
                } else {
                    
                    self.saveButton.isHidden = false
                    self.nextButton.isHidden = false
                    self.exitButton.isHidden = false
                    self.skipButton.isHidden = true
                    self.saveLabel.isHidden = false
                    self.nextLabel.isHidden = false
                    self.exitLabel.isHidden = false
                    self.skipLabel.isHidden = true
                    self.saveLine.isHidden = false
                    self.nextLine.isHidden = true
                    self.exitLine.isHidden = true
                    self.skipLine.isHidden = true
                    
                    let medicine = medicineTextField.text?.capitalized
                    let medicineId = NSUUID().uuidString.lowercased() as String
                    let AppointmentID = self.defaults.value(forKey: "AppointmentID") as! String
                    let userID = self.defaults.value(forKey: "UserID") as! Int32
                    
                    let context = self.getContext()
                    
                    let entity = NSEntityDescription.entity(forEntityName: "Medicines", in: context)
                    
                    let managedObj = NSManagedObject(entity: entity!, insertInto: context)
                    
                    managedObj.setValue(medicineId, forKey: "medicineID")
                    managedObj.setValue(medicine, forKey: "medicineName")
                    managedObj.setValue(AppointmentID, forKey: "appointmentID")
                    managedObj.setValue(userID, forKey: "userID")
                    
                    do {
                        try context.save()
                        
                        medicineTextField.text = ""
                        self.getMedicines()
                        self.updateRXTableView.reloadData()
                        self.checkMedicines()
                        self.fileRxStored = "false"
                    
                        
                        
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
        
        actionController.addAction(Action(ActionData(title: "Preview", image: UIImage(named: "preview")!), style: .default, handler: { action in
            
            let pdf = SimplePDF(pdfTitle: "PRINT TEMPLATE", authorName: "Muhammad Imran")
            
            self.addDocumentCover(pdf)
            self.addDocumentContent(pdf)
            self.addHeadersFooters(pdf)
            
            // here we may want to save the pdf somewhere or show it to the user
            let tmpPDFPath = pdf.writePDFWithoutTableOfContents()
            
            // open the generated PDF
            DispatchQueue.main.async(execute: { () -> Void in
                let pdfURL = URL(fileURLWithPath: tmpPDFPath)
                let interactionController = UIDocumentInteractionController(url: pdfURL)
                interactionController.delegate = self
                interactionController.presentPreview(animated: true)
                SwiftSpinner.hide()
            })
            
        }))
        
        actionController.addAction(Action(ActionData(title: "Cancel", image: UIImage(named: "cancel")!), style: .default, handler: { action in
        }))
        
        present(actionController, animated: true, completion: nil)
       
    }
    
    fileprivate func addDocumentCover(_ pdf: SimplePDF) {
        
        SwiftSpinner.show("Loading print preview")
        pdf.startNewPage()
    }
    
    fileprivate func addDocumentContent(_ pdf: SimplePDF) {
        
        let dos = defaults.value(forKey: "DOS") as! NSDate
        let pname = defaults.value(forKey: "PatientName") as! String
        let AppointmentID = defaults.value(forKey: "AppointmentID") as! String
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        let dateString = dateFormatter.string(from: dos as Date)
        
        let text1 = ""
        pdf.addBodyText(text1)
        
        let text2 = ""
        pdf.addBodyText(text2)
        
        
        let name = "Patient Name: \(pname)"
        pdf.addBodyText(name)
        
        let date = "Scheduled Date: \(dateString)"
        pdf.addBodyText(date)
        
        let fetchRequest:NSFetchRequest<Sounds> = Sounds.fetchRequest()
        let predicate = NSPredicate(format: "(appointmentID = %@)", AppointmentID)
        fetchRequest.predicate = predicate
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            
            for item in fetchResult {
                
                if item.type == "CC"{
                    
                    pdf.addH6("CHIEF COMPLAINT")
                    pdf.addBodyText(item.transcription!)
                    
                } else if item.type == "HPI"{
                    
                    pdf.addH6("HISTORY OF PRESENT ILLNESS")
                    pdf.addBodyText(item.transcription!)
                    
                } else if item.type == "HX"{
                    
                    pdf.addH6("HISTORY")
                    pdf.addBodyText(item.transcription!)
                    
                } else if item.type == "ROS"{
                    
                    pdf.addH6("REVIEW OF SYSTEMS")
                    pdf.addBodyText(item.transcription!)
                    
                }else if item.type == "PLAN"{
                    
                    pdf.addH6("PLAN")
                    pdf.addBodyText(item.transcription!)
                }
                
            }
        }catch {
            print(error.localizedDescription)
        }
        
    }
    
    fileprivate func addHeadersFooters(_ pdf: SimplePDF) {
        
        let uid = defaults.value(forKey: "UserID")
        let fetchRequest:NSFetchRequest<Users> = Users.fetchRequest()
        let predicate = NSPredicate(format: "(userID = %@)", uid as! CVarArg)
        fetchRequest.predicate = predicate
        
        do {
            let count = try getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            if count > 0 {
                
                let fetchResult = try context.fetch(fetchRequest)
                
                for item in fetchResult {
                    
                    let regularFont = UIFont.systemFont(ofSize: 18)
                    let boldFont = UIFont.boldSystemFont(ofSize: 20)
                    let leftAlignment = NSMutableParagraphStyle()
                    leftAlignment.alignment = NSTextAlignment.left
                    
                    
                    if item.logo != nil {
                        
                        let retrievedImg = UIImage(data: item.logo! as Data)!
                        
                        let rightLogo = SimplePDF.HeaderFooterImage(type: .header, pageRange: NSMakeRange(0, 1),
                                                                    image:retrievedImg, imageHeight: 55, alignment: .right)
                        pdf.headerFooterImages.append(rightLogo)
                    }
                    
                    if item.heading != nil && item.subHeading != nil {
                        
                        // add some document information to the header, on left
                        let leftHeaderString = "\(item.heading!)\n\(item.subHeading!)"
                        let leftHeaderAttrString = NSMutableAttributedString(string: leftHeaderString)
                        leftHeaderAttrString.addAttribute(NSAttributedStringKey.paragraphStyle, value: leftAlignment, range: NSMakeRange(0, leftHeaderAttrString.length))
                        leftHeaderAttrString.addAttribute(NSAttributedStringKey.font, value: regularFont, range: NSMakeRange(0, leftHeaderAttrString.length))
                        leftHeaderAttrString.addAttribute(NSAttributedStringKey.font, value: boldFont, range: leftHeaderAttrString.mutableString.range(of: item.heading!))
                        leftHeaderAttrString.addAttribute(NSAttributedStringKey.font, value: regularFont, range: leftHeaderAttrString.mutableString.range(of: item.subHeading!))
                        let header = SimplePDF.HeaderFooterText(type: .header, pageRange: NSMakeRange(0, Int.max), attributedString: leftHeaderAttrString)
                        pdf.headerFooterTexts.append(header)
                        
                    }
                    
                    if item.footer != nil {
                        
                        // add a link to your app may be
                        
                        let link = NSMutableAttributedString(string: item.footer!)
                        link.addAttribute(NSAttributedStringKey.paragraphStyle, value: leftAlignment, range: NSMakeRange(0, link.length))
                        link.addAttribute(NSAttributedStringKey.font, value: regularFont, range: NSMakeRange(0, link.length))
                        let appLinkFooter = SimplePDF.HeaderFooterText(type: .footer, pageRange: NSMakeRange(0, Int.max), attributedString: link)
                        pdf.headerFooterTexts.append(appLinkFooter)
                    }
                    
                }
                
            }
        }catch {
            print(error.localizedDescription)
        }
        
    }
    
    @IBAction func dismissUpdateRX(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
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
            updateRXTableView.reloadData()
        }
    }
    
    @IBAction func save(_ sender: UIButton) {
        
        saveLine.isHidden = true
        nextLine.isHidden = false
        exitLine.isHidden = true
        self.fileRxStored = "true"
    }
    
    @IBAction func saveNext(_ sender: UIButton) {
        
        if self.fileRxStored == "false" {
            
            let alert = UIAlertController(title: "Hold On", message: "Changes have not been saved. Do you want to leave without saving?", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: self.yes)
            let cancel = UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            alert.addAction(cancel)
            
            
            self.present(alert, animated: true, completion: nil);
            
        } else {
            
            saveButton.isHidden = true
            nextButton.isHidden = true
            exitButton.isHidden = true
            skipButton.isHidden = false
            saveLabel.isHidden = true
            nextLabel.isHidden = true
            exitLabel.isHidden = true
            skipLabel.isHidden = false
            saveLine.isHidden = true
            nextLine.isHidden = true
            exitLine.isHidden = true
            skipLine.isHidden = false
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "updatecpt") as! UpdateCpt
            self.present(nextViewController, animated:true, completion:nil)
        }
        
    }
    
    func yes(alert: UIAlertAction){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "cptCodes") as! Cpt
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
    
    func yesExit(alert: UIAlertAction){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    
    @IBAction func skip(_ sender: UIButton) {
        
        if self.fileRxStored == "false" {
            
            let alert = UIAlertController(title: "Hold On", message: "Changes have not been saved. Do you want to leave without saving?", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: self.yesExit)
            let cancel = UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            alert.addAction(cancel)
            
            
            self.present(alert, animated: true, completion: nil);
            
        } else {
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "updatecpt") as! UpdateCpt
            self.present(nextViewController, animated:true, completion:nil)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        SwiftSpinner.show("Proceeding to next screen")
        
        if defaults.value(forKey: "rx") != nil{
            let switchON: Bool = defaults.value(forKey: "rx")  as! Bool
            if switchON == false{
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Updatecodes") as! UpdateCodes
                self.present(nextViewController, animated:true, completion:nil)
                
                    timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector:  #selector(UpdateRX.UpdateRXLoaderHide), userInfo: nil, repeats: true)
            } else {
                SwiftSpinner.hide()
            }
        }
    }
    
    func UpdateRXLoaderHide(){
        
        SwiftSpinner.hide()
    }
}
