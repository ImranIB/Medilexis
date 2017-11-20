//
//  Codes.swift
//  Medilexis
//
//  Created by iOS Developer on 19/05/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit
import XLActionController
import SwiftSpinner

class Codes: UIViewController {
    
    @IBOutlet weak var Cpt: UIView!
    @IBOutlet weak var Dx: UIView!
    @IBOutlet weak var codesNavigationBar: UINavigationItem!
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //self.view.backgroundColor =  UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        
        self.Cpt.alpha = 1
        self.Dx.alpha = 0
        
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 450, height: 50))
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = UIColor(red: 0/255.0, green: 172/255.0, blue: 233/255.0, alpha: 1.0)
        label.font = UIFont(name: "Lato-Regular", size: 20.0)
        label.text = "CURRENT PROCEDURAL\nTERMINOLOGY"
        self.codesNavigationBar.titleView = label
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeSegmentedCtrl(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.Cpt.alpha = 1
                self.Dx.alpha = 0
                
                let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 450, height: 50))
                label.numberOfLines = 2
                label.textAlignment = .center
                label.textColor = UIColor(red: 0/255.0, green: 172/255.0, blue: 233/255.0, alpha: 1.0)
                label.font = UIFont(name: "Lato-Regular", size: 20.0)
                label.text = "CURRENT PROCEDURAL\nTERMINOLOGY"
                self.codesNavigationBar.titleView = label
                
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.Cpt.alpha = 0
                self.Dx.alpha = 1
                
                let label: UILabel = UILabel(frame: CGRect(x: 10, y: 0, width: 450, height: 40))
                label.numberOfLines = 1
                label.textAlignment = .center
                label.textColor = UIColor(red: 0/255.0, green: 172/255.0, blue: 233/255.0, alpha: 1.0)
                label.font = UIFont(name: "Lato-Regular", size: 20.0)
                label.text = "DIAGNOSIS"
                self.codesNavigationBar.titleView = label
                
            })
        }
    }
    
    @IBAction func navigateToHome(_ sender: UIBarButtonItem) {
        
        let actionController = YoutubeActionController()
        
        actionController.addAction(Action(ActionData(title: "Home", image: UIImage(named: "home-icon")!), style: .default, handler: { action in
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
            self.present(nextViewController, animated:true, completion:nil)
            
        }))
        
        actionController.addAction(Action(ActionData(title: "Cancel", image: UIImage(named: "cancel")!), style: .default, handler: { action in
        }))
        
        present(actionController, animated: true, completion: nil)
    }
    
    @IBAction func dismisssCodes(_ sender: UIBarButtonItem) {
        
          dismiss(animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        SwiftSpinner.show("Proceeding to next screen")
        
        if defaults.value(forKey: "cpt") != nil{
            let switchON: Bool = defaults.value(forKey: "cpt")  as! Bool
            if switchON == false{
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
                self.present(nextViewController, animated:true, completion:nil)
                SwiftSpinner.hide()
            } else {
                SwiftSpinner.hide()
            }
        }
    }

}
