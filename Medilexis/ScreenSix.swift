//
//  ScreenSix.swift
//  Medilexis
//
//  Created by iOS Developer on 16/11/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit

class ScreenSix: UIViewController {
    
    let userDefaults = Foundation.UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func nextPressed(_ sender: UIButton) {
        
        self.userDefaults.set("true", forKey: "hasViewedWalkthrough")

        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "selection") as! Selection
        self.present(nextViewController, animated:true, completion:nil)
    }
    

}
