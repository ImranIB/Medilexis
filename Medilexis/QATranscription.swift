//
//  QATranscription.swift
//  Medilexis
//
//  Created by iOS Developer on 28/07/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit
import CoreData

class QATranscription: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet var sectionTwo: UITableView!
    let noOfEncounters = ["Upto 250 encounters", "Upto 500 encounters", "Upto 1000 encounters"]
    let amount = ["$100", "$250", "$500"]
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults.standard
    var qaTranscription = [SubscriptionsList]()
    var selectedIndexPath : NSIndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let qaTranscriptionGenerated = "Section2"
        let codesValue = defaults.bool(forKey: qaTranscriptionGenerated)
        
        if !codesValue {
            defaults.set(true, forKey: qaTranscriptionGenerated)
            
            let context = getContext()
            
            let entity = NSEntityDescription.entity(forEntityName: "SubscriptionsList", in: context)
            
            for (text, detail) in zip(noOfEncounters, amount){
                
                let managedObj = NSManagedObject(entity: entity!, insertInto: context)
                
                let subscriptionID = NSUUID().uuidString.lowercased() as String
                
                managedObj.setValue(text, forKey: "noOfEncounters")
                managedObj.setValue(detail, forKey: "amount")
                managedObj.setValue(subscriptionID, forKey: "subscriptionID")
                managedObj.setValue("QA Based Transcription", forKey: "section")
                managedObj.setValue(false, forKey: "completed")
                
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
        
        return qaTranscription.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "QATranscription") as! QATranscriptionCell
        
        let data = qaTranscription[indexPath.row]
        cell.noOfEncounters.text = data.noOfEncounters
        cell.amount.text = data.amount
        
        if data.completed == false {
            
            cell.accessoryType = UITableViewCellAccessoryType.none
            
        } else {
            
            cell.accessoryType = UITableViewCellAccessoryType.checkmark
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let row = qaTranscription[indexPath.row]
        
        if let cell = sectionTwo.cellForRow(at: indexPath as IndexPath) {
            if cell.accessoryType == .checkmark{
                cell.accessoryType = .none
                sectionTwo.reloadData()
                
            }
            else{
                cell.accessoryType = .checkmark
                
                let clearFetchRequest: NSFetchRequest<SubscriptionsList> = SubscriptionsList.fetchRequest()
                let clearPredicate = NSPredicate(format: "(section = %@)", "QA Based Transcription")
                clearFetchRequest.predicate = clearPredicate
                
                do {
                    let fetchResult = try getContext().fetch(clearFetchRequest)
                    
                    for item in fetchResult {
                        
                        item.completed = false
                        try context.save()
                        print("clear subscriptions")
                        
                    }
                }catch {
                    print(error.localizedDescription)
                }
                
                let updateFetchRequest: NSFetchRequest<SubscriptionsList> = SubscriptionsList.fetchRequest()
                let predicate = NSPredicate(format: "(subscriptionID = %@) AND (section = %@)", row.subscriptionID!, "QA Based Transcription")
                updateFetchRequest.predicate = predicate
                
                do {
                    let fetchResult = try getContext().fetch(updateFetchRequest)
                    
                    for item in fetchResult {
                        
                        item.completed = true
                        try context.save()
                        print("update subscription")
                        
                    }
                }catch {
                    print(error.localizedDescription)
                }
                
                
                sectionTwo.reloadData()
                
            }
        }
        
      /*  let row = qaTranscription[indexPath.row]
        
        if (self.selectedIndexPath != nil) {
            
            let cell = sectionTwo.cellForRow(at: self.selectedIndexPath as IndexPath! as IndexPath)
            cell?.accessoryType = .none
            
            let fetchRequest: NSFetchRequest<SubscriptionsList> = SubscriptionsList.fetchRequest()
            let predicate = NSPredicate(format: "(subscriptionID = %@) AND (completed = true)", row.subscriptionID!)
            fetchRequest.predicate = predicate
            
            do {
                let fetchResult = try getContext().fetch(fetchRequest)
                
                for item in fetchResult {
                    
                    item.completed = false
                    try context.save()
                    
                }
            }catch {
                print(error.localizedDescription)
            }
        }
        
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        
        self.selectedIndexPath = indexPath as NSIndexPath
        
        let fetchRequest: NSFetchRequest<SubscriptionsList> = SubscriptionsList.fetchRequest()
        let predicate = NSPredicate(format: "(subscriptionID = %@)", row.subscriptionID!)
        fetchRequest.predicate = predicate
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            
            for item in fetchResult {
                
                item.completed = true
                
                try context.save()
                
            }
        }catch {
            print(error.localizedDescription)
        }*/
        
    }

    func getQATranscription(){
        
        qaTranscription.removeAll()
        
        let fetchRequest:NSFetchRequest<SubscriptionsList> = SubscriptionsList.fetchRequest()
        let predicate = NSPredicate(format: "(section = %@)", "QA Based Transcription")
        fetchRequest.predicate = predicate
        
        do {
            let count = try getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            if count > 0 {
                
                let fetchResult = try getContext().fetch(fetchRequest)
                
                for item in fetchResult {
                    
                    qaTranscription.append(item)
                    sectionTwo.reloadData()
                }
            } else {
                qaTranscription.removeAll()
                sectionTwo.reloadData()
                
            }
            
        }catch {
            print(error.localizedDescription)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        sectionTwo.reloadData()
        getQATranscription()
    }
    
    @IBAction func navigateToHome(_ sender: UIBarButtonItem) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    

    @IBAction func saveExit(_ sender: UIButton) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

        func getContext () -> NSManagedObjectContext {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            return appDelegate.persistentContainer.viewContext
        }
}
