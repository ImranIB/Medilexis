//
//  Settings.swift
//  Medilexis
//
//  Created by iOS Developer on 28/02/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit
import SCLAlertView
import CoreData

class Settings: UITableViewController {
    
    let userDefaults = Foundation.UserDefaults.standard
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var tableDate: UITableView!
    
        override func viewDidLoad() {
        super.viewDidLoad()
            
        tableDate.tableFooterView = UIView(frame: .zero)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 4
    }

    @IBAction func settingsDismiss(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.row == 2 {
           
            let appearance = SCLAlertView.SCLAppearance(
                kTitleFont: UIFont(name: "HelveticaNeue", size: 16)!,
                kTextFont: UIFont(name: "HelveticaNeue", size: 13)!,
                kButtonFont: UIFont(name: "HelveticaNeue-Bold", size: 13)!,
                showCloseButton: false
            )
            
            let alert = SCLAlertView(appearance: appearance)
             _ = alert.addButton("Ok", target:self, selector:#selector(Settings.navigate))
            _ = alert.addButton("Cancel") {
                
                self.tableDate.reloadData()
            }
            _ = alert.showInfo("Logout", subTitle: "Are you sure you want to logout?")
            
           //  self.DeleteAllData(entity: "Patients")
            // self.DeleteAllData(entity: "Lists")
            // self.DeleteAllData(entity: "Chart")
            
        }
    }
    
    func navigate(){
        
        userDefaults.set( "", forKey: "login")
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "selection") as! Selection
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
         tableDate.reloadData()
    }
    
    func getContext () -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    @IBAction func navigateToHome(_ sender: UIBarButtonItem) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Dashboard") as! Dashboard
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    
}
