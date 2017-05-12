//
//  selectDictation.swift
//  Medilexis
//
//  Created by iOS Developer on 27/02/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit

class selectDictation: UIViewController {


    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
  
    }
    
    @IBAction func dismissVC(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func navigateToHome(_ sender: UIBarButtonItem) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    
    
  

}
