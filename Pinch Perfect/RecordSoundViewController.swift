//
//  ViewController.swift
//  Pinch Perfect
//
//  Created by Xiaohe Hu on 5/18/15.
//  Copyright (c) 2015 Xiaohe Hu. All rights reserved.
//

import UIKit
import AVFoundation
class RecordSoundViewController: UIViewController, AVAudioRecorderDelegate {
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio : RecordAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        //Hide the stop button
        stopButton.hidden = true
        recordButton.enabled = true
        resumeButton.hidden = true
        pauseButton.hidden = true
        resumeButton.enabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        recordingInProgress.hidden = false
        stopButton.hidden = false
        recordButton.enabled = false
        resumeButton.hidden = false
        pauseButton.hidden = false
        //TODO: Record the user's voice
        println("in recordAudio")
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+"wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        audioRecorder.delegate = self
    }

    @IBAction func tapOnStopBtn(sender: AnyObject) {
        recordingInProgress.hidden = true
        audioRecorder.stop()           
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
    
    @IBAction func tapPauseBtn(sender: AnyObject) {
        audioRecorder.pause()
        pauseButton.setImage(UIImage(named: "pause_inactive"), forState: UIControlState.Normal)
        resumeButton.setImage(UIImage(named: "resume_active"), forState: UIControlState.Normal)
        pauseButton.enabled = false
        resumeButton.enabled = true
    }
    
    @IBAction func tapResumeBtn(sender: AnyObject) {
        audioRecorder.record()
        pauseButton.setImage(UIImage(named: "pause_active"), forState: UIControlState.Normal)
        resumeButton.setImage(UIImage(named: "resume_inactive"), forState: UIControlState.Normal)
        resumeButton.enabled = false
        pauseButton.enabled = true
    }
    
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if (flag) {
            // Save the file
            recordedAudio = RecordAudio()
            recordedAudio.filePathUrl = recorder.url
            recordedAudio.title = recorder.url.lastPathComponent
        
            // Perform the segue
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else {
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordAudio
            playSoundsVC.receivedAudio = data
        }
    }
}

