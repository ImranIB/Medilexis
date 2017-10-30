//
//  HPIDictationVC.swift
//  Medilexis
//
//  Created by iOS Developer on 23/02/2017.
//  Copyright © 2017 NX3. All rights reserved.
//

import UIKit
import AVFoundation
import Speech
import SystemConfiguration
import CoreData

class HPIDictation: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate , UITextViewDelegate  {
    
    
    @IBOutlet weak var recordPause: UIButton!
    @IBOutlet weak var stop: UIButton!
    @IBOutlet weak var play: UIButton!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var transcribeText: UITextView!
    @IBOutlet weak var transcribe: UIButton!
    @IBOutlet weak var transcribeLabel: UILabel!
    @IBOutlet weak var saveExit: UIButton!
    @IBOutlet weak var saveExitLabel: UILabel!
    @IBOutlet weak var saveNext: UIButton!
    @IBOutlet weak var saveNextLabel: UILabel!
    @IBOutlet var skipButton: UIButton!
    @IBOutlet var skipLabel: UILabel!
    @IBOutlet weak var hpiActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var progressView: UISlider!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var saveLabel: UILabel!
    @IBOutlet weak var transcribeLine: UIView!
    @IBOutlet weak var saveLine: UIView!
    @IBOutlet weak var nextLine: UIView!
    @IBOutlet weak var slipLine: UIView!
    @IBOutlet weak var exitLine: UIView!
    
    
    let defaults = UserDefaults.standard
    var recorder: AVAudioRecorder!
    var player:AVAudioPlayer!
    var audioFileURL: URL!
    var soundFileName: String!
    var meterTimer:Timer!
    var timer: Timer?
    var audioTimer: Timer?
    var recording: String!
    var elapsedTimeInSecond: Int = 0
    var fileHPIStored = ""
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stop.isEnabled = false
        play.isEnabled = false
        transcribe.isHidden = true
        saveExit.isHidden = true
        saveNext.isHidden = true
        transcribeLabel.isHidden = true
        saveExitLabel.isHidden = true
        saveNextLabel.isHidden = true
        saveButton.isHidden = true
        saveLabel.isHidden = true
        transcribeLine.isHidden = true
        saveLine.isHidden = true
        nextLine.isHidden = true
        exitLine.isHidden = true
        hpiActivityIndicator.isHidden = true
        transcribeText.layer.cornerRadius = 10
        progressView.isEnabled = false
        setSessionPlayback()
        
