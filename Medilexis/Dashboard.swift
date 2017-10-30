//
//  DashboardVC.swift
//  Medilexis
//
//  Created by iOS Developer on 20/02/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit
import CoreData

class Dashboard: UIViewController {


    @IBOutlet weak var dashboardItem: UINavigationItem!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    let defaults = UserDefaults.standard
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    @IBAction func scheduledAppointments(_ sender: UIButton) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "scheduledappointments") as! ScheduledAppointments
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func searchPatients(_ sender: UIButton) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "patientsList") as! PatientsList
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func newAppointment(_ sender: UIButton) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "WalkInPatients") as! NewAppointment
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func addPatient(_ sender: UIButton) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "addpatient") as! AddPatient
        self.present(nextViewController, animated:true, completion:nil)
    }
    
}
