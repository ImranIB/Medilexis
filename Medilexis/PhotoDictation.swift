//
//  PhotoDictation.swift
//  Medilexis
//
//  Created by iOS Developer on 16/05/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit
import XLActionController
import CoreData

class PhotoDictation: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var capturePhoto: UIButton!
    @IBOutlet weak var captureLabel: UILabel!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let picker = UIImagePickerController()
    var lastPoint = CGPoint.zero
    var swiped = false
    
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

        picker.delegate = self
        
        tool = UIImageView()
        tool.frame = CGRect(x: self.view.bounds.size.width, y: self.view.bounds.size.height, width: 10, height: 10)
        tool.image = #imageLiteral(resourceName: "paintBrush")
        self.view.addSubview(tool)
        
        //create tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PhotoDictation.imageTapped(gesture:)))
        
        //add it to the image view;
        capturePhoto.addGestureRecognizer(tapGesture)
        
        capturePhoto.isUserInteractionEnabled = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self.view)
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
        swiped = true
        captureLabel.isHidden = true
        
        if let touch = touches.first {
            let currentPoint = touch.location(in: self.view)
            drawLines(fromPoint: lastPoint, toPoint: currentPoint)
            
            lastPoint = currentPoint
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !swiped {
            drawLines(fromPoint: lastPoint, toPoint: lastPoint)
        }
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
    
    @IBAction func dismissPhotoDictation(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
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
            captureLabel.isHidden = true
        
        dismiss(animated: true, completion: nil)//5
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetIcon(_ sender: UIButton) {
        
        self.imageView.image = nil
        captureLabel.isHidden = false
    }
    
    @IBAction func saveIcon(_ sender: UIButton) {
        
        let patientid = defaults.value(forKey: "PatientID") as! String
        
        let actionController = YoutubeActionController()
        
        actionController.addAction(Action(ActionData(title: "Save and Next", image: UIImage(named: "saveNext")!), style: .default, handler: { action in
            
            if self.imageView.image == nil {
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "captureAnotherPhoto") as! AnotherPhotoDictation
                self.present(nextViewController, animated:true, completion:nil)
                
            } else {
                
                ///update into patients
                let fetchRequest:NSFetchRequest<Patients> = Patients.fetchRequest()
                
                let predicate = NSPredicate(format: "(patientID = %@)", patientid)
                fetchRequest.predicate = predicate
                
                do {
                    let fetchResult = try self.context.fetch(fetchRequest)
                    
                    for item in fetchResult {
                        
                        let newImageData = UIImagePNGRepresentation(self.imageView.image!)
                        item.image = newImageData as NSData?
                        
                        try self.context.save()
                        print("Done")
                        
                    }
                }catch {
                    print(error.localizedDescription)
                    
                    
                }
            }
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "captureAnotherPhoto") as! AnotherPhotoDictation
            self.present(nextViewController, animated:true, completion:nil)
            
        }))
        actionController.addAction(Action(ActionData(title: "Save and Exit", image: UIImage(named: "saveExit")!), style: .default, handler: { action in
            
            if self.imageView.image == nil {
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
                self.present(nextViewController, animated:true, completion:nil)
                
            } else {
                
                ///update into patients
                let fetchRequest:NSFetchRequest<Patients> = Patients.fetchRequest()
                
                let predicate = NSPredicate(format: "(patientID = %@)", patientid)
                fetchRequest.predicate = predicate
                
                do {
                    let fetchResult = try self.context.fetch(fetchRequest)
                    
                    for item in fetchResult {
                        
                        let newImageData = UIImagePNGRepresentation(self.imageView.image!)
                        item.image = newImageData as NSData?
                        
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
        
        actionController.addAction(Action(ActionData(title: "Cancel", image: UIImage(named: "cancel")!), style: .default, handler: { action in
        }))
        
        present(actionController, animated: true, completion: nil)
        
        
    }
    
    
}
