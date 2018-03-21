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
import SwiftSpinner
import SimplePDFSwift

class UpdateCpt: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UIDocumentInteractionControllerDelegate {
    
    @IBOutlet weak var cptTableView: UITableView!
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
    var diagnosticDetail = [Diagnostics]()
    var searchController: UISearchController!
    var searchResults:[Diagnostics] = []
    var fileCptStored = ""
    var selection: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor =  UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        self.cptTableView.backgroundColor = UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        
        defaults.set("CPT", forKey: "DiagnosticType")
        
      /*  // Add a search bar
        searchController = UISearchController(searchResultsController: nil)
        cptTableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search CPT"
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.barTintColor = UIColor(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1.0)
        UISearchBar.appearance().tintColor = UIColor.black
        definesPresentationContext = true */
        
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
        
         return diagnosticDetail.count
     /*   if searchController.isActive {
            return searchResults.count
        } else {
            return diagnosticDetail.count
        }*/
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UpdateCpt") as! UpdateCptCell
    
       // let cpt = (searchController.isActive) ? searchResults[indexPath.row] : diagnosticDetail[indexPath.row]
        let cpt = diagnosticDetail[indexPath.row]
        cell.descriptionLabel?.text = cpt.discription
        cell.codeLabel.text = cpt.code
        return cell
    }

    func fetchList(){
        
        let uid = defaults.value(forKey: "UserID")
        let AppointmentID = defaults.value(forKey: "AppointmentID") as! String
        
        diagnosticDetail.removeAll()
        
        let fetchRequest:NSFetchRequest<Diagnostics> = Diagnostics.fetchRequest()
        let predicate = NSPredicate(format: "(userID = %@) AND (appointmentID = %@) AND (type = %@) ", uid as! CVarArg, AppointmentID, "CPT")
        fetchRequest.predicate = predicate
        let sortDescriptor = NSSortDescriptor(key: "discription", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
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
    
    @IBAction func savePressed(_ sender: UIButton) {
        
        saveLine.isHidden = true
        nextLine.isHidden = false
        exitLine.isHidden = true
        self.fileCptStored = "true"
    }
    
    @IBAction func nextPressed(_ sender: UIButton) {
        
        if self.fileCptStored == "false" {
            
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
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "updateDX") as! UpdateDx
            self.present(nextViewController, animated:true, completion:nil)
        }
    }
    
    func yes(alert: UIAlertAction){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "updateDX") as! UpdateDx
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    
    @IBAction func skipPressed(_ sender: UIButton) {
        
        if self.fileCptStored == "false" {
            
            let alert = UIAlertController(title: "Hold On", message: "Changes have not been saved. Do you want to leave without saving?", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: self.yesExit)
            let cancel = UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            alert.addAction(cancel)
            
            
            self.present(alert, animated: true, completion: nil);
            
        } else {
    
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "updateDX") as! UpdateDx
            self.present(nextViewController, animated:true, completion:nil)
        }
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
    
    func yesExit(alert: UIAlertAction){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    
    // MARK: - UIDocumentInteractionControllerDelegate
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    @IBAction func morePressed(_ sender: UIBarButtonItem) {
        
        let actionController = YoutubeActionController()
        
        actionController.addAction(Action(ActionData(title: "CPT List", image: UIImage(named: "list")!), style: .default, handler: { action in
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "fetchcptlist") as! FetchCptList
            self.present(nextViewController, animated:true, completion:nil)
            
        }))
        
        
        actionController.addAction(Action(ActionData(title: "Add New CPT", image: UIImage(named: "add")!), style: .default, handler: { action in
            
            let alertController = UIAlertController(title: "Enter CPT", message: "", preferredStyle: .alert)
            
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
                        self.fileCptStored = "false"
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
    
    @IBAction func dismissPressed(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func filterContent(for searchText: String) {
        searchResults = diagnosticDetail.filter({ (code) -> Bool in
            if let name = code.discription, let id = code.code{
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
    
}
