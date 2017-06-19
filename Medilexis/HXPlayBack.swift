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


class HXPlayBack: UIViewController, AVAudioPlayerDelegate, UITextViewDelegate, UITabBarDelegate {

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
    @IBOutlet weak var transcribeLabel: UILabel!
    @IBOutlet weak var saveExitLabel: UILabel!
    @IBOutlet weak var saveNextLabel: UILabel!
    
    let defaults = UserDefaults.standard
    var HXfileURL: URL!
    var timer:Timer!
    var audioPlayer = AVAudioPlayer()
    var elapsedTimeInSecond: Int = 0
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = true
        saveExit.isHidden = true
        saveExitLabel.isHidden = true
        saveNext.isHidden = true
        saveNextLabel.isHidden = true
        progressView.isEnabled = false
        pause.isEnabled = false
        stop.isEnabled = false
        recordedTransciption.delegate = self
        recordedTransciption.layer.cornerRadius = 10
        fetchTranscription()
        
        let patientid = defaults.value(forKey: "PatientID") as! String
        let type = "HX"
        
        let fetchRequest:NSFetchRequest<Sounds> = Sounds.fetchRequest()
        let predicate = NSPredicate(format: "(patientID = %@) AND (type = %@)", patientid, type)
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
    
    func doneClicked(){
        
        self.view.endEditing(true)
        
        if recordedTransciption.text == ""{
            recordedTransciption.text = "Tap in the box to start typing or click on transcribe button below to convert your recorded voice file to text."
        }
        
        if recordedTransciption.text != "Tap in the box to start typing or click on transcribe button below to convert your recorded voice file to text."{
            saveExit.isHidden = false
            saveExitLabel.isHidden = false
            saveNext.isHidden = false
            saveNextLabel.isHidden = false
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
        
        let patientID = defaults.value(forKey: "PatientID")
        let type = "HX"
        recordedTransciption.resignFirstResponder()
        
        let fetchRequest:NSFetchRequest<Sounds> = Sounds.fetchRequest()
        let predicate = NSPredicate(format: "(patientID = %@) AND (type = %@)", patientID as! CVarArg, type)
        fetchRequest.predicate = predicate
        
        do {
            
            let count = try getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            if count > 0 {
                
                let fetchResult = try getContext().fetch(fetchRequest)
                
                for item in fetchResult {
                    
                    item.transcription! =  recordedTransciption.text
                    try context.save()
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
                    self.present(nextViewController, animated:true, completion:nil)
                }
            } else {
                
                ///insert into sounds
                let patientid = defaults.value(forKey: "PatientID") as! String
                let context = getContext()
                
                let sounds = NSEntityDescription.entity(forEntityName: "Sounds", in: context)
                
                let managedObj = NSManagedObject(entity: sounds!, insertInto: context)
                
                managedObj.setValue(patientid, forKey: "patientID")
                managedObj.setValue("N/A", forKey: "recordingName")
                managedObj.setValue("N/A", forKey: "recordingURL")
                managedObj.setValue(recordedTransciption.text, forKey: "transcription")
                managedObj.setValue("HX", forKey: "type")
                
                do {
                    try context.save()
                    recordedTransciption.resignFirstResponder()
                    saveNext.isEnabled = false
                    saveNextLabel.isEnabled = false
                    saveExitLabel.isEnabled = false
                    saveExit.isEnabled = false
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
                    self.present(nextViewController, animated:true, completion:nil)
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            
        }catch {
            print(error.localizedDescription)
            
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        
        resetTimer()
        progressView.isEnabled = false
        stop.isEnabled = false
        pause.isEnabled = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        let patientid = defaults.value(forKey: "PatientID") as! String
        let type = "HX"
        
        let fetchRequest:NSFetchRequest<Sounds> = Sounds.fetchRequest()
        let predicate = NSPredicate(format: "(patientID = %@) AND (type = %@)", patientid, type)
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
        let alert = UIAlertController(title: "Recorder Pro", message: "Decoding Error: \(error?.localizedDescription)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getContext () -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    func fetchTranscription(){
        
        let patientid = defaults.value(forKey: "PatientID") as! String
        let type = "HX"
        
        let fetchRequest:NSFetchRequest<Sounds> = Sounds.fetchRequest()
        let predicate = NSPredicate(format: "(patientID = %@) AND (type = %@)", patientid, type)
        fetchRequest.predicate = predicate
        
        do {
            let fetchResult = try getContext().fetch(fetchRequest)
            
            for item in fetchResult {
                
                recordedTransciption.text = item.transcription
                
                
            }
        }catch {
            print(error.localizedDescription)
        }
        
    }
    @IBAction func dismissHPI(_ sender: UIBarButtonItem) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func navigateToHome(_ sender: UIBarButtonItem) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if recordedTransciption.text == "Tap in the box to start typing or click on transcribe button below to convert your recorded voice file to text." {
            recordedTransciption.text = nil
        }
    }
    
    @IBAction func saveNext(_ sender: UIButton) {
        
        let type = "HX"
        let patientID = defaults.value(forKey: "PatientID")
        let fetchRequest:NSFetchRequest<Sounds> = Sounds.fetchRequest()
        let predicate = NSPredicate(format: "(patientID = %@) AND (type = %@)", patientID! as! CVarArg, type)
        fetchRequest.predicate = predicate
        
        do {
            
            let count = try getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            if count > 0 {
                
                let fetchResult = try getContext().fetch(fetchRequest)
                
                for item in fetchResult {
                    
                    item.transcription! =  recordedTransciption.text
                    try context.save()
                    
                    self.tabBarController?.selectedIndex = 3
                }
                
            } else {
                
                ///insert into sounds
                let patientid = defaults.value(forKey: "PatientID") as! String
                let context = getContext()
                
                let sounds = NSEntityDescription.entity(forEntityName: "Sounds", in: context)
                
                let managedObj = NSManagedObject(entity: sounds!, insertInto: context)
                
                managedObj.setValue(patientid, forKey: "patientID")
                managedObj.setValue("N/A", forKey: "recordingName")
                managedObj.setValue("N/A", forKey: "recordingURL")
                managedObj.setValue(recordedTransciption.text, forKey: "transcription")
                managedObj.setValue("HX", forKey: "type")
                
                do {
                    try context.save()
                    recordedTransciption.resignFirstResponder()
                    saveNext.isEnabled = false
                    saveNextLabel.isEnabled = false
                    saveExitLabel.isEnabled = false
                    saveExit.isEnabled = false
                    
                    self.tabBarController?.selectedIndex = 3
                    
                } catch {
                    print(error.localizedDescription)
                }
            }
            
            
        }catch {
            print(error.localizedDescription)
        }
        

       
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
    }
    
}
