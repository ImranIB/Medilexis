//
//  Subscriptions.swift
//  Medilexis
//
//  Created by iOS Developer on 28/07/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit
import M13Checkbox
import SkyFloatingLabelTextField

class Subscriptions: UIViewController {
    
    @IBOutlet var autoCreditCheckbox: M13Checkbox!
    @IBOutlet var amountTextFIeld: SkyFloatingLabelTextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        autoCreditCheckbox.boxType = .square
        autoCreditCheckbox.cornerRadius = 0
        autoCreditCheckbox.backgroundColor = UIColor.white
        autoCreditCheckbox.checkState = .unchecked
        autoCreditCheckbox.tintColor = UIColor(red: 0/255.0, green: 172/255.0, blue: 233/255.0, alpha: 1.0)
        
        amountTextFIeld.title = "Credit Amount"
        amountTextFIeld.titleFormatter = { $0 }
        amountTextFIeld.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        self.view.addSubview(amountTextFIeld)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    @IBAction func homePressed(_ sender: UIBarButtonItem) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func addCreditPressed(_ sender: UIButton) {
        
        if amountTextFIeld.text == "" {
            
            let alert = UIAlertController(title: "Notice", message: "Please enter credit amount", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil);
        
        } else {
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "payment") as! Payment
            self.present(nextViewController, animated:true, completion:nil)
        }
    }
    
    

}