        transcribeText.delegate = self
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.doneClicked))
        toolBar.setItems([flexibleSpace, doneButton], animated: false)
        transcribeText.inputAccessoryView = toolBar
        
        defaults.set("false", forKey: "HPIRecording")
    }
    
    func doneClicked(){
        
        self.view.endEditing(true)
        
        if transcribeText.text == ""{
            transcribeText.text = "Tap to start typing or press the record button to start recording (Recorded file can be converted into text via transcribe button to appear below)"
        }
        
        if transcribeText.text != "Tap to start typing or press the record button to start recording (Recorded file can be converted into text via transcribe button to appear below)"{
            
            saveExit.isHidden = false
            saveExitLabel.isHidden = false
            exitLine.isHidden = true
            saveNext.isHidden = false
            saveNextLabel.isHidden = false
            nextLine.isHidden = true
            saveButton.isHidden = false
            saveLabel.isHidden = false
            saveLine.isHidden = false
            skipButton.isHidden = true
            skipLabel.isHidden = true
            slipLine.isHidden = true
            transcribeLine.isHidden = true
            
            fileHPIStored = "false"
        }
        
    }
    
    func getContext () -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateAudioMeter(_ timer:Timer) {
        
        if recorder.isRecording {
            let min = Int(recorder.currentTime / 60)
            let sec = Int(recorder.currentTime.truncatingRemainder(dividingBy: 60))
            let s = String(format: "%02d:%02d", min, sec)
            statusLabel.text = s
            recorder.updateMeters()
            
        }
        
    }
    
    @IBAction func recordPauseBtn(_ sender: UIButton) {
        
        let status = defaults.value(forKey: "HPIRecording") as! String
        
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
                defaults.set("false", forKey: "HPIRecording")
                audioTimer =  Timer.scheduledTimer(timeInterval: 180.0, target: self, selector: #selector(stopRecording), userInfo: nil, repeats: false)
                
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
        
        defaults.set("false", forKey: "HPIRecording")
        
        if player != nil && player.isPlaying {
            player.stop()
        }
        
        if recorder == nil {
            recordPause.setImage(UIImage(named: "pause-btn"), for: UIControlState.normal)
            transcribe.isHidden = true
            saveExit.isHidden = true
            saveNext.isHidden = true
            transcribeLabel.isHidden = true
            saveExitLabel.isHidden = true
            saveNextLabel.isHidden = true
            saveButton.isHidden = true
            saveLabel.isHidden = true
            transcribeLine.isHidden = true
            saveLine.isHidden = true
            nextLine.isHidden = true
            exitLine.isHidden = true
            skipButton.isHidden = false
            skipLabel.isHidden = false
            slipLine.isHidden = false
            play.isEnabled = false
            stop.isEnabled = true
            progressView.isEnabled = false
            recordWithPermission(true)
            startTimer()
            audioTimer =  Timer.scheduledTimer(timeInterval: 180.0, target: self, selector: #selector(stopRecording), userInfo: nil, repeats: false)
            
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
    
    func stopRecording(){
        
        recorder?.stop()
        player?.stop()
        resetTimer()
        
        recordPause.setImage(UIImage(named: "rec-btn"), for: UIControlState.normal)
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(false)
            stop.isEnabled = false
            play.isEnabled = true
            transcribe.isHidden = false
            transcribeLabel.isHidden = false
            recordPause.isEnabled = true
            saveExit.isHidden = false
            saveExitLabel.isHidden = false
            saveNext.isHidden = false
            saveNextLabel.isHidden = false
            saveButton.isHidden = false
            saveLabel.isHidden = false
            skipButton.isHidden = true
            skipLabel.isHidden = true
            slipLine.isHidden  = true
            transcribeLine.isHidden = false
            nextLine.isHidden = true
            saveLine.isHidden = true
            exitLine.isHidden = true
            progressView.isEnabled = true
            progressView.isEnabled = true
            progressView.value = 0
            fileHPIStored = "false"
            defaults.set("true", forKey: "HPIRecording")
            
        } catch let error as NSError {
            print("could not make session inactive")
            print(error.localizedDescription)
        }
    }
    
    @IBAction func stop(_ sender: UIButton) {
        
        recorder?.stop()
        player?.stop()
        resetTimer()
        
        recordPause.setImage(UIImage(named: "rec-btn"), for: UIControlState.normal)
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setActive(false)
            stop.isEnabled = false
            play.isEnabled = true
            transcribe.isHidden = false
            transcribeLabel.isHidden = false
            recordPause.isEnabled = true
            saveNext.isHidden = false
            saveExit.isHidden = false
            saveNextLabel.isHidden = false
            saveExitLabel.isHidden = false
            saveButton.isHidden = false
            saveLabel.isHidden = false
            skipButton.isHidden = true
            skipLabel.isHidden = true
            slipLine.isHidden  = true
            transcribeLine.isHidden = false
            nextLine.isHidden = true
            exitLine.isHidden = true
            saveLine.isHidden = true
            progressView.isEnabled = true
            progressView.value = 0
            fileHPIStored = "false"
            defaults.set("true", forKey: "HPIRecording")
            
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
        //print("playing \(url)")
        
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
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            self.recorder = nil
        }
    }
    
    // MARK: - AVAudioPlayerDelegate Methods
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        play.setImage(UIImage(named: "play-icon"), for: UIControlState.normal)
        play.isSelected = false
        stop.isEnabled = false
        resetTimer()
        progressView.value = 0
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
    
    @IBAction func transcribe(_ sender: UIButton) {
        
        if currentReachabilityStatus == .reachableViaWiFi ||  currentReachabilityStatus == .reachableViaWWAN {
            
            hpiActivityIndicator.isHidden = false
            hpiActivityIndicator.startAnimating()
            
            SFSpeechRecognizer.requestAuthorization { authStatus in
                if authStatus == SFSpeechRecognizerAuthorizationStatus.authorized {
                    
                    let recognizer = SFSpeechRecognizer()
                    let request = SFSpeechURLRecognitionRequest(url: self.audioFileURL)
                    recognizer?.recognitionTask(with: request) { (result, error) in
                        
                        if let error = error {
                            
                            print(error)
                            
                            DispatchQueue.main.async {
                                
                                let alert = UIAlertController(title: "Voice not recognized", message: "Unable to recognize voice", preferredStyle: UIAlertControllerStyle.alert)
                                let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                                alert.addAction(action)
                                
                                self.present(alert, animated: true, completion: nil);
                                
                                self.hpiActivityIndicator.stopAnimating()
                                self.hpiActivityIndicator.isHidden = true
                                self.saveLine.isHidden = false
                                self.transcribeLine.isHidden = true
                                self.nextLine.isHidden = true
                                self.exitLine.isHidden = true
                                self.slipLine.isHidden = true
                            }
                            
                            
                        } else {
                            
                            self.transcribeText.text = ""
                            self.transcribeText.text = result?.bestTranscription.formattedString
                            self.hpiActivityIndicator.stopAnimating()
                            self.hpiActivityIndicator.isHidden = true
                            self.saveLine.isHidden = false
                            self.transcribeLine.isHidden = true
                            self.nextLine.isHidden = true
                            self.exitLine.isHidden = true
                            self.slipLine.isHidden = true
                            
                        }
                    }
                    
                } else {
                    
                    DispatchQueue.main.async {
                        
                        let alert = UIAlertController(title: "No permission", message: "Allow permission to convert recorded audio file into text. Kindly enable permission from device settings app.", preferredStyle: UIAlertControllerStyle.alert)
                        let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil)
                        alert.addAction(action)
                        
                        self.present(alert, animated: true, completion: nil);
                        
                        self.hpiActivityIndicator.stopAnimating()
                        self.hpiActivityIndicator.isHidden = true
                        
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
    
    @IBAction func HPINext(_ sender: UIButton) {
        
        if fileHPIStored == "false" {
            
            let alert = UIAlertController(title: "Hold On", message: "Changes have not been saved. Do you want to leave without saving?", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: yes)
            let cancel = UIAlertAction(title: "No", style: UIAlertActionStyle.default, handler: nil)
            alert.addAction(action)
            alert.addAction(cancel)
            
            
            self.present(alert, animated: true, completion: nil);
            
        } else {
            
            self.tabBarController?.selectedIndex = 2
            
        }
    }
    
    func yes(alert: UIAlertAction){
        
        transcribe.isHidden = true
        saveExit.isHidden = true
        saveNext.isHidden = true
        transcribeLabel.isHidden = true
        saveExitLabel.isHidden = true
        saveNextLabel.isHidden = true
        saveButton.isHidden = true
        saveLabel.isHidden = true
        transcribeLine.isHidden = true
        saveLine.isHidden = true
        nextLine.isHidden = true
        exitLine.isHidden = true
        skipButton.isHidden = false
        skipLabel.isHidden = false
        slipLine.isHidden = false
        
        self.tabBarController?.selectedIndex = 2
        
    }
    
    func yesExit(alert: UIAlertAction){
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
        self.present(nextViewController, animated:true, completion:nil)
        
    }
    
    
    @IBAction func HPIBackBtn(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showHomeView(_ sender: UIBarButtonItem) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "Menu") as! SWRevealViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func saveExitBtn(_ sender: UIButton) {
        
       if fileHPIStored == "false"  {
            
            let alert = UIAlertController(title: "Hold On", message: "Changes have not been saved. Do you want to leave without saving?", preferredStyle: UIAlertControllerStyle.alert)
            let action = UIAlertAction(title: "Yes", style: UIAlertActionStyle.default, handler: yesExit)
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
    
    override func viewWillDisappear(_ animated: Bool) {
        recorder?.stop()
        player?.stop()
        
        resetTimer()
        
        recordPause.setImage(UIImage(named: "rec-btn"), for: UIControlState.normal)
        stop.isEnabled = false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if transcribeText.text == "Tap to start typing or press the record button to start recording (Recorded file can be converted into text via transcribe button to appear below)" {
            transcribeText.text = nil
        }
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
    
    @IBAction func savePressed(_ sender: UIButton) {
        
        let type = "HPI"
        let AppointmentID = defaults.value(forKey: "AppointmentID") as! String
        let fetchRequest:NSFetchRequest<Sounds> = Sounds.fetchRequest()
        let predicate = NSPredicate(format: "(appointmentID = %@) AND (type = %@)", AppointmentID, type)
        fetchRequest.predicate = predicate
        
        do {
            let count = try getContext().count(for: fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            if count > 0 {
                
                print("record exists")
                let fetchResult = try context.fetch(fetchRequest)
                
                for item in fetchResult {
                    
                    if audioFileURL == nil {
                        ///update into sounds
                        
                        item.recordingName = "N/A"
                        item.recordingURL = "N/A"
                        item.transcription = transcribeText.text
                        item.type = "HPI"
                        
                        ///update into patients
                        let fetchRequest:NSFetchRequest<Appointments> = Appointments.fetchRequest()
                        
                        let predicate = NSPredicate(format: "(appointmentID = %@)", AppointmentID)
                        fetchRequest.predicate = predicate
                        
                        do {
                            let fetchResult = try context.fetch(fetchRequest)
                            
                            for item in fetchResult {
                                
                                item.type = "Chart"
                                item.isRecording = true
                                item.recordingStatus = "N/A"
                                
                                if transcribeText.text == "Tap to start typing or press the record button to start recording (Recorded file can be converted into text via transcribe button to appear below)" {
                                    item.isTranscribed = false
                                } else {
                                    item.isTranscribed = true
                                }
                                
                                
                                try context.save()
                                transcribeText.resignFirstResponder()
                                
                                saveLine.isHidden = true
                                transcribeLine.isHidden = true
                                slipLine.isHidden = true
                                exitLine.isHidden = true
                                nextLine.isHidden = false
                                
                                fileHPIStored = "true"
                            }
                        }catch {
                            print(error.localizedDescription)
                        }
                        
                    } else {
                        
                        ///update into sounds
                        let urlString: String = audioFileURL.absoluteString
                        item.recordingName = recording
                        item.recordingURL = urlString
                        item.transcription = transcribeText.text
                        item.type = "HPI"
                        
                        ///update into patients
                        let fetchRequest:NSFetchRequest<Appointments> = Appointments.fetchRequest()
                        
                        let predicate = NSPredicate(format: "(appointmentID = %@)", AppointmentID)
                        fetchRequest.predicate = predicate
                        
                        do {
                            let fetchResult = try context.fetch(fetchRequest)
                            
                            for item in fetchResult {
                                
                                item.type = "Chart"
                                item.isRecording = true
                                item.recordingStatus = "true"
                                
                                if transcribeText.text == "Tap to start typing or press the record button to start recording (Recorded file can be converted into text via transcribe button to appear below)" {
                                    item.isTranscribed = false
                                } else {
                                    item.isTranscribed = true
                                }
                                
                                
                                try context.save()
                                transcribeText.resignFirstResponder()
                                
                                saveLine.isHidden = true
                                transcribeLine.isHidden = true
                                slipLine.isHidden = true
                                exitLine.isHidden = true
                                nextLine.isHidden = false
                                
                                fileHPIStored = "true"
                                
                            }
                        }catch {
                            print(error.localizedDescription)
                        }
                    }
                }
                
            } else {
                
                if audioFileURL == nil {
                    ///insert into sounds
                    
                    let AppointmentID = defaults.value(forKey: "AppointmentID") as! String
                    
                    let context = getContext()
                    
                    let sounds = NSEntityDescription.entity(forEntityName: "Sounds", in: context)
                    
                    let managedObj = NSManagedObject(entity: sounds!, insertInto: context)
                    
                    managedObj.setValue(AppointmentID, forKey: "appointmentID")
                    managedObj.setValue("N/A", forKey: "recordingName")
                    managedObj.setValue("N/A", forKey: "recordingURL")
                    managedObj.setValue(transcribeText.text, forKey: "transcription")
                    managedObj.setValue("HPI", forKey: "type")
                    
                    do {
                        try context.save()
                        //print("saved!")
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                    
                    ///update into patients
                    let fetchRequest:NSFetchRequest<Appointments> = Appointments.fetchRequest()
                    
                    let predicate = NSPredicate(format: "(appointmentID = %@)", AppointmentID)
                    fetchRequest.predicate = predicate
                    
                    do {
                        let fetchResult = try context.fetch(fetchRequest)
                        
                        for item in fetchResult {
                            
                            item.type = "Chart"
                            item.isRecording = true
                            item.recordingStatus = "N/A"
                            
                            if transcribeText.text == "Tap to start typing or press the record button to start recording (Recorded file can be converted into text via transcribe button to appear below)" {
                                item.isTranscribed = false
                            } else {
                                item.isTranscribed = true
                            }
                            
                            
                            try context.save()
                            transcribeText.resignFirstResponder()
                            
                            saveLine.isHidden = true
                            transcribeLine.isHidden = true
                            slipLine.isHidden = true
                            exitLine.isHidden = true
                            nextLine.isHidden = false
                            
                            fileHPIStored = "true"
                            
                        }
                    }catch {
                        print(error.localizedDescription)
                    }
                    
                } else {
                    
                    ///insert into sounds
                    let urlString: String = audioFileURL.absoluteString
                    let AppointmentID = defaults.value(forKey: "AppointmentID") as! String
                    let context = getContext()
                    
                    let sounds = NSEntityDescription.entity(forEntityName: "Sounds", in: context)
                    
                    let managedObj = NSManagedObject(entity: sounds!, insertInto: context)
                    
                    managedObj.setValue(AppointmentID, forKey: "appointmentID")
                    managedObj.setValue(recording, forKey: "recordingName")
                    managedObj.setValue(urlString, forKey: "recordingURL")
                    managedObj.setValue(transcribeText.text, forKey: "transcription")
                    managedObj.setValue("HPI", forKey: "type")
                    
                    do {
                        try context.save()
                        //print("saved!")
                        
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                    
                    ///update into patients
                    let fetchRequest:NSFetchRequest<Appointments> = Appointments.fetchRequest()
                    
                    let predicate = NSPredicate(format: "(appointmentID = %@)", AppointmentID)
                    fetchRequest.predicate = predicate
                    
                    do {
                        let fetchResult = try context.fetch(fetchRequest)
                        
                        for item in fetchResult {
                            
                            item.type = "Chart"
                            item.isRecording = true
                            item.recordingStatus = "true"
                            
                            if transcribeText.text == "Tap to start typing or press the record button to start recording (Recorded file can be converted into text via transcribe button to appear below)" {
                                item.isTranscribed = false
                            } else {
                                item.isTranscribed = true
                            }
                            
                            
                            try context.save()
                            transcribeText.resignFirstResponder()
                            
                            saveLine.isHidden = true
                            transcribeLine.isHidden = true
                            slipLine.isHidden = true
                            exitLine.isHidden = true
                            nextLine.isHidden = false
                            
                            fileHPIStored = "true"
                            
                        }
                    }catch {
                        print(error.localizedDescription)
                    }
                }
            }
        }catch {
            print(error.localizedDescription)
        }
    }
    
    
    @IBAction func skipPressed(_ sender: UIButton) {
        
        self.tabBarController?.selectedIndex = 2
    }
    
    
}
