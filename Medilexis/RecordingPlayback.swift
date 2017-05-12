//
//  RecordingPlayVC.swift
//  Medilexis
//
//  Created by iOS Developer on 16/02/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit
import AVFoundation
import Speech
import SwiftSpinner
import SystemConfiguration
import SCLAlertView
import CoreData
import SimplePDFSwift

class RecordingPlayback: UIViewController, AVAudioPlayerDelegate, UITextViewDelegate, UIDocumentInteractionControllerDelegate {
 
    @IBOutlet weak var recordedTransciption: UITextView!
    @IBOutlet weak var progressView: UISlider!
    @IBOutlet weak var progressTime: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var pause: UIButton!
    @IBOutlet weak var play: UIButton!
    @IBOutlet weak var stop: UIButton!
    @IBOutlet weak var transcribe: UIButton!
    @IBOutlet weak var transcribeLabel: UILabel!
    @IBOutlet weak var saveExit: UIButton!
    @IBOutlet weak var saveExitLabel: UILabel!
    
    
    
    let defaults = UserDefaults.standard
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var fileURL: URL!
    var timer:Timer!
    var audioPlayer = AVAudioPlayer()
    var elapsedTimeInSecond: Int = 0

    
    func getContext () -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        activityIndicator.isHidden = true
        saveExit.isHidden = true
        saveExitLabel.isHidden = true
        progressView.isEnabled = false
        pause.isEnabled = false
        stop.isEnabled = false
        recordedTransciption.delegate = self
        recordedTransciption.layer.cornerRadius = 10
        fetchTranscription()
        
        
        let patientid = defaults.value(forKey: "PatientID") as! String
        
        let fetchRequest:NSFetchRequest<Sounds> = Sounds.fetchRequest()
        let predicate = NSPredicate(format: "(patientID = %@)", patientid)
        fetchRequest.predicate = predicate
        
