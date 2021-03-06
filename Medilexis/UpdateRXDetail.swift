//
//  UpdateRXDetail.swift
//  Medilexis
//
//  Created by iOS Developer on 24/05/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit
import CoreData
import SkyFloatingLabelTextField

class UpdateRXDetail: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var rxDetail: UINavigationItem!
    @IBOutlet weak var dose: SkyFloatingLabelTextField!
    @IBOutlet weak var unit: SkyFloatingLabelTextField!
    @IBOutlet weak var weight: SkyFloatingLabelTextField!
    @IBOutlet weak var times: SkyFloatingLabelTextField!
    @IBOutlet weak var timesLength: SkyFloatingLabelTextField!
    @IBOutlet weak var dispense: SkyFloatingLabelTextField!
    @IBOutlet weak var route: SkyFloatingLabelTextField!
    @IBOutlet weak var startDate: SkyFloatingLabelTextField!
    @IBOutlet weak var endDate: SkyFloatingLabelTextField!
    @IBOutlet weak var total: SkyFloatingLabelTextField!
    @IBOutlet weak var notes: SkyFloatingLabelTextField!
    
    var selectedRX = String()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults.standard
    var doseStrength = ["mg", "mL"]
    var timeDuration = ["Day", "Week", "Month"]
    var dispensing = ["Tablets", "Capsules", "Suppository", "Drops", "Puffs"]
    var routes = ["Oral", "Topical", "Sublingual", "Inhalation", "Injection"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let medicineName = defaults.value(forKey: "medicineName") as! String
        let label: UILabel = UILabel(frame: CGRect(x: 10, y: 0, width: 50, height: 500))
        label.numberOfLines = 1
        label.textAlignment = .center
        label.textColor = UIColor(red: 0/255.0, green: 172/255.0, blue: 233/255.0, alpha: 1.0)
        // label.font = UIFont(name: "Lato-Regular", size: 20.0)
        label.text = medicineName.uppercased()
        self.rxDetail.titleView = label
        
        dose.title = "Dose"
        dose.titleFormatter = { $0 }
        dose.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        self.view.addSubview(dose)
        
        unit.title = "Unit"
        unit.titleFormatter = { $0 }
        unit.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        self.view.addSubview(unit)
        
        weight.title = "Weight"
        weight.titleFormatter = { $0 }
        weight.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        self.view.addSubview(weight)
        
        times.title = "Times"
        times.titleFormatter = { $0 }
        times.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        self.view.addSubview(times)
        
        timesLength.title = "Length"
        timesLength.titleFormatter = { $0 }
        timesLength.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        self.view.addSubview(timesLength)
        
        dispense.title = "Dispense"
        dispense.titleFormatter = { $0 }
        dispense.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        self.view.addSubview(dispense)
        
        route.title = "Route"
        route.titleFormatter = { $0 }
        route.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        self.view.addSubview(route)
        
        startDate.title = "Start Date"
        startDate.titleFormatter = { $0 }
        startDate.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        self.view.addSubview(startDate)
        
        endDate.title = "End Date"
        endDate.titleFormatter = { $0 }
        endDate.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        self.view.addSubview(endDate)
        
        total.title = "Notes"
        total.titleFormatter = { $0 }
        total.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        self.view.addSubview(total)
        
        notes.title = "Notes"
        notes.titleFormatter = { $0 }
        notes.titleLabel.font = UIFont(name: "FontAwesome", size: 11)
        self.view.addSubview(notes)
        
        let pickerView = UIPickerView()
        
        pickerView.delegate = self
        
        weight.inputView = pickerView
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        
        toolBar.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar.barStyle = UIBarStyle.blackTranslucent
        
        toolBar.tintColor = UIColor.white
        
        toolBar.backgroundColor = UIColor.black
        
       // let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(UpdateRXDetail.doneDoseStrengthBtnPressed))
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let doseWeight = UILabel(frame: CGRect(x: 0, y: 10, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        doseWeight.font = UIFont(name: "FontAwesome", size: 16)
        
        doseWeight.backgroundColor = UIColor.clear
        
        doseWeight.textColor = UIColor.white
        
        doseWeight.text = "Dose Strength"
        
        doseWeight.textAlignment = NSTextAlignment.center
        
        let textBtn = UIBarButtonItem(customView: doseWeight)
        
        toolBar.setItems([flexSpace,textBtn,flexSpace], animated: true)
        
        weight.inputAccessoryView = toolBar
        
        //.......................................................................................
        
        timesLength.inputView = pickerView
        
        let toolBar1 = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        
        toolBar1.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar1.barStyle = UIBarStyle.blackTranslucent
        
        toolBar1.tintColor = UIColor.white
        
        toolBar1.backgroundColor = UIColor.black
        
        
        //let doneButton1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(UpdateRXDetail.doneTimesLength))
        
        let flexSpace1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let doseWeight1 = UILabel(frame: CGRect(x: 0, y: 10, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        doseWeight1.font = UIFont(name: "FontAwesome", size: 16)
        
        doseWeight1.backgroundColor = UIColor.clear
        
        doseWeight1.textColor = UIColor.white
        
        doseWeight1.text = "Time Duration"
        
        doseWeight1.textAlignment = NSTextAlignment.center
        
        let textBtn1 = UIBarButtonItem(customView: doseWeight1)
        
        toolBar1.setItems([flexSpace1,textBtn1,flexSpace1], animated: true)
        
        timesLength.inputAccessoryView = toolBar1
        
        //..................................................................................
        
        dispense.inputView = pickerView
        
        let toolBar2 = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        
        toolBar2.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar2.barStyle = UIBarStyle.blackTranslucent
        
        toolBar2.tintColor = UIColor.white
        
        toolBar2.backgroundColor = UIColor.black
        
        
        //let doneButton2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(UpdateRXDetail.doneDispense))
        
        let flexSpace2 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let doseWeight2 = UILabel(frame: CGRect(x: 0, y: 10, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        doseWeight2.font = UIFont(name: "FontAwesome", size: 16)
        
        doseWeight2.backgroundColor = UIColor.clear
        
        doseWeight2.textColor = UIColor.white
        
        doseWeight2.text = "Dispense"
        
        doseWeight2.textAlignment = NSTextAlignment.center
        
        let textBtn2 = UIBarButtonItem(customView: doseWeight2)
        
        toolBar2.setItems([flexSpace2,textBtn2,flexSpace2], animated: true)
        
        dispense.inputAccessoryView = toolBar2
        
        //................................................................................
        
        route.inputView = pickerView
        
        let toolBar3 = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        
        toolBar3.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar3.barStyle = UIBarStyle.blackTranslucent
        
        toolBar3.tintColor = UIColor.white
        
        toolBar3.backgroundColor = UIColor.black
        
        
       // let doneButton3 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(UpdateRXDetail.doneRoute))
        
        let flexSpace3 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let doseWeight3 = UILabel(frame: CGRect(x: 0, y: 10, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        doseWeight3.font = UIFont(name: "FontAwesome", size: 16)
        
        doseWeight3.backgroundColor = UIColor.clear
        
        doseWeight3.textColor = UIColor.white
        
        doseWeight3.text = "Route"
        
        doseWeight3.textAlignment = NSTextAlignment.center
        
        let textBtn3 = UIBarButtonItem(customView: doseWeight3)
        
        toolBar3.setItems([flexSpace3,textBtn3, flexSpace3], animated: true)
        
        route.inputAccessoryView = toolBar3
        
        //.............................................................................
        
        let toolBar4 = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        
        toolBar4.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar4.barStyle = UIBarStyle.blackTranslucent
        
        toolBar4.tintColor = UIColor.white
        
        toolBar4.backgroundColor = UIColor.black
        
        
        let defaultButton4 = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.plain, target: self, action: #selector(UpdateRXDetail.startDefaultBtn))
        
       // let doneButton4 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(UpdateRXDetail.selectDoneStartButton))
        
        let flexSpace4 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let label4 = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label4.font = UIFont(name: "FontAwesome", size: 16)
        
        label4.backgroundColor = UIColor.clear
        
        label4.textColor = UIColor.white
        
        label4.text = "Start Date"
        
        label4.textAlignment = NSTextAlignment.center
        
        let textBtn4 = UIBarButtonItem(customView: label4)
        
        toolBar4.setItems([defaultButton4,flexSpace4,textBtn4,flexSpace4], animated: true)
        
        startDate.inputAccessoryView = toolBar4
        
        //......................................................................................................
        
        let toolBar5 = UIToolbar(frame: CGRect(x: 0, y: self.view.frame.size.height/6, width: self.view.frame.size.width, height: 40.0))
        
        toolBar5.layer.position = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height-20.0)
        
        toolBar5.barStyle = UIBarStyle.blackTranslucent
        
        toolBar5.tintColor = UIColor.white
        
        toolBar5.backgroundColor = UIColor.black
        
        
        let defaultButton5 = UIBarButtonItem(title: "Today", style: UIBarButtonItemStyle.plain, target: self, action: #selector(UpdateRXDetail.endDefaultBtn))
        
       // let doneButton5 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(UpdateRXDetail.selectDoneEndButton))
        
        let flexSpace5 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        
        let label5 = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width / 3, height: self.view.frame.size.height))
        
        label5.font = UIFont(name: "FontAwesome", size: 16)
        
        label5.backgroundColor = UIColor.clear
        
        label5.textColor = UIColor.white
        
        label5.text = "End Date"
        
        label5.textAlignment = NSTextAlignment.center
        
        let textBtn5 = UIBarButtonItem(customView: label5)
        
        toolBar5.setItems([defaultButton5,flexSpace5,textBtn5,flexSpace5], animated: true)
        
        endDate.inputAccessoryView = toolBar5

        
        FetchMedicineDetail()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        if weight.isEditing{
            return doseStrength.count
        } else if timesLength.isEditing {
            return timeDuration.count
        } else if dispense.isEditing {
            return dispensing.count
        } else if route.isEditing{
            return routes.count
        }
        
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if weight.isEditing{
            weight.text = "mg"
            return doseStrength[row]
        } else if timesLength.isEditing {
            timesLength.text = "Day"
            return timeDuration[row]
        } else if dispense.isEditing {
            dispense.text = "Tablets"
            return dispensing[row]
        } else if route.isEditing{
            route.text = "Oral"
            return routes[row]
        }
        
        return "Test"
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if weight.isEditing{
            weight.text = doseStrength[row]
            let _ = weight.resignFirstResponder()
        } else if timesLength.isEditing{
            timesLength.text = timeDuration[row]
            let _ = timesLength.resignFirstResponder()
        } else if dispense.isEditing{
            dispense.text = dispensing[row]
            let _ = dispense.resignFirstResponder()
        }else if route.isEditing{
            route.text = routes[row]
            let _ = route.resignFirstResponder()
        }
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    @IBAction func saveNext(_ sender: UIButton) {
        
        let medicineID = defaults.value(forKey: "medicineID") as! String
        let medicineName = defaults.value(forKey: "medicineName") as! String
        
        let fetchRequest:NSFetchRequest<Medicines> = Medicines.fetchRequest()
        let predicate = NSPredicate(format: "(medicineID = %@) AND (medicineName = %@) ", medicineID, medicineName)
        fetchRequest.predicate = predicate
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            
            for item in fetchResult {
                
                item.dose = dose.text
                item.unit = unit.text
                item.weight = weight.text
                item.times = times.text
                item.length = timesLength.text
                item.dispense = dispense.text
                item.route = route.text
                item.startDate = startDate.text
                item.endDate = endDate.text
                item.notes = notes.text
                
                try context.save()
                print("updated")
                dismiss(animated: true, completion: nil)
                
            }
        }catch {
            print(error.localizedDescription)
        }
        
    }
    
    @IBAction func dismissUpdateRX(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func getContext () -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    @IBAction func navigateToHome(_ sender: UIBarButtonItem) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    func FetchMedicineDetail(){
        
        let medicineID = defaults.value(forKey: "medicineID") as! String
        let medicineName = defaults.value(forKey: "medicineName") as! String
        
        let fetchRequest:NSFetchRequest<Medicines> = Medicines.fetchRequest()
        let predicate = NSPredicate(format: "(medicineID = %@) AND (medicineName = %@) ", medicineID, medicineName)
        fetchRequest.predicate = predicate
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            
            for item in fetchResult {
                
                dose.text = item.dose
                unit.text = item.unit
                weight.text = item.weight
                times.text = item.times
                timesLength.text = item.length
                dispense.text = item.dispense
                route.text = item.route
                startDate.text = item.startDate
                endDate.text = item.endDate
                total.text = item.total
                notes.text = item.notes
               
            }
        }catch {
            print(error.localizedDescription)
        }
    }
    
    func doneDoseStrengthBtnPressed(_ sender: UIBarButtonItem) {
        
        let _ = weight.resignFirstResponder()
        
    }
    
    func doneTimesLength(_ sender: UIBarButtonItem) {
        
        let _ = timesLength.resignFirstResponder()
        
    }
    
    func doneDispense(_ sender: UIBarButtonItem) {
        
        let _ = dispense.resignFirstResponder()
        
    }
    
    func doneRoute (_ sender: UIBarButtonItem) {
        
        let _ = route.resignFirstResponder()
    }
    
    func selectDoneStartButton(_ sender: UIBarButtonItem) {
        
        let _ = startDate.resignFirstResponder()
        
    }
    
    func startDefaultBtn(_ sender: UIBarButtonItem) {
        
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "dd MMMM yyyy"
        let date = NSDate()
        let stringOfDate = dateFormate.string(from: date as Date)
        startDate.text = stringOfDate
        
        let _ = startDate.resignFirstResponder()
    }
    
    func selectDoneEndButton(_ sender: UIBarButtonItem) {
        
        let _ = endDate.resignFirstResponder()
        
    }
    
    func endDefaultBtn(_ sender: UIBarButtonItem) {
        
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "dd MMMM yyyy"
        let date = NSDate()
        let stringOfDate = dateFormate.string(from: date as Date)
        endDate.text = stringOfDate
        
        let _ = endDate.resignFirstResponder()
    }
    
    @IBAction func startDateBeginEditing(_ sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datePickerView
        
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "dd MMMM yyyy"
        let date = NSDate()
        let stringOfDate = dateFormate.string(from: date as Date)
        startDate.text = stringOfDate
        
        datePickerView.addTarget(self, action: #selector(RXDetail.StartDateValueChanged), for: UIControlEvents.valueChanged)
    }
    
    func StartDateValueChanged(sender:UIDatePicker){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        startDate.text = dateFormatter.string(from: sender.date)
        
    }
    
    @IBAction func endDateBeginEditing(_ sender: UITextField) {
        
        let datePickerView:UIDatePicker = UIDatePicker()
        
        datePickerView.datePickerMode = UIDatePickerMode.date
        
        sender.inputView = datePickerView
        
        let dateFormate = DateFormatter()
        dateFormate.dateFormat = "dd MMMM yyyy"
        let date = NSDate()
        let stringOfDate = dateFormate.string(from: date as Date)
        endDate.text = stringOfDate
        
        datePickerView.addTarget(self, action: #selector(RXDetail.EndDateValueChanged), for: UIControlEvents.valueChanged)
    }
    
    
    func EndDateValueChanged(sender:UIDatePicker){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy"
        endDate.text = dateFormatter.string(from: sender.date)
        
    }


}
