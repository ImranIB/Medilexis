//
//  Support.swift
//  Medilexis
//
//  Created by iOS Developer on 15/11/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit
import SwiftSpinner

class Support: UIViewController, UIWebViewDelegate {
    
    @IBOutlet var supportWebView: UIWebView!
    
    
    var timerRun = false
    var timer:Timer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let url = URL (string: "http://medilexis.com")
        let requestObj = URLRequest(url: url!)
        supportWebView.delegate = self
        supportWebView.loadRequest(requestObj)
      
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func webViewDidStartLoad(_ webView: UIWebView)
    {
        
        SwiftSpinner.show("Loading Support view")

    }
    
    func webViewDidFinishLoad(_ webView: UIWebView)
    {
        // load url complete
        print("loading done call")
        
        if !webView.isLoading{
            
            let url = URL (string: "http://medilexis.com/#contactus")
            let requestObj = URLRequest(url: url!)
            supportWebView.loadRequest(requestObj)
            SwiftSpinner.hide()
        }
    
    }
    
    
    @IBAction func stop(_ sender: UIBarButtonItem) {
        
        supportWebView.stopLoading()
    }
    
    @IBAction func refresh(_ sender: UIBarButtonItem) {
        
        supportWebView.reload()
    }
    
    @IBAction func back(_ sender: UIBarButtonItem) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func forward(_ sender: UIBarButtonItem) {
        
        supportWebView.goForward()
    }
    
    
    

}
