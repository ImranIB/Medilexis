//
//  UpdateCodes.swift
//  Medilexis
//
//  Created by iOS Developer on 31/05/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit
import SwiftSpinner
import XLActionController

class UpdateCodes: UIViewController {

    @IBOutlet weak var cpt: UIView!
    @IBOutlet weak var dx: UIView!
    @IBOutlet weak var updateCodesItem: UINavigationItem!
    
      let defaults = UserDefaults.standard
      var timer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor =  UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        
        self.cpt.alpha = 1
        self.dx.alpha = 0
        
        let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 450, height: 50))
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = UIColor(red: 0/255.0, green: 172/255.0, blue: 233/255.0, alpha: 1.0)
        label.font = UIFont(name: "Lato-Regular", size: 20.0)
        label.text = "CURRENT PROCEDURAL\nTERMINOLOGY"
        self.updateCodesItem.titleView = label
        
        defaults.set("CPT", forKey: "DiagnosticType")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changeSegmentedCtrl(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            UIView.animate(withDuration: 0.5, animations: {
                self.cpt.alpha = 1
                self.dx.alpha = 0
                
                let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 450, height: 50))
                label.numberOfLines = 2
                label.textAlignment = .center
                label.textColor = UIColor(red: 0/255.0, green: 172/255.0, blue: 233/255.0, alpha: 1.0)
                label.font = UIFont(name: "Lato-Regular", size: 20.0)
                label.text = "CURRENT PROCEDURAL\nTERMINOLOGY"
                self.updateCodesItem.titleView = label
                
                self.defaults.set("CPT", forKey: "DiagnosticType")
                
            })
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.cpt.alpha = 0
                self.dx.alpha = 1
                
                let label: UILabel = UILabel(frame: CGRect(x: 10, y: 0, width: 50, height: 40))
                label.numberOfLines = 1
                label.textAlignment = .center
                label.textColor = UIColor(red: 0/255.0, green: 172/255.0, blue: 233/255.0, alpha: 1.0)
                label.font = UIFont(name: "Lato-Regular", size: 20.0)
                label.text = "DIAGNOSIS"
                self.updateCodesItem.titleView = label
                
                self.defaults.set("DX", forKey: "DiagnosticType")
                
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
        
        actionController.addAction(Action(ActionData(title: "Select from List", image: UIImage(named: "list")!), style: .default, handler: { action in
            
            
            let type = self.defaults.value(forKey: "DiagnosticType") as! String
            
            if type == "CPT" {
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "fetchcptlist") as! FetchCptList
                self.present(nextViewController, animated:true, completion:nil)
                
            } else {
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "fetchdxlist") as! FetchDxList
                self.present(nextViewController, animated:true, completion:nil)
                
            }
            
        }))
        
        actionController.addAction(Action(ActionData(title: "Cancel", image: UIImage(named: "cancel")!), style: .default, handler: { action in
        }))
        
        present(actionController, animated: true, completion: nil)
    }
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        
         dismiss(animated: true, completion: nil)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
      /*  SwiftSpinner.show("Proceeding to next screen")
        
        if defaults.value(forKey: "cpt") != nil{
            let switchON: Bool = defaults.value(forKey: "cpt")  as! Bool
            if switchON == false{
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
                self.present(nextViewController, animated:true, completion:nil)
                
                timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector:  #selector(UpdateCodes.methodToBeCalled), userInfo: nil, repeats: true)
                
               
            } else {
                SwiftSpinner.hide()
            }
        }*/
    }
    
    func methodToBeCalled(){

        SwiftSpinner.hide()
    

    }
}
