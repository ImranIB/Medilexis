//
//  AddCard.swift
//  Medilexis
//
//  Created by iOS Developer on 26/07/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit
import Stripe
import CoreData
import SwiftSpinner
import SkyFloatingLabelTextField


class Payment: UIViewController, STPPaymentCardTextFieldDelegate, CardIOPaymentViewControllerDelegate {
    
    
    @IBOutlet var cardNumber: SkyFloatingLabelTextField!
    @IBOutlet var month: SkyFloatingLabelTextField!
    @IBOutlet var year: SkyFloatingLabelTextField!
    @IBOutlet var cvvNumber: SkyFloatingLabelTextField!
    @IBOutlet var amount: SkyFloatingLabelTextField!

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cardNumber.title = "Credit Card Number"
        cardNumber.titleFormatter = { $0 }
        cardNumber.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        self.view.addSubview(cardNumber)
        
        month.title = "Month"
        month.titleFormatter = { $0 }
        month.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        self.view.addSubview(month)
        
        year.title = "Year"
        year.titleFormatter = { $0 }
        year.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        self.view.addSubview(year)
        
        cvvNumber.title = "CVV"
        cvvNumber.titleFormatter = { $0 }
        cvvNumber.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        self.view.addSubview(cvvNumber)
        
        amount.title = "Amount"
        amount.titleFormatter = { $0 }
        amount.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        self.view.addSubview(amount)
        
        amount.isEnabled = false
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func scanCard(_ sender: UIButton) {
        
        let cardIOVC = CardIOPaymentViewController(paymentDelegate: self as CardIOPaymentViewControllerDelegate)
        cardIOVC?.modalPresentationStyle = .formSheet
        present(cardIOVC!, animated: true, completion: nil)
    }
    
    @IBAction func addPayment(_ sender: UIButton) {
        
        if currentReachabilityStatus == .reachableViaWiFi ||  currentReachabilityStatus == .reachableViaWWAN{
            
            if cardNumber.text == "" || month.text == "" || year.text == "" || cvvNumber.text == "" || amount.text == ""  {
                
                let alert = UIAlertController(title: "Notice", message: "Please fill all the fields", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil);
                
            } else {
              
                SwiftSpinner.show("Processing payment")
                
                let token = defaults.value(forKey: "Token")
             
                let url = URL(string: "http://muapp.com/medilixis_server/public/charges")!
                let jsonDict = ["card_number": (cardNumber.text!), "card_month": (month.text!), "card_year": (year.text!), "card_cvc": (cvvNumber.text!), "token": token!, "amount": amount.text!] as [String : Any]
                let jsonData = try! JSONSerialization.data(withJSONObject: jsonDict, options: [])
                
                var request = URLRequest(url: url)
                request.httpMethod = "post"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = jsonData
                
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        print("error:", error)
                        SwiftSpinner.hide()
                        let alert = UIAlertController(title: "Success", message: "Unable to process payment. Please try again later!", preferredStyle: UIAlertControllerStyle.alert)
                        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                        alert.addAction(action)
                        
                        self.present(alert, animated: true, completion: nil);
                        
                    }
                    
                    do {
                        guard let data = data else { return }
                        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] else { return }
                       // print("json:", json)
                        
                        let status = json["status"] as? String
                        
                        if (status == "true"){
                            
                            let message = json["message"] as? String
                            
                            DispatchQueue.main.async {
                                
                                SwiftSpinner.hide()
                                
                                let uid = self.defaults.value(forKey: "UserID")
                                let fetchRequest:NSFetchRequest<Card> = Card.fetchRequest()
                                let predicate = NSPredicate(format: "(userID = %@)", uid as! CVarArg)
                                fetchRequest.predicate = predicate
                                
                                do {
                                    let count = try self.getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
                                    
                                    if count > 0 {
                                        
                                        let fetchResult = try self.context.fetch(fetchRequest)
                                        
                                        for item in fetchResult {
                                            
                                          item.cardNumber = self.cardNumber.text
                                          item.month = self.month.text
                                          item.year = self.year.text
                                          item.cvv = self.cvvNumber.text
                                            
                                        try self.context.save()
                                            
                                        let alert = UIAlertController(title: "Success", message: message!, preferredStyle: UIAlertControllerStyle.alert)
                                            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                                            alert.addAction(action)
                                            
                                        self.present(alert, animated: true, completion: nil);
                                            
                                        return
                                            
                                        }
                                        
                                    } else {
                                        
                                        let userID = self.defaults.value(forKey: "UserID") as! Int32
                                        let context = self.getContext()
                                        
                                        let entity = NSEntityDescription.entity(forEntityName: "Card", in: context)
                                        
                                        let managedObj = NSManagedObject(entity: entity!, insertInto: context)
                                        
                                        managedObj.setValue(self.cardNumber.text, forKey: "cardNumber")
                                        managedObj.setValue(self.month.text, forKey: "month")
                                        managedObj.setValue(self.year.text, forKey: "year")
                                        managedObj.setValue(self.cvvNumber.text, forKey: "cvv")
                                        managedObj.setValue(userID, forKey: "userID")
                                        
                                        do {
                                            try context.save()
                                            
                                            let alert = UIAlertController(title: "Success", message: message!, preferredStyle: UIAlertControllerStyle.alert)
                                            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                                            alert.addAction(action)
                                            
                                            self.present(alert, animated: true, completion: nil);
                                            
                                            return
                                            
                                            
                                        } catch {
                                            print(error.localizedDescription)
                                        }
                                    }
                                }catch {
                                    print(error.localizedDescription)
                                }
  
                            }
                       
                            
                        } else {
                            
                            let message = json["message"] as? String
                            
                            DispatchQueue.main.async {
                                
                                SwiftSpinner.hide()
                                
                                let alert = UIAlertController(title: "Notice", message: message!, preferredStyle: UIAlertControllerStyle.alert)
                                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                                alert.addAction(action)
                                
                                self.present(alert, animated: true, completion: nil);
                                
                              
                            }
                            
                           
                        }
                        
                        
                    } catch {
                        print("error:", error)
                        
                    }
                }
                
