//
//  singleDictation.swift
//  Medilexis
//
//  Created by iOS Developer on 27/02/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit
import AVFoundation
import Speech
import SystemConfiguration
import SCLAlertView
import CoreData

class singleDictation: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate, UITextViewDelegate  {

    @IBOutlet weak var recordPause: UIButton!
    @IBOutlet weak var stop: UIButton!
    @IBOutlet weak var play: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var transcribe: UIButton!
    @IBOutlet weak var save: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var progressView: UISlider!
    @IBOutlet weak var transcribeLabel: UILabel!
    @IBOutlet weak var saveExitLabel: UILabel!
    
    
    var recorder: AVAudioRecorder!
    var player:AVAudioPlayer!
    var audioFileURL: URL!
    var soundFileName: String!
    var meterTimer:Timer!
    var timer: Timer?
    var recording: String!
    var elapsedTimeInSecond: Int = 0
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()

        stop.isEnabled = false
        play.isEnabled = false
        transcribe.isHidden = true
        save.isHidden = true
        transcribeLabel.isHidden = true
        saveExitLabel.isHidden = true
        activityIndicator.isHidden = true
        progressView.isEnabled = false
        textView.layer.cornerRadius = 10
        setSessionPlayback()
        
        textView.delegate = self
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)

        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        textView.inputAccessoryView = toolBar
        
        defaults.set("false", forKey: "Recording")
    }
    
    func doneClicked(){
        
       self.view.endEditing(true)
        if textView.text == ""{
            textView.text = "Tap in the box to start typing or click on transcribe button below to convert your recorded voice file to text."
        }
        
        if textView.text != "Tap in the box to start typing or click on transcribe button below to convert your recorded voice file to text."{
            save.isHidden = false
            saveExitLabel.isHidden = false
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func getContext () -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    
    @IBAction func recordPauseBtn(_ sender: UIButton) {
        
        let status = defaults.value(forKey: "Recording") as! String
        
        if status == "false"{
            if player != nil && player.isPlaying {
                player.stop()
            }
            
            if recorder == nil {
                recordPause.setImage(UIImage(named: "pause-btn"), for: UIControlState.normal)
                play.isEnabled = false
                stop.isEnabled = true
                progressView.isEnabled = false
                recordWithPermission(true)
                startTimer()
                defaults.set("false", forKey: "Recording")

                return
            }
            
            if recorder != nil && recorder.isRecording {
                pauseTimer()
                recorder.pause()
                recordPause.setImage(UIImage(named: "rec-btn"), for: UIControlState.normal)
                
            } else {
                
                startTimer()
                recordPause.setImage(UIImage(named: "pause-btn"), for: UIControlState.normal)
                play.isEnabled = false
                stop.isEnabled = true
                recordWithPermission(false)
                
                
            }
        } else {
           
            let alert = UIAlertController(title: "Overwrite Dictation", message: "Are you sure you want to overwrite your existing dictation?", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: Overwrite)
            let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: dismiss)
            alert.addAction(action)
            alert.addAction(cancel)
            
            self.present(alert, animated: true, completion: nil);
        }
    }
    
    func Overwrite(alert: UIAlertAction){
        
        defaults.set("false", forKey: "Recording")
        
        if player != nil && player.isPlaying {
            player.stop()
        }
        
        if recorder == nil {
            recordPause.setImage(UIImage(named: "pause-btn"), for: UIControlState.normal)
            play.isEnabled = false
            stop.isEnabled = true
            progressView.isEnabled = false
            recordWithPermission(true)
            startTimer()
            
            
            return
        }
        
        if recorder != nil && recorder.isRecording {
            pauseTimer()
            recorder.pause()
            recordPause.setImage(UIImage(named: "rec-btn"), for: UIControlState.normal)
            
        } else {
            
            startTimer()
            recordPause.setImage(UIImage(named: "pause-btn"), for: UIControlState.normal)
            play.isEnabled = false
            stop.isEnabled = true
            recordWithPermission(false)
            
            
        }
    }
    
    func dismiss(alert: UIAlertAction){
    }
    
    @IBAction func stop(_ sender: UIButton) {
        
        recorder?.stop()
        player?.stop()
        
        resetTimer()
        //meterTimer.invalidate()
        //statusLabel.text = "00:00"
        recordPause.setImage(UIImage(named: "rec-btn"), for: UIControlState.normal)
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(false)
            stop.isEnabled = false
            play.isEnabled = true
            transcribe.isHidden = false
            transcribeLabel.isHidden = false
            save.isHidden = false
            saveExitLabel.isHidden = false
            recordPause.isEnabled = true
            defaults.set("true", forKey: "Recording")
        } catch let error as NSError {
            print("could not make session inactive")
            print(error.localizedDescription)
        }
    }
    
    @IBAction func play(_ sender: UIButton) {
        
        setSessionPlayback()
        self.playback()
    }
    
    func playback(){
        
        var url:URL?
        if self.recorder != nil {
            url = self.recorder.url
        } else {
            url = self.audioFileURL!
        }
        
        do {
      
            self.player = try AVAudioPlayer(contentsOf: url!)
            
            let ctime = Float(player.duration)
            progressView.maximumValue = ctime
            
            timer =  Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)

            stop.isEnabled = true
            player.delegate = self
            player.prepareToPlay()
            player.volume = 1.0
            player.play()
            
            
        } catch let error as NSError {
            self.player = nil
            print(error.localizedDescription)
        }
    }
    
    @IBAction func speech(_ sender: UIButton) {
        
        if currentReachabilityStatus == .reachableViaWiFi ||  currentReachabilityStatus == .reachableViaWWAN {
            
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            
            SFSpeechRecognizer.requestAuthorization { authStatus in
                if authStatus == SFSpeechRecognizerAuthorizationStatus.authorized {
                    
                    let recognizer = SFSpeechRecognizer()
                    let request = SFSpeechURLRecognitionRequest(url: self.audioFileURL)
                    recognizer?.recognitionTask(with: request) { (result, error) in
                        
                        if let error = error {
                           // self.textView.text = "There was an error: \(error)"
                           
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
                            self.textView.text = ""
                            self.textView.text = result?.bestTranscription.formattedString
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
        
        statusLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }
    
    
    func setupRecorder() {
        
        let documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        
        let currentDateTime = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        recording = formatter.string(from: currentDateTime)+""
        soundFileName = recording + ".m4a"
        let outputPath = documentsPath.appendingPathComponent(self.soundFileName)
        audioFileURL = URL(fileURLWithPath: outputPath)
        
        
        // Setup audio session
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: AVAudioSessionCategoryOptions.defaultToSpeaker)
            
            // Define the recorder setting
            let recorderSetting: [String: AnyObject] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC) as AnyObject,
                AVSampleRateKey: 44100.0 as AnyObject,
                AVNumberOfChannelsKey: 2 as AnyObject,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue as AnyObject
            ]
            
            // Initiate and prepare the recorder
            recorder = try AVAudioRecorder(url: audioFileURL, settings: recorderSetting)
            recorder?.delegate = self
            recorder?.isMeteringEnabled = true
            recorder?.prepareToRecord()
        

        } catch {
            print(error)
        }
    }
    
    func recordWithPermission(_ setup:Bool) {
        
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        // ios 8 and later
        if (session.responds(to: #selector(AVAudioSession.requestRecordPermission(_:)))) {
            AVAudioSession.sharedInstance().requestRecordPermission({(granted: Bool)-> Void in
                if granted {
                   // print("Permission to record granted")
                    self.setSessionPlayAndRecord()
       
                    if setup {
                        //print("setup")
                        self.setupRecorder()
                    }
                    
                    self.recorder.record()
                    
                } else {
                    print("Permission to record not granted")
                }
            })
        } else {
            print("requestRecordPermission unrecognized")
        }
    }
    
    
    func setSessionPlayAndRecord() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        } catch let error as NSError {
            print("could not set session category")
            print(error.localizedDescription)
        }
        do {
            try session.setActive(true)
        } catch let error as NSError {
            print("could not make session active")
            print(error.localizedDescription)
        }
    }
    
    func setSessionPlayback() {
        let session:AVAudioSession = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSessionCategoryPlayback)
        } catch let error as NSError {
            print("could not set session category")
            print(error.localizedDescription)
        }
        do {
            try session.setActive(true)
        } catch let error as NSError {
            print("could not make session active")
            print(error.localizedDescription)
        }
    }
    
    func randomString(length: Int) -> String {
        
        let letters : NSString = "0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return  randomString
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            self.recorder = nil
        }
    }
    
    // MARK: - AVAudioPlayerDelegate Methods
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        play.setImage(UIImage(named: "play-icon"), for: UIControlState.normal)
        play.isSelected = false
        resetTimer()
        progressView.value = 0
        stop.isEnabled = false
    }
    
    @IBAction func dismiss(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    
    @IBAction func saveBtn(_ sender: UIButton) {
        
        if audioFileURL == nil {
            ///insert into sounds
            
            let patientid = defaults.value(forKey: "PatientID") as! String
            
            let context = getContext()
            
            let sounds = NSEntityDescription.entity(forEntityName: "Sounds", in: context)
            
            let managedObj = NSManagedObject(entity: sounds!, insertInto: context)
            
            managedObj.setValue(patientid, forKey: "patientID")
            managedObj.setValue("N/A", forKey: "recordingName")
            managedObj.setValue("N/A", forKey: "recordingURL")
            managedObj.setValue(textView.text, forKey: "transcription")
            managedObj.setValue("Letter", forKey: "type")
            
            do {
                try context.save()
                print("saved!")
                
            } catch {
                print(error.localizedDescription)
            }
            
            
            ///update into patients
            let fetchRequest:NSFetchRequest<Patients> = Patients.fetchRequest()
            
            let predicate = NSPredicate(format: "(patientID = %@)", patientid)
            fetchRequest.predicate = predicate
            
            do {
                let fetchResult = try context.fetch(fetchRequest)
                
                for item in fetchResult {
                    
                    item.type = "Letter"
                    item.isRecording = true
                    item.recordingStatus = "N/A"
                    
                    if textView.text == "Tap in the box to start typing or click on transcribe button below to convert your recorded voice file to text." {
                        item.isTranscribed = false
                    } else {
                        item.isTranscribed = true
                    }
                    
                    
                    try context.save()
                    textView.resignFirstResponder()
                    save.isEnabled = false
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
                    self.present(nextViewController, animated:true, completion:nil)
                    
                }
            }catch {
                print(error.localizedDescription)
            }
       
        } else {
            ///insert into sounds
            let urlString: String = audioFileURL.absoluteString
            let patientid = defaults.value(forKey: "PatientID") as! String
            
            let context = getContext()
            
            let sounds = NSEntityDescription.entity(forEntityName: "Sounds", in: context)
            
            let managedObj = NSManagedObject(entity: sounds!, insertInto: context)
            
            managedObj.setValue(patientid, forKey: "patientID")
            managedObj.setValue(recording, forKey: "recordingName")
            managedObj.setValue(urlString, forKey: "recordingURL")
            managedObj.setValue(textView.text, forKey: "transcription")
            managedObj.setValue("Letter", forKey: "type")
            
            do {
                try context.save()
                print("saved!")
                
            } catch {
                print(error.localizedDescription)
            }
            
            
            ///update into patients
            let fetchRequest:NSFetchRequest<Patients> = Patients.fetchRequest()
            
            let predicate = NSPredicate(format: "(patientID = %@)", patientid)
            fetchRequest.predicate = predicate
            
            do {
                let fetchResult = try context.fetch(fetchRequest)
                
                for item in fetchResult {
                    
                    item.type = "Letter"
                    item.isRecording = true
                    item.recordingStatus = "true"
                    
                    if textView.text == "Tap in the box to start typing or click on transcribe button below to convert your recorded voice file to text." {
                        item.isTranscribed = false
                    } else {
                        item.isTranscribed = true
                    }
                    
                    
                    try context.save()
                    textView.resignFirstResponder()
                    save.isEnabled = false
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
                    self.present(nextViewController, animated:true, completion:nil)
                    
                }
            }catch {
                print(error.localizedDescription)
            }
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        if textView.text == ""{
            textView.text = "Tap in the box to start typing or click on transcribe button below to convert your recorded voice file to text."
        }
        
        if textView.text != "Tap in the box to start typing or click on transcribe button below to convert your recorded voice file to text."{
            save.isHidden = false
            saveExitLabel.isHidden = false
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Tap in the box to start typing or click on transcribe button below to convert your recorded voice file to text." {
            textView.text = nil
        }
    }
    
    @IBAction func navigateToHome(_ sender: UIBarButtonItem) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func changeAudioTime(_ sender: UISlider) {
        
        let test = Int(sender.value)
        
        let seconds = test % 60
        let minutes = (test / 60) % 60
        
        
        player.stop()
        player.currentTime = TimeInterval(sender.value)
        player.prepareToPlay()
        player.play()
        statusLabel.text = String(format: "%02d:%02d", minutes, seconds)
        
    }
    
    func updateSlider(){
        
        progressView.value = Float(player.currentTime)
        let changedValue = Int(progressView.value)
        let seconds = changedValue % 60
        let minutes = (changedValue / 60) % 60
        statusLabel.text = String(format: "%02d:%02d", minutes, seconds)
        
    }
    
}
