//
//  AnotherPhotoDictation.swift
//  Medilexis
//
//  Created by iOS Developer on 16/05/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit
import XLActionController
import SwiftSpinner
import CoreData
import SwiftSpinner
import SimplePDFSwift

class AnotherPhotoDictation: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentInteractionControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var photoLabel: UILabel!
    @IBOutlet weak var photoButton: UIButton!
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let defaults = UserDefaults.standard
    let picker = UIImagePickerController()
    var lastPoint = CGPoint.zero
    var swiped = false
    var fileAnotherPhotoStored = ""
    
    var red:CGFloat = 0.0
    var green:CGFloat = 0.0
    var blue:CGFloat = 0.0
    var brushSize:CGFloat = 5.0
    var opacityValue:CGFloat = 1.0
    
    var tool:UIImageView!
    var isDrawing = true
    var selectedImage:UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self
        
        tool = UIImageView()
        tool.frame = CGRect(x: self.view.bounds.size.width, y: self.view.bounds.size.height, width: 10, height: 10)
        tool.image = #imageLiteral(resourceName: "paintBrush")
        self.view.addSubview(tool)
        
        //create tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(AnotherPhotoDictation.imageTapped(gesture:)))
        
        //add it to the image view;
        photoButton.addGestureRecognizer(tapGesture)
        
        photoButton.isUserInteractionEnabled = true
        
        
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
            photoLabel.isHidden = true
            
            if let touch = touches.first {
                let currentPoint = touch.location(in: self.view)
                drawLines(fromPoint: lastPoint, toPoint: currentPoint)
                lastPoint = currentPoint
                print("ok")
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

    @objc func imageTapped(gesture: UIGestureRecognizer) {
        
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
        imageView.image = resizeImage(image: selectedImage, newWidth: 375)
        photoLabel.isHidden = true
        fileAnotherPhotoStored = "false"
        dismiss(animated: true, completion: nil)//5
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: - UIDocumentInteractionControllerDelegate
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    @IBAction func navigateToHome(_ sender: UIBarButtonItem) {
        
        let pdf = SimplePDF(pdfTitle: "PRINT TEMPLATE", authorName: "Muhammad Imran")
        
        self.addDocumentCover(pdf)
        self.addDocumentContent(pdf)
        self.addHeadersFooters(pdf)
        
        // here we may want to save the pdf somewhere or show it to the user
        let tmpPDFPath = pdf.writePDFWithoutTableOfContents()
        
        // open the generated PDF
        DispatchQueue.main.async(execute: { () -> Void in
            let pdfURL = URL(fileURLWithPath: tmpPDFPath)
            let interactionController = UIDocumentInteractionController(url: pdfURL)
            interactionController.delegate = self
            interactionController.presentPreview(animated: true)
            SwiftSpinner.hide()
        })
    }
    
    fileprivate func addDocumentCover(_ pdf: SimplePDF) {
        
        SwiftSpinner.show("Loading print preview")
        pdf.startNewPage()
    }
    
    fileprivate func addDocumentContent(_ pdf: SimplePDF) {
        
        let dos = defaults.value(forKey: "DOS") as! NSDate
        let pname = defaults.value(forKey: "PatientName") as! String
        let AppointmentID = defaults.value(forKey: "AppointmentID") as! String
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        let dateString = dateFormatter.string(from: dos as Date)
        
        let text1 = ""
        pdf.addBodyText(text1)
        
        let text2 = ""
        pdf.addBodyText(text2)
        
        
        let name = "Patient Name: \(pname)"
        pdf.addBodyText(name)
        
        let date = "Scheduled Date: \(dateString)"
        pdf.addBodyText(date)
        
        let fetchRequest:NSFetchRequest<Sounds> = Sounds.fetchRequest()
        let predicate = NSPredicate(format: "(appointmentID = %@)", AppointmentID)
        fetchRequest.predicate = predicate
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            
            for item in fetchResult {
                
                if item.type == "CC"{
                    
                    pdf.addH6("CHIEF COMPLAINT")
                    pdf.addBodyText(item.transcription!)
                    
                } else if item.type == "HPI"{
                    
                    pdf.addH6("HISTORY OF PRESENT ILLNESS")
                    pdf.addBodyText(item.transcription!)
                    
                } else if item.type == "HX"{
                    
                    pdf.addH6("HISTORY")
                    pdf.addBodyText(item.transcription!)
                    
                } else if item.type == "ROS"{
                    
                    pdf.addH6("REVIEW OF SYSTEMS")
                    pdf.addBodyText(item.transcription!)
                    
                }else if item.type == "PLAN"{
                    
                    pdf.addH6("PLAN")
                    pdf.addBodyText(item.transcription!)
                }
                
            }
        }catch {
            print(error.localizedDescription)
        }
        
    }
    
    fileprivate func addHeadersFooters(_ pdf: SimplePDF) {
        
        let uid = defaults.value(forKey: "UserID")
        let fetchRequest:NSFetchRequest<Users> = Users.fetchRequest()
        let predicate = NSPredicate(format: "(userID = %@)", uid as! CVarArg)
        fetchRequest.predicate = predicate
        
        do {
            let count = try getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            if count > 0 {
                
                let fetchResult = try context.fetch(fetchRequest)
                
                for item in fetchResult {
                    
                    let regularFont = UIFont.systemFont(ofSize: 18)
                    let boldFont = UIFont.boldSystemFont(ofSize: 20)
                    let leftAlignment = NSMutableParagraphStyle()
                    leftAlignment.alignment = NSTextAlignment.left
                    
                    
                    if item.logo != nil {
                        
                        let retrievedImg = UIImage(data: item.logo! as Data)!
                        
                        let rightLogo = SimplePDF.HeaderFooterImage(type: .header, pageRange: NSMakeRange(0, 1),
                                                                    image:retrievedImg, imageHeight: 55, alignment: .right)
                        pdf.headerFooterImages.append(rightLogo)
                    }
                    
                    if item.heading != nil && item.subHeading != nil {
                        
                        // add some document information to the header, on left
                        let leftHeaderString = "\(item.heading!)\n\(item.subHeading!)"
                        let leftHeaderAttrString = NSMutableAttributedString(string: leftHeaderString)
                        leftHeaderAttrString.addAttribute(NSAttributedStringKey.paragraphStyle, value: leftAlignment, range: NSMakeRange(0, leftHeaderAttrString.length))
                        leftHeaderAttrString.addAttribute(NSAttributedStringKey.font, value: regularFont, range: NSMakeRange(0, leftHeaderAttrString.length))
                        leftHeaderAttrString.addAttribute(NSAttributedStringKey.font, value: boldFont, range: leftHeaderAttrString.mutableString.range(of: item.heading!))
                        leftHeaderAttrString.addAttribute(NSAttributedStringKey.font, value: regularFont, range: leftHeaderAttrString.mutableString.range(of: item.subHeading!))
                        let header = SimplePDF.HeaderFooterText(type: .header, pageRange: NSMakeRange(0, Int.max), attributedString: leftHeaderAttrString)
                        pdf.headerFooterTexts.append(header)
                        
                    }
                    
                    if item.footer != nil {
                        
                        // add a link to your app may be
                        
                        let link = NSMutableAttributedString(string: item.footer!)
                        link.addAttribute(NSAttributedStringKey.paragraphStyle, value: leftAlignment, range: NSMakeRange(0, link.length))
                        link.addAttribute(NSAttributedStringKey.font, value: regularFont, range: NSMakeRange(0, link.length))
                        let appLinkFooter = SimplePDF.HeaderFooterText(type: .footer, pageRange: NSMakeRange(0, Int.max), attributedString: link)
                        pdf.headerFooterTexts.append(appLinkFooter)
                    }
                }
            }
        }catch {
            print(error.localizedDescription)
        }
        
    }
    
    @IBAction func dismissAnotherPhoto(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    func getContext () -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        
        let AppointmentID = defaults.value(forKey: "AppointmentID") as! String
        
        if fileAnotherPhotoStored == "" {
            
            let actionController = YoutubeActionController()
            
            actionController.addAction(Action(ActionData(title: "Exit", image: UIImage(named: "exit")!), style: .default, handler: { action in
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
                self.present(nextViewController, animated:true, completion:nil)
                
            }))
            
            actionController.addAction(Action(ActionData(title: "Skip", image: UIImage(named: "skip")!), style: .default, handler: { action in
                
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AddRx") as! AddRX
                self.present(nextViewController, animated:true, completion:nil)
                
            }))
            
            actionController.addAction(Action(ActionData(title: "Cancel", image: UIImage(named: "cancel")!), style: .default, handler: { action in
            }))
            
            present(actionController, animated: true, completion: nil)
            
        } else {
            
            let actionController = YoutubeActionController()
            
            actionController.addAction(Action(ActionData(title: "Save", image: UIImage(named: "saveImage")!), style: .default, handler: { action in
                
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
                        self.fileAnotherPhotoStored = "true"
                        
                      /*  if let image = self.imageView.image {
                            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                        }*/
                        
                    }
                }catch {
                    print(error.localizedDescription)
                    
                    
                }
                
            }))
            
            actionController.addAction(Action(ActionData(title: "Next", image: UIImage(named: "saveNext")!), style: .default, handler: { action in
                
                if self.fileAnotherPhotoStored == "false" {
                    
                    let alert = UIAlertController(title: "Hold On", message: "Changes have not been saved. Do you want to leave without saving?", preferredStyle: UIAlertControllerStyle.alert)
                    let action = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: self.yesExit)
                    let cancel = UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil)
                    alert.addAction(action)
                    alert.addAction(cancel)
                    
                    
                    self.present(alert, animated: true, completion: nil);
                    
                } else {
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AddRx") as! AddRX
                    self.present(nextViewController, animated:true, completion:nil)
                    
                }
                
                
            }))
            
            actionController.addAction(Action(ActionData(title: "Exit", image: UIImage(named: "exit")!), style: .default, handler: { action in
                
                if self.fileAnotherPhotoStored == "false" {
                    
                    let alert = UIAlertController(title: "Hold On", message: "Changes have not been saved. Do you want to leave without saving?", preferredStyle: UIAlertControllerStyle.alert)
                    let action = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: self.yesExit)
                    let cancel = UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil)
                    alert.addAction(action)
                    alert.addAction(cancel)
                    
                    
                    self.present(alert, animated: true, completion: nil);
                    
                } else {
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
                    self.present(nextViewController, animated:true, completion:nil)
                    
                }
                
            }))
            
            actionController.addAction(Action(ActionData(title: "Cancel", image: UIImage(named: "cancel")!), style: .default, handler: { action in
            }))
            
            present(actionController, animated: true, completion: nil)
        }
        
             
    }
    
    func yesExit(alert: UIAlertAction){
        
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
            print(switchON)
            if switchON == false{
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "AddRx") as! AddRX
                self.present(nextViewController, animated:true, completion:nil)
                SwiftSpinner.hide()
            } else {
                SwiftSpinner.hide()
            }
        }
        
    }

    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width:newWidth, height:newHeight))
        image.draw(in: CGRect(x:0, y:0, width:newWidth, height:newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
