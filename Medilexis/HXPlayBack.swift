//
//  HXPlayBack.swift
//  Medilexis
//
//  Created by iOS Developer on 10/04/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation
import Speech
import SwiftSpinner
import SimplePDFSwift


class HXPlayBack: UIViewController, AVAudioPlayerDelegate, UITextViewDelegate, UITabBarDelegate, UIDocumentInteractionControllerDelegate{

    @IBOutlet weak var recordedTransciption: UITextView!
    @IBOutlet weak var progressView: UISlider!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var pause: UIButton!
    @IBOutlet weak var stop: UIButton!
    @IBOutlet weak var progressTime: UILabel!
    @IBOutlet weak var play: UIButton!
    @IBOutlet weak var transcribe: UIButton!
    @IBOutlet weak var saveExit: UIButton!
    @IBOutlet weak var saveNext: UIButton!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var skipButton: UIButton!
    @IBOutlet weak var transcribeLabel: UILabel!
    @IBOutlet weak var saveExitLabel: UILabel!
    @IBOutlet weak var saveNextLabel: UILabel!
    @IBOutlet var saveLabel: UILabel!
    @IBOutlet var skipLabel: UILabel!
    @IBOutlet var saveLine: UIView!
    @IBOutlet var nextLine: UIView!
    @IBOutlet var exitLine: UIView!
    @IBOutlet var transcribeLine: UIView!
    @IBOutlet var skipLine: UIView!
    
    
    let defaults = UserDefaults.standard
    var HXfileURL: URL!
    var timer:Timer!
    var audioPlayer = AVAudioPlayer()
    var elapsedTimeInSecond: Int = 0
    var fileHXStored = ""
    var hxtext: String!
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = true
        saveExit.isHidden = false
        saveExitLabel.isHidden = false
        saveNext.isHidden = true
        saveNextLabel.isHidden = true
        transcribeLine.isHidden = true
        saveLine.isHidden = true
        nextLine.isHidden = true
        exitLine.isHidden = true
        saveButton.isHidden = true
        saveLabel.isHidden = true
        progressView.isEnabled = false
        pause.isEnabled = false
        stop.isEnabled = false
        recordedTransciption.delegate = self
        recordedTransciption.layer.cornerRadius = 10
        fetchTranscription()
        
        let AppointmentID = defaults.value(forKey: "AppointmentID") as! String
        let type = "HX"
        
        let fetchRequest:NSFetchRequest<Sounds> = Sounds.fetchRequest()
        let predicate = NSPredicate(format: "(appointmentID = %@) AND (type = %@)", AppointmentID, type)
        fetchRequest.predicate = predicate
        
