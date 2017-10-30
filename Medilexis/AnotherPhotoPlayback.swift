//
//  AnotherPhotoPlayback.swift
//  Medilexis
//
//  Created by iOS Developer on 22/05/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit
import CoreData
import SwiftSpinner
import XLActionController

class AnotherPhotoPlayback: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var caputurePhoto: UIButton!
    @IBOutlet var photoLabel: UILabel!
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let picker = UIImagePickerController()
    var lastPoint = CGPoint.zero
    var swiped = false
    var timer: Timer!
    
    var red:CGFloat = 0.0
    var green:CGFloat = 0.0
    var blue:CGFloat = 0.0
    var brushSize:CGFloat = 5.0
    var opacityValue:CGFloat = 1.0
    
    var tool:UIImageView!
    var isDrawing = true
    var selectedImage:UIImage!
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        let AppointmentID = defaults.value(forKey: "AppointmentID") as! String
        let fetchRequest:NSFetchRequest<Appointments> = Appointments.fetchRequest()
        let predicate = NSPredicate(format: "(appointmentID = %@)", AppointmentID)
        fetchRequest.predicate = predicate
        
        do {
            let count = try getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            if count > 0 {
                
                let fetchResult = try getContext().fetch(fetchRequest)
                
                for item in fetchResult {
                    
                    if item.anotherImage != nil {
                        
                        let newImage = UIImage(data: item.anotherImage!as Data)!
                        imageView.image = newImage
                        photoLabel.isHidden = true
                    } else {
                        photoLabel.isHidden = false
                    }
                    
                }
            } else {
                
            }
            
        }catch {
            print(error.localizedDescription)
        }
        
        picker.delegate = self
        
        tool = UIImageView()
        tool.frame = CGRect(x: self.view.bounds.size.width, y: self.view.bounds.size.height, width: 10, height: 10)
        tool.image = #imageLiteral(resourceName: "paintBrush")
        self.view.addSubview(tool)
        
        //create tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PhotoDictation.imageTapped(gesture:)))
        
        //add it to the image view;
        caputurePhoto.addGestureRecognizer(tapGesture)
        
        caputurePhoto.isUserInteractionEnabled = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if self.imageView.image != nil{
            
            swiped = false
            if let touch = touches.first {
                lastPoint = touch.location(in: self.view)
            }
        }

    }
    
    func drawLines(fromPoint:CGPoint,toPoint:CGPoint) {
        UIGraphicsBeginImageContext(self.view.frame.size)
        imageView.image?.draw(in: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        let context = UIGraphicsGetCurrentContext()
        
        context?.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
        context?.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
        tool.center = toPoint
        
        context?.setBlendMode(CGBlendMode.normal)
        context?.setLineCap(CGLineCap.round)
        context?.setLineWidth(brushSize)
        context?.setStrokeColor(UIColor(red: red, green: green, blue: blue, alpha: opacityValue).cgColor)
        
        context?.strokePath()
        
        imageView.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
          if self.imageView.image != nil{
            
            swiped = true
            
            if let touch = touches.first {
                let currentPoint = touch.location(in: self.view)
                drawLines(fromPoint: lastPoint, toPoint: currentPoint)
                
                lastPoint = currentPoint
            }
        }

    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if self.imageView.image != nil{
            
            if !swiped {
                drawLines(fromPoint: lastPoint, toPoint: lastPoint)
            }
        }

    }
    
    func imageTapped(gesture: UIGestureRecognizer) {
        
        let actionController = YoutubeActionController()
        
        actionController.addAction(Action(ActionData(title: "Camera", image: UIImage(named: "camera")!), style: .default, handler: { action in
            
            self.CaptureCamera()
            
        }))
        actionController.addAction(Action(ActionData(title: "Photo Library", image: UIImage(named: "photolibrary")!), style: .default, handler: { action in
            
            self.CaptureLibrary()
        }))
        
        actionController.addAction(Action(ActionData(title: "Cancel", image: UIImage(named: "cancel")!), style: .default, handler: { action in
        }))
        
        present(actionController, animated: true, completion: nil)
    }
    
    func CaptureCamera(){
        
        if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
            self.picker.allowsEditing = false
            self.picker.sourceType = UIImagePickerControllerSourceType.camera
            self.picker.cameraCaptureMode = .photo
            present(self.picker, animated: true, completion: nil)
        } else {
            self.noCamera()
        }
    }
    
    func noCamera(){
        let alertVC = UIAlertController(
            title: "No Camera",
            message: "Sorry, this device has no camera",
            preferredStyle: .alert)
        let okAction = UIAlertAction(
            title: "OK",
            style:.default,
            handler: nil)
        alertVC.addAction(okAction)
        present(alertVC,
                animated: true,
                completion: nil)
    }
    
    func CaptureLibrary(){
        
        picker.allowsEditing = false
        picker.sourceType = .photoLibrary
        picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any])
    {
        selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        imageView.image = selectedImage
        photoLabel.isHidden = true
        dismiss(animated: true, completion: nil)//5
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    
    func getContext () -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    @IBAction func save(_ sender: UIButton) {
        
        let AppointmentID = defaults.value(forKey: "AppointmentID") as! String
        
        let actionController = YoutubeActionController()
        
        actionController.addAction(Action(ActionData(title: "Save and Next", image: UIImage(named: "saveNext")!), style: .default, handler: { action in
            
            if self.imageView.image == nil {
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Updatecodes") as! UpdateCodes
                self.present(nextViewController, animated:true, completion:nil)
                
            } else {
                
                ///update into patients
                let fetchRequest:NSFetchRequest<Appointments> = Appointments.fetchRequest()
                
                let predicate = NSPredicate(format: "(appointmentID = %@)", AppointmentID)
                fetchRequest.predicate = predicate
                
                do {
                    let fetchResult = try self.context.fetch(fetchRequest)
                    
                    for item in fetchResult {
                        
                        let newImageData = UIImagePNGRepresentation(self.imageView.image!)
                        item.anotherImage = newImageData as NSData?
                        
                        try self.context.save()
                        print("Done")
                        
                    }
                }catch {
                    print(error.localizedDescription)
                    
                }
                
            }
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "updateRX") as! UpdateRX
            self.present(nextViewController, animated:true, completion:nil)
            
        }))
        
        actionController.addAction(Action(ActionData(title: "Save and Exit", image: UIImage(named: "saveExit")!), style: .default, handler: { action in
            
            if self.imageView.image == nil {
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
                self.present(nextViewController, animated:true, completion:nil)
                
            } else {
                
                ///update into patients
                let fetchRequest:NSFetchRequest<Appointments> = Appointments.fetchRequest()
                
                let predicate = NSPredicate(format: "(appointmentID = %@)", AppointmentID)
                fetchRequest.predicate = predicate
                
                do {
                    let fetchResult = try self.context.fetch(fetchRequest)
                    
                    for item in fetchResult {
                        
                        let newImageData = UIImagePNGRepresentation(self.imageView.image!)
                        item.anotherImage = newImageData as NSData?
                        
                        try self.context.save()
                        print("Done")
                        
                    }
                }catch {
                    print(error.localizedDescription)
                    
                }
            }
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
            self.present(nextViewController, animated:true, completion:nil)
            
        }))
        
        actionController.addAction(Action(ActionData(title: "Skip", image: UIImage(named: "skip")!), style: .default, handler: { action in
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "updateRX") as! UpdateRX
            self.present(nextViewController, animated:true, completion:nil)
            
        }))
       
        
        actionController.addAction(Action(ActionData(title: "Cancel", image: UIImage(named: "cancel")!), style: .default, handler: { action in
        }))
        
        present(actionController, animated: true, completion: nil)
        
    }

    @IBAction func navigateToHome(_ sender: UIBarButtonItem) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func backPressed(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        SwiftSpinner.show("Proceeding to next screen")
        
        if defaults.value(forKey: "anotherphoto") != nil{
            let switchON: Bool = defaults.value(forKey: "anotherphoto")  as! Bool
            if switchON == false{
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "updateRX") as! UpdateRX
                self.present(nextViewController, animated:true, completion:nil)
                
                   timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector:  #selector(AnotherPhotoPlayback.methodToBeCalled), userInfo: nil, repeats: true)
        

            } else {
                 SwiftSpinner.hide()
            }
        }
        
    }
    
    func methodToBeCalled(){
        
        SwiftSpinner.hide()
    }
}