                task.resume()
                
            }
            
        } else {
            
            DispatchQueue.main.async {
                
                let alert = UIAlertController(title: "No Connection", message: "Please check your internet connection and try again!", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                alert.addAction(action)
                
                self.present(alert, animated: true, completion: nil);
                
                return
            }
        }
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func navigateToHome(_ sender: UIBarButtonItem) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func backButton(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func userDidCancel(_ paymentViewController: CardIOPaymentViewController!) {
        dismiss(animated: true, completion: nil)
    }
    
    func userDidProvide(_ cardInfo: CardIOCreditCardInfo!, in paymentViewController: CardIOPaymentViewController!) {
        if let info = cardInfo {
            cardNumber.text = info.cardNumber
            cvvNumber.text = info.cvv
            month.text = String(info.expiryMonth)
            year.text = String(info.expiryYear)
            
             dismiss(animated: true, completion: nil)
        }
       
    }
    
    func chargeUsingToken(token:STPToken) {
    }
    override func viewWillAppear(_ animated: Bool) {
        
        CardIOUtilities.preload()
        fetchAmount()
        
        let uid = defaults.value(forKey: "UserID")
        let fetchRequest:NSFetchRequest<Card> = Card.fetchRequest()
        let predicate = NSPredicate(format: "(userID = %@)", uid as! CVarArg)
        fetchRequest.predicate = predicate
        
        do {
            let count = try getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            if count > 0 {
                
                let fetchResult = try context.fetch(fetchRequest)
                
                for item in fetchResult {
                    cardNumber.text = item.cardNumber
                    month.text = item.month
                    year.text = item.year
                    cvvNumber.text = item.cvv
                }
                
            }
        }catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchAmount(){
        
        let fetchRequest: NSFetchRequest<SubscriptionsList> = SubscriptionsList.fetchRequest()
        let predicate = NSPredicate(format: "(section = %@) AND (completed = true)", "Automated Voice to Text")
        fetchRequest.predicate = predicate
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            
            for item in fetchResult {
                
                amount.text = item.amount
                
            }
        }catch {
            print(error.localizedDescription)
        }
    }
    
    func getContext () -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    @IBAction func addCard(_ sender: UIButton) {
        
        if cardNumber.text == "" || month.text == "" || year.text == "" || cvvNumber.text == "" || amount.text == ""  {
            
            let alert = UIAlertController(title: "Notice", message: "Please fill all the fields", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            
            self.present(alert, animated: true, completion: nil);
            
        } else {
            
            let uid = self.defaults.value(forKey: "UserID")
            let fetchRequest:NSFetchRequest<Card> = Card.fetchRequest()
            let predicate = NSPredicate(format: "(userID = %@)", uid as! CVarArg)
            fetchRequest.predicate = predicate
            
            do {
                let count = try self.getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
                
                if count > 0 {
                    
                    let fetchResult = try self.context.fetch(fetchRequest)
                    
                    for item in fetchResult {
                        
                        item.cardNumber = self.cardNumber.text
                        item.month = self.month.text
                        item.year = self.year.text
                        item.cvv = self.cvvNumber.text
                        
                        try self.context.save()
                        
                        let alert = UIAlertController(title: "Success", message: "Card successfully added!", preferredStyle: UIAlertControllerStyle.alert)
                        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                        alert.addAction(action)
                        
                        self.present(alert, animated: true, completion: nil);
                        
                    }
                    
                } else {
                    
                    let userID = self.defaults.value(forKey: "UserID") as! Int32
                    let context = self.getContext()
                    
                    let entity = NSEntityDescription.entity(forEntityName: "Card", in: context)
                    
                    let managedObj = NSManagedObject(entity: entity!, insertInto: context)
                    
                    managedObj.setValue(self.cardNumber.text, forKey: "cardNumber")
                    managedObj.setValue(self.month.text, forKey: "month")
                    managedObj.setValue(self.year.text, forKey: "year")
                    managedObj.setValue(self.cvvNumber.text, forKey: "cvv")
                    managedObj.setValue(userID, forKey: "userID")
                    
                    do {
                        try context.save()
                        
                        let alert = UIAlertController(title: "Success", message: "Card successfully added!", preferredStyle: UIAlertControllerStyle.alert)
                        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                        alert.addAction(action)
                        
                        self.present(alert, animated: true, completion: nil);
                        
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                }
            }catch {
                print(error.localizedDescription)
            }
        }

    }
    

}
