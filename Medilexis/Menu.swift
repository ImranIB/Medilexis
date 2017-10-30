//
//  Menu.swift
//  Medilexis
//
//  Created by iOS Developer on 17/04/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit

class Menu: UITableViewController {

    @IBOutlet var menuTable: UITableView!
    
    let userDefaults = Foundation.UserDefaults.standard
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
        menuTable.tableFooterView = UIView(frame: .zero)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if indexPath.row == 5 && indexPath.section == 1 {
            
            let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: logout)
            let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: dismiss)
            alert.addAction(action)
            alert.addAction(cancel)
            
            self.present(alert, animated: true, completion: nil);
            
        }
        
        if indexPath.row == 4 && indexPath.section == 1 {
            
            userDefaults.set("SearchAppointments", forKey: "ComingFrom")
    
        }
    }
    
    func logout(alert: UIAlertAction){
       // print("You tapped: \(alert.title)")
        navigate()
        
    }
    
    func dismiss(alert: UIAlertAction){
       // print("You tapped: \(alert.title)")
        menuTable.reloadData()
        
    }
    
    func navigate(){
        
        userDefaults.set( "", forKey: "login")
        userDefaults.set(true, forKey: "photos")
        userDefaults.set(true, forKey: "cpt")
        userDefaults.set(true, forKey: "rx")
        userDefaults.set(true, forKey: "anotherphoto")
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "selection") as! Selection
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        menuTable.reloadData()
    }


}
