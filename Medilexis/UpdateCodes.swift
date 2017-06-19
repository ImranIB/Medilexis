//
//  UpdateCodes.swift
//  Medilexis
//
//  Created by iOS Developer on 31/05/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit

class UpdateCodes: UIViewController {

    @IBOutlet weak var cpt: UIView!
    @IBOutlet weak var dx: UIView!
    @IBOutlet weak var updateCodesItem: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor =  UIColor(red: 240/255.0, green: 240/255.0, blue: 240/255.0, alpha: 1.0)
        
        self.cpt.alpha = 1
        self.dx.alpha = 0
        
        let label: UILabel = UILabel(frame: CGRect(x: 10, y: 0, width: 450, height: 50))
        label.numberOfLines = 2
        label.textAlignment = .center
        label.textColor = UIColor(red: 0/255.0, green: 172/255.0, blue: 233/255.0, alpha: 1.0)
        label.font = UIFont(name: "Lato-Regular", size: 20.0)
        label.text = "CURRENT PROCEDURAL \n TERMINOLOGY"
        self.updateCodesItem.titleView = label
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
                
                let label: UILabel = UILabel(frame: CGRect(x: 10, y: 0, width: 50, height: 40))
                label.numberOfLines = 1
                label.textAlignment = .center
                label.textColor = UIColor(red: 0/255.0, green: 172/255.0, blue: 233/255.0, alpha: 1.0)
                label.font = UIFont(name: "Lato-Regular", size: 20.0)
                label.text = "CURRENT PROCEDURAL TERMINOLOGY"
                self.updateCodesItem.titleView = label
                
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
                
            })
        }

    }
    
    @IBAction func navigateToHome(_ sender: UIBarButtonItem) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        
         dismiss(animated: true, completion: nil)
        
    }
    

}