        do {
            let count = try getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            if count > 0 {
                
                let fetchResult = try context.fetch(fetchRequest)
                
                for item in fetchResult {
                    
                    if item.recordingURL != "N/A" {
                        
                       // let selectedAudioFileName = defaults.value(forKey: "RecordingName") as! String
                        
                        progressView.isEnabled = false
                        pause.isEnabled = false
                        stop.isEnabled = false
                        recordedTransciption.delegate = self
                        recordedTransciption.delegate = self
                        recordedTransciption.layer.cornerRadius = 20
                        activityIndicator.isHidden = true
                        
                        let fileManager = FileManager.default
                        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
                        let documentsDirectoryURL: URL = urls.first!
                        HXfileURL = documentsDirectoryURL.appendingPathComponent(item.recordingName! + ".m4a")
                        
                        do {
                            audioPlayer = try AVAudioPlayer(contentsOf: HXfileURL)
                            audioPlayer.prepareToPlay()
                            audioPlayer.delegate = self
                            
                            let ctime = Float(audioPlayer.duration)
                            progressView.maximumValue = ctime
                            
                        } catch let error as NSError {
                            print("AUDIO PLAYER ERROR\n\(error.localizedDescription)")
                        }
                        
                    } else {
                        
                        transcribe.isHidden = true
                        transcribeLabel.isHidden = true
                        progressView.isEnabled = false
                        pause.isEnabled = false
                        stop.isEnabled = false
                        play.isEnabled = false
                        activityIndicator.isHidden = true
                        
                    }
                }
                
            } else {
                
                progressView.isEnabled = false
                pause.isEnabled = false
                stop.isEnabled = false
                play.isEnabled = false
                transcribe.isHidden = true
                transcribeLabel.isHidden = true
                activityIndicator.isHidden = true
            }
        }catch {
            print(error.localizedDescription)
        }
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        recordedTransciption.inputAccessoryView = toolBar
    }
    
    @objc func doneClicked(){
        
        self.view.endEditing(true)
        
        if recordedTransciption.text == ""{
            recordedTransciption.text = "Tap to start typing or press the record button to start recording (Recorded file can be converted into text via transcribe button to appear below)"
            saveExit.isHidden = true
            saveExitLabel.isHidden = true
            saveNext.isHidden = true
            saveNextLabel.isHidden = true
        }
        
        if recordedTransciption.text != hxtext {
       
            saveExit.isHidden = false
            saveExitLabel.isHidden = false
            saveNext.isHidden = false
            saveNextLabel.isHidden = false
            saveButton.isHidden = false
            saveLabel.isHidden = false
            saveLine.isHidden = false
            skipButton.isHidden = false
            skipLabel.isHidden = false
            skipLine.isHidden = true
            
            fileHXStored = "false"
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func play(_ sender: UIButton) {
        
        if !audioPlayer.isPlaying{
            audioPlayer.play()
            progressView.isEnabled = true
            pause.isEnabled = true
            stop.isEnabled = true
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
        }
    }
    
    @IBAction func stop(_ sender: Any) {
        
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        resetTimer()
        progressView.isEnabled = false
        pause.isEnabled = false
        stop.isEnabled = false
    }
 
    
    func resetTimer() {
        timer?.invalidate()
        elapsedTimeInSecond = 0
        updateTimeLabel()
    }
    
    func updateTimeLabel() {
        
        let seconds = elapsedTimeInSecond % 60
        let minutes = (elapsedTimeInSecond / 60) % 60
        
        progressTime.text = String(format: "%02d:%02d", minutes, seconds)
    }
    
    @IBAction func transcribe(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Hold On", message: "Dictation will be transcribed. Existing transcription may be overwritten. Do you want to continue?", preferredStyle: UIAlertControllerStyle.alert)
        let action = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: self.yesDictate)
        let cancel = UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil)
        alert.addAction(action)
        alert.addAction(cancel)
        
        self.present(alert, animated: true, completion: nil);
    
    }
    
    func yesDictate(alert: UIAlertAction){
        
        if currentReachabilityStatus == .reachableViaWiFi ||  currentReachabilityStatus == .reachableViaWWAN {
            
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            
            SFSpeechRecognizer.requestAuthorization { authStatus in
                if authStatus == SFSpeechRecognizerAuthorizationStatus.authorized {
                    
                    let recognizer = SFSpeechRecognizer()
                    let request = SFSpeechURLRecognitionRequest(url: self.HXfileURL)
                    recognizer?.recognitionTask(with: request) { (result, error) in
                        
                        if let error = error {
                            
                            print(error)
                            
                            DispatchQueue.main.async {
                                
                                let alert = UIAlertController(title: "Voice not recognized", message: "Unable to recognize voice", preferredStyle: UIAlertControllerStyle.alert)
                                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                                alert.addAction(action)
                                
                                self.present(alert, animated: true, completion: nil);
                                
                                self.activityIndicator.stopAnimating()
                                self.activityIndicator.isHidden = true
                                
                            }
                            
                            
                        } else {
                            self.recordedTransciption.text = ""
                            self.recordedTransciption.text = result?.bestTranscription.formattedString
                            self.activityIndicator.stopAnimating()
                            self.activityIndicator.isHidden = true
                            
                        }
                    }
                }
            }
            
        } else {
            
            DispatchQueue.main.async {
                
                let alert = UIAlertController(title: "No Connection", message: "Please check your internet connection and try again!", preferredStyle: UIAlertControllerStyle.alert)
                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil);
            }
        }
    }
    
    @IBAction func pause(_ sender: UIButton) {
        
        audioPlayer.pause()
    }
    
    @IBAction func saveExit(_ sender: UIButton) {
        
        if fileHXStored == "false" {
            
            let alert = UIAlertController(title: "Hold On", message: "Changes have not been saved. Do you want to leave without saving?", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: yes)
            let cancel = UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            alert.addAction(cancel)
            
            
            self.present(alert, animated: true, completion: nil);
            
        } else {
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
            self.present(nextViewController, animated:true, completion:nil)
        }
    }
    
    func yesExit(alert: UIAlertAction){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        resetTimer()
        progressView.isEnabled = false
        stop.isEnabled = false
        pause.isEnabled = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        let AppointmentID = defaults.value(forKey: "AppointmentID") as! String
        let type = "HX"
        
        let fetchRequest:NSFetchRequest<Sounds> = Sounds.fetchRequest()
        let predicate = NSPredicate(format: "(appointmentID = %@) AND (type = %@)", AppointmentID, type)
        fetchRequest.predicate = predicate
        
        do {
            let count = try getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            if count > 0 {
                
                let fetchResult = try context.fetch(fetchRequest)
                
                for item in fetchResult {
                    
                    if item.recordingURL != "N/A" {
                        
                        if audioPlayer.isPlaying {
                            audioPlayer.stop() // Stop the sound that's playing
                        }
                        
                    }
                }
                
            }
        }catch {
            print(error.localizedDescription)
        }

    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        let alert = UIAlertController(title: "Recorder Pro", message: "Decoding Error: \(String(describing: error?.localizedDescription))", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getContext () -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func fetchTranscription(){
        
        let AppointmentID = defaults.value(forKey: "AppointmentID") as! String
        let type = "HX"
        
        let fetchRequest:NSFetchRequest<Sounds> = Sounds.fetchRequest()
        let predicate = NSPredicate(format: "(appointmentID = %@) AND (type = %@)", AppointmentID, type)
        fetchRequest.predicate = predicate
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            
            for item in fetchResult {
                
                recordedTransciption.text = item.transcription
                self.hxtext = item.transcription
                
                
            }
        }catch {
            print(error.localizedDescription)
        }
        
    }
    @IBAction func dismissHPI(_ sender: UIBarButtonItem) {
        
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if recordedTransciption.text == "Tap to start typing or press the record button to start recording (Recorded file can be converted into text via transcribe button to appear below)" {
            recordedTransciption.text = nil
        }
    }
    
    @IBAction func saveNext(_ sender: UIButton) {
        
        if fileHXStored == "false" {
            
            let alert = UIAlertController(title: "Hold On", message: "Changes have not been saved. Do you want to leave without saving?", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: yes)
            let cancel = UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            alert.addAction(cancel)
            
            
            self.present(alert, animated: true, completion: nil);
            
        } else {
            
            self.tabBarController?.selectedIndex = 3
            
            saveLine.isHidden = true
            nextLine.isHidden = true
            exitLine.isHidden = true
            saveButton.isHidden = true
            saveLabel.isHidden = true
            saveNext.isHidden = true
            saveNextLabel.isHidden = true
            saveExit.isHidden = true
            saveExitLabel.isHidden = true
            skipButton.isHidden = false
            skipLabel.isHidden = false
            skipLine.isHidden = false
        
        }
    }
    
    func yes(alert: UIAlertAction){
        
        self.tabBarController?.selectedIndex = 3
        
        saveLine.isHidden = true
        nextLine.isHidden = true
        exitLine.isHidden = true
        saveButton.isHidden = true
        saveLabel.isHidden = true
        saveNext.isHidden = true
        saveNextLabel.isHidden = true
        saveExit.isHidden = true
        saveExitLabel.isHidden = true
        skipButton.isHidden = false
        skipLabel.isHidden = false
        skipLine.isHidden = false
        
    }
    
    @IBAction func changeAudioTime(_ sender: UISlider) {
        
        let test = Int(sender.value)
        
        let seconds = test % 60
        let minutes = (test / 60) % 60
        
        
        audioPlayer.stop()
        audioPlayer.currentTime = TimeInterval(sender.value)
        audioPlayer.prepareToPlay()
        audioPlayer.play()
        progressTime.text = String(format: "%02d:%02d", minutes, seconds)
    }
    
    @objc func updateSlider(){
        
        progressView.value = Float(audioPlayer.currentTime)
        let changedValue = Int(progressView.value)
        let seconds = changedValue % 60
        let minutes = (changedValue / 60) % 60
        progressTime.text = String(format: "%02d:%02d", minutes, seconds)
        
    }
    
    @IBAction func savePressed(_ sender: UIButton) {
        
        let type = "HX"
        let AppointmentID = defaults.value(forKey: "AppointmentID") as! String
        let fetchRequest:NSFetchRequest<Sounds> = Sounds.fetchRequest()
        let predicate = NSPredicate(format: "(appointmentID = %@) AND (type = %@)", AppointmentID as CVarArg, type)
        fetchRequest.predicate = predicate
        
        do {
            
            let count = try getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            if count > 0 {
                
                let fetchResult = try getContext().fetch(fetchRequest)
                
                for item in fetchResult {
                    
                    item.transcription! =  recordedTransciption.text
                    try context.save()
                    saveLine.isHidden = true
                    transcribeLine.isHidden = true
                    exitLine.isHidden = true
                    skipLine.isHidden = true
                    nextLine.isHidden = false
                    fileHXStored = "true"
                }
                
            } else {
                
                ///insert into sounds
                let AppointmentID = defaults.value(forKey: "AppointmentID") as! String
                let context = getContext()
                
                let sounds = NSEntityDescription.entity(forEntityName: "Sounds", in: context)
                
                let managedObj = NSManagedObject(entity: sounds!, insertInto: context)
                
                managedObj.setValue(AppointmentID, forKey: "appointmentID")
                managedObj.setValue("N/A", forKey: "recordingName")
                managedObj.setValue("N/A", forKey: "recordingURL")
                managedObj.setValue(recordedTransciption.text, forKey: "transcription")
                managedObj.setValue("HX", forKey: "type")
                
                do {
                    try context.save()
                    saveLine.isHidden = true
                    transcribeLine.isHidden = true
                    exitLine.isHidden = true
                    skipLine.isHidden = true
                    nextLine.isHidden = false
                    fileHXStored = "true"
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            
        }catch {
            print(error.localizedDescription)
        }
    }
    
    @IBAction func skipPressed(_ sender: UIButton) {
        
        if fileHXStored == "false" {
            
            let alert = UIAlertController(title: "Hold On", message: "Changes have not been saved. Do you want to leave without saving?", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: yes)
            let cancel = UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            alert.addAction(cancel)
            
            
            self.present(alert, animated: true, completion: nil);
            
        } else {
            
            self.tabBarController?.selectedIndex = 3
        }
        
    }

}