        do {
            let count = try getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            if count > 0 {
                
                let fetchResult = try context.fetch(fetchRequest)
                
                for item in fetchResult {
                    
                    if item.recordingURL != "N/A" {
                        
                        let selectedAudioFileName = defaults.value(forKey: "RecordingName") as! String
                        
                        let fileManager = FileManager.default
                        let urls = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
                        let documentsDirectoryURL: URL = urls.first!
                        fileURL = documentsDirectoryURL.appendingPathComponent(selectedAudioFileName + ".m4a")

                        do {
                            
                            audioPlayer = try AVAudioPlayer(contentsOf: fileURL)
                            audioPlayer.prepareToPlay()
                            audioPlayer.delegate = self
                            
                            let ctime = Float(audioPlayer.duration)
                            progressView.maximumValue = ctime
                            transcribe.isHidden = false
                            transcribeLabel.isHidden = false
                            
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
    
    func doneClicked(){
        
        self.view.endEditing(true)
        if recordedTransciption.text == ""{
            recordedTransciption.text = "Tap in the box to start typing or click on transcribe button below to convert your recorded voice file to text."
        }
        
        if recordedTransciption.text != "Tap in the box to start typing or click on transcribe button below to convert your recorded voice file to text."{
            saveExit.isHidden = false
            saveExitLabel.isHidden = false
        }
        
    }

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
            self.elapsedTimeInSecond += 1
            self.updateTimeLabel()
        })
        
    }
    
    func pauseTimer() {
        timer?.invalidate()
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
    
    @IBAction func pause(_ sender: UIButton) {
        audioPlayer.pause()
        pauseTimer()
    }
    
    @IBAction func play(_ sender: UIButton) {
        
        
        if !audioPlayer.isPlaying{
            audioPlayer.play()
            startTimer()
            progressView.isEnabled = true
            pause.isEnabled = true
            stop.isEnabled = true
            Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
       
        }
    }
    
    @IBAction func stop(_ sender: Any) {
        
        audioPlayer.stop()
        audioPlayer.currentTime = 0
        // progressView.progress = 0.0
        resetTimer()
        progressView.isEnabled = false
        pause.isEnabled = false
        stop.isEnabled = false
        
        
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        resetTimer()
        progressView.isEnabled = false
        stop.isEnabled = false
        pause.isEnabled = false
    }
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        let alert = UIAlertController(title: "Recorder Pro", message: "Decoding Error: \(error?.localizedDescription)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func recordingPlayBackBtn(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
       
        let patientid = defaults.value(forKey: "PatientID") as! String
        
        let fetchRequest:NSFetchRequest<Sounds> = Sounds.fetchRequest()
        let predicate = NSPredicate(format: "(patientID = %@)", patientid)
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
    
    @IBAction func transcribe(_ sender: UIButton) {
        
        if currentReachabilityStatus == .reachableViaWiFi ||  currentReachabilityStatus == .reachableViaWWAN {
            
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            
            SFSpeechRecognizer.requestAuthorization { authStatus in
                if authStatus == SFSpeechRecognizerAuthorizationStatus.authorized {
                    
                    let recognizer = SFSpeechRecognizer()
                    let request = SFSpeechURLRecognitionRequest(url: self.fileURL)
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
    
    @IBAction func home(_ sender: UIBarButtonItem) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    
    func fetchTranscription(){
        
            let patientid = defaults.value(forKey: "PatientID") as! String
        
            let fetchRequest:NSFetchRequest<Sounds> = Sounds.fetchRequest()
            
            let predicate = NSPredicate(format: "(patientID = %@)", patientid)

            fetchRequest.predicate = predicate
        
            do {
                let fetchResult = try getContext().fetch(fetchRequest)
                
                for item in fetchResult {
                    
                  
                   // recordedTransciption.text = ""
                    recordedTransciption.text = item.transcription
                    
                    
                }
            }catch {
                print(error.localizedDescription)
            }
        
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        
        let patientID = defaults.value(forKey: "PatientID")
        recordedTransciption.resignFirstResponder()
        
        let fetchRequest:NSFetchRequest<Sounds> = Sounds.fetchRequest()
        
        let predicate = NSPredicate(format: "(patientID = %@)", patientID as! CVarArg)
        
        fetchRequest.predicate = predicate
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            
            for item in fetchResult {
                
                item.transcription! =  recordedTransciption.text
                try context.save()
  
                let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
                self.present(nextViewController, animated:true, completion:nil)
                
                
            }
        }catch {
            print(error.localizedDescription)
        
       }
        
        ///update into patients
        let patientsFetchRequest:NSFetchRequest<Patients> = Patients.fetchRequest()
        
        let patientPredicate = NSPredicate(format: "(patientID = %@)", patientID as! CVarArg)
        patientsFetchRequest.predicate = patientPredicate
        
        do {
            let fetchResult = try context.fetch(patientsFetchRequest)
            
            for item in fetchResult {
                
                item.isTranscribed = true
                
                
                try context.save()
        
                
            }
        }catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchRecordedTranscription(){
        if currentReachabilityStatus == .reachableViaWiFi {
            
            SFSpeechRecognizer.requestAuthorization { authStatus in
                if authStatus == SFSpeechRecognizerAuthorizationStatus.authorized {
                    
                    let recognizer = SFSpeechRecognizer()
                    let request = SFSpeechURLRecognitionRequest(url: self.fileURL)
                    recognizer?.recognitionTask(with: request) { (result, error) in
                        
                        if let error = error {
                            self.recordedTransciption.text = "There was an error: \(error)"
                            
                            
                        } else {
                            self.recordedTransciption.text = ""
                            self.recordedTransciption.text = result?.bestTranscription.formattedString
                            
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
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if recordedTransciption.text == "Tap in the box to start typing or click on transcribe button below to convert your recorded voice file to text." {
            recordedTransciption.text = nil
        }
    }
    
    // MARK: - UIDocumentInteractionControllerDelegate
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    @IBAction func printTemplate(_ sender: UIButton) {
        
        
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
        
        let text3 = ""
        pdf.addBodyText(text3)
        
        let text4 = ""
        pdf.addBodyText(text4)
        
        let text = String(describing: recordedTransciption.text!)
        pdf.addBodyText(text)
        
      
        
    }
    
    fileprivate func addHeadersFooters(_ pdf: SimplePDF) {
        
        let headerOne = defaults.value(forKey: "HeaderOne") as! String
        let headerTwo = defaults.value(forKey: "HeaderTwo") as! String
        let FooterOne = defaults.value(forKey: "FooterOne")
        //let FooterTwo = defaults.value(forKey: "FooterTwo")
        
        let regularFont = UIFont.systemFont(ofSize: 18)
        let boldFont = UIFont.boldSystemFont(ofSize: 20)
        let leftAlignment = NSMutableParagraphStyle()
        leftAlignment.alignment = NSTextAlignment.left
        
        
        // add a logo to the header, on right
        
        if let imgData = defaults.value(forKey: "TemplateImage") as? NSData {
            let retrievedImg = UIImage(data: imgData as Data)
            
            //let image : UIImage = UIImage(named: "logo")!
            //  let logoPath = Bundle.main.path(forResource: "Demo", ofType: "png")
            // NOTE: we can specify either the image or its path
            let rightLogo = SimplePDF.HeaderFooterImage(type: .header, pageRange: NSMakeRange(0, 1),
                                                        image:retrievedImg, imageHeight: 55, alignment: .right)
            pdf.headerFooterImages.append(rightLogo)
        }
      
        
        
        // add some document information to the header, on left
        let leftHeaderString = "\(headerOne)\n\(headerTwo)"
        let leftHeaderAttrString = NSMutableAttributedString(string: leftHeaderString)
        leftHeaderAttrString.addAttribute(NSParagraphStyleAttributeName, value: leftAlignment, range: NSMakeRange(0, leftHeaderAttrString.length))
        leftHeaderAttrString.addAttribute(NSFontAttributeName, value: regularFont, range: NSMakeRange(0, leftHeaderAttrString.length))
        leftHeaderAttrString.addAttribute(NSFontAttributeName, value: boldFont, range: leftHeaderAttrString.mutableString.range(of: headerOne))
        leftHeaderAttrString.addAttribute(NSFontAttributeName, value: regularFont, range: leftHeaderAttrString.mutableString.range(of: headerTwo))
        let header = SimplePDF.HeaderFooterText(type: .header, pageRange: NSMakeRange(0, 1), attributedString: leftHeaderAttrString)
        pdf.headerFooterTexts.append(header)
        
        
        // add a link to your app may be
        
        let link = NSMutableAttributedString(string: FooterOne as! String)
        link.addAttribute(NSParagraphStyleAttributeName, value: leftAlignment, range: NSMakeRange(0, link.length))
        link.addAttribute(NSFontAttributeName, value: regularFont, range: NSMakeRange(0, link.length))
        let appLinkFooter = SimplePDF.HeaderFooterText(type: .footer, pageRange: NSMakeRange(0, 1), attributedString: link)
        pdf.headerFooterTexts.append(appLinkFooter)
        
        
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
    
    func updateSlider(){
        
        progressView.value = Float(audioPlayer.currentTime)
        let changedValue = Int(progressView.value)
        let seconds = changedValue % 60
        let minutes = (changedValue / 60) % 60
        progressTime.text = String(format: "%02d:%02d", minutes, seconds)
       
      
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        if recordedTransciption.text == ""{
            recordedTransciption.text = "Tap in the box to start typing or click on transcribe button below to convert your recorded voice file to text."
        }
        
    }
    

}
