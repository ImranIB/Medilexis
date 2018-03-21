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
import SwiftSpinner
import SimplePDFSwift

class Dx: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchResultsUpdating, UIDocumentInteractionControllerDelegate {
    
    @IBOutlet weak var dxTableView: UITableView!
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
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults.standard
    var DXCodes = [DiagnosticList]()
    var searchResults:[DiagnosticList] = []
    var dxDescription = ["Infectious and parasitic diseases", "Neoplasms", "Mental disorders", "Diseases of the nervous system", "Diseases of the sense organs", "Diseases of the circulatory system", "Diseases of the respiratory system" , "Congenital anomalies", "Symptoms, signs, and ill-defined conditions",  "Injury and poisoning"]
    var dxCode = ["001-139", "140-239", "290-319", "320-359", "360-389", "390-459", "460-519","740-759", "780-799", "800-999"]
    var dxIsSelected = Array(repeating: false, count: 1000)
    var searchController: UISearchController!
    var fileDxStored = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        seperatorLine.frame.origin = CGPoint(x: 0, y: 550)
        dxTableView.frame = CGRect(x: 0, y: 68, width: self.view.frame.size.width, height: 470)
        
        // Add a search bar
        searchController = UISearchController(searchResultsController: nil)
        dxTableView.tableHeaderView = searchController.searchBar
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search DX"
        searchController.searchBar.backgroundImage = UIImage()
        searchController.searchBar.isTranslucent = false
        searchController.searchBar.barTintColor = UIColor(red: 236.0/255.0, green: 236.0/255.0, blue: 236.0/255.0, alpha: 1.0)
        UISearchBar.appearance().tintColor = UIColor.black
        definesPresentationContext = true
        
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
            return DXCodes.count
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DX") as! DxCell
        let dx = (searchController.isActive) ? searchResults[indexPath.row] : DXCodes[indexPath.row]
        cell.descriptionTextField.text = dx.name
        cell.codeTextFIeld.text = dx.code
        cell.accessoryType = dxIsSelected[indexPath.row] ? .checkmark : .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let detail = DXCodes[indexPath.row]
        let cell = dxTableView.cellForRow(at: indexPath)
        fileDxStored = "false"
        
        seperatorLine.frame.origin = CGPoint(x: 0, y: 475)
        dxTableView.frame = CGRect(x: 0, y: 68, width: self.view.frame.size.width, height: 391)
        
        if self.dxIsSelected[indexPath.row] == false {

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
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
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
    
    @IBAction func savePressed(_ sender: UIButton) {
        
        fileDxStored = "true"
        saveLine.isHidden = true
        nextLine.isHidden = false
        exitLine.isHidden = true
    }
    
    @IBAction func nextPressed(_ sender: UIButton) {
        
        if self.fileDxStored == "false" {
            
            let alert = UIAlertController(title: "Hold On", message: "Changes have not been saved. Do you want to leave without saving?", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: self.yesExit)
            let cancel = UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            alert.addAction(cancel)
            
            
            self.present(alert, animated: true, completion: nil);
            
        } else {
           
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
                    
                    let alert = UIAlertController(title: "Completed", message: "Encounter successfully completed.", preferredStyle: UIAlertControllerStyle.alert)
                    let yes = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: completed)
                    alert.addAction(yes)
                    self.present(alert, animated: true, completion: nil);
                    
                }
            }
        }

    }
    
    func yesExit(alert: UIAlertAction){
        
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
        
        if self.fileDxStored == "false" {
            
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
    
    func completed(alert: UIAlertAction){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
        self.present(nextViewController, animated:true, completion:nil)
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
           
                seperatorLine.frame.origin = CGPoint(x: 0, y: 550)
                dxTableView.frame = CGRect(x: 0, y: 68, width: self.view.frame.size.width, height: 470)
                
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
    
    // MARK: - UIDocumentInteractionControllerDelegate
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    @IBAction func morePressed(_ sender: UIBarButtonItem) {
        
        let actionController = YoutubeActionController()
        
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
    
    
    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Search Controller
    
    func filterContent(for searchText: String) {
        searchResults = DXCodes.filter({ (dx) -> Bool in
            if let name = dx.name, let id = dx.code{
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
