//
//  Settings.swift
//  Medilexis
//
//  Created by iOS Developer on 21/06/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit

class Settings: UITableViewController {
    
    @IBOutlet var photosSwitch: UISwitch!
    @IBOutlet var anotherPhotoSwitch: UISwitch!
    @IBOutlet var cptSwitch: UISwitch!
    @IBOutlet var rxSwitch: UISwitch!
    @IBOutlet var menuButton: UIBarButtonItem!
    @IBOutlet var changedQATranscription: UISwitch!
    
    
    let defaults = UserDefaults.standard
    var photos : Bool = true
    var cpt : Bool = true
    var rx : Bool = true
    var anotherphoto : Bool = true
    var qaBasedTranscription : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        photosSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        cptSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        rxSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        anotherPhotoSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        changedQATranscription.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    
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
        return 6
    }
    
    @IBAction func photoSwitchChanged(_ sender: UISwitch) {
        
        
        if photosSwitch.isOn{
            
            photos = true
            defaults.set(photos, forKey: "photos")
        } else{
            
            photos = false
            defaults.set(photos, forKey: "photos")
        }
    }
    
    @IBAction func changedCPTSwitch(_ sender: UISwitch) {
        
        if cptSwitch.isOn{
            cpt = true
            defaults.set(cpt, forKey: "cpt")
        } else{
            cpt = false
            defaults.set(cpt, forKey: "cpt")
        }
    }
    
    @IBAction func changedRXSwitch(_ sender: UISwitch) {
        
        if rxSwitch.isOn{
            rx = true
            defaults.set(rx, forKey: "rx")
        } else{
            rx = false
            defaults.set(rx, forKey: "rx")
        }
    }
    
    @IBAction func changedAnotherPhotoSwitch(_ sender: UISwitch) {
        
        if anotherPhotoSwitch.isOn{
            
            anotherphoto = true
            defaults.set(anotherphoto, forKey: "anotherphoto")
        } else{
            
            anotherphoto = false
            defaults.set(anotherphoto, forKey: "anotherphoto")
        }
    }
    
    @IBAction func changedQATranscriptionSwitch(_ sender: UISwitch) {
        
        if changedQATranscription.isOn{
            
            qaBasedTranscription = true
            defaults.set(qaBasedTranscription, forKey: "qaTranscription")
            
        } else{
            
            qaBasedTranscription = false
            defaults.set(qaBasedTranscription, forKey: "qaTranscription")
        }
    }
    
    
    @IBAction func navigateToHome(_ sender: UIBarButtonItem) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if defaults.value(forKey: "photos") != nil{
            let switchON: Bool = defaults.value(forKey: "photos")  as! Bool
            if switchON == true{
                photosSwitch.setOn(true, animated:true)
            }
            else if switchON == false{
                photosSwitch.setOn(false, animated:true)
            }
        }
        
        if defaults.value(forKey: "cpt") != nil{
            let switchON: Bool = defaults.value(forKey: "cpt")  as! Bool
            if switchON == true{
                cptSwitch.setOn(true, animated:true)
            }
            else if switchON == false{
                cptSwitch.setOn(false, animated:true)
            }
        }
        
        if defaults.value(forKey: "rx") != nil{
            let switchON: Bool = defaults.value(forKey: "rx")  as! Bool
            if switchON == true{
                rxSwitch.setOn(true, animated:true)
            }
            else if switchON == false{
                rxSwitch.setOn(false, animated:true)
            }
        }
        
        if defaults.value(forKey: "anotherphoto") != nil{
            let switchON: Bool = defaults.value(forKey: "anotherphoto")  as! Bool
            if switchON == true{
                anotherPhotoSwitch.setOn(true, animated:true)
            }
            else if switchON == false{
                anotherPhotoSwitch.setOn(false, animated:true)
            }
        }
        
        if defaults.value(forKey: "qaTranscription") != nil{
            let switchON: Bool = defaults.value(forKey: "qaTranscription")  as! Bool
            if switchON == true{
                changedQATranscription.setOn(true, animated:true)
            }
            else if switchON == false{
                changedQATranscription.setOn(false, animated:true)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        if indexPath.row == 5 {
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "subscription") as! Subscriptions
            self.present(nextViewController, animated:true, completion:nil)
            
        }
        
    }
}
