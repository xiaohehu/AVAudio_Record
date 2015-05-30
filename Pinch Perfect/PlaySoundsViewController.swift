//
//  PlaySoundsViewController.swift
//  Pinch Perfect
//
//  Created by Xiaohe Hu on 5/20/15.
//  Copyright (c) 2015 Xiaohe Hu. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    var audioPlayer : AVAudioPlayer!
    var audioPlayer2: AVAudioPlayer!
    var receivedAudio : RecordAudio!
    var audioEngine : AVAudioEngine!
    var audioFile : AVAudioFile!
    var reverbPlayers : [AVAudioPlayer] = []
    let playerNum : Int = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        if var filePath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3") {
//            var fileUrl = NSURL.fileURLWithPath(filePath)
//            
//        }
//        else {
//            println("Error with the file")
//        }
        // Do any additional setup after loading the view.
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer2 = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
        
        /**
        create reverb audio player array
        */
        for i in 0...playerNum {
            var tmpPlayer : AVAudioPlayer!
            tmpPlayer = AVAudioPlayer (contentsOfURL: receivedAudio.filePathUrl, error: nil)
            reverbPlayers.append(tmpPlayer)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func playSlowAudio(sender: AnyObject) {
        playTheAudio(0.5)
    }
    @IBAction func playFastAudio(sender: AnyObject) {
        playTheAudio(1.5)
    }
    func playTheAudio(speed : Float) {
        audioPlayer.stop()
        audioPlayer.rate = speed
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    @IBAction func playChipmunkAudio(sender: AnyObject) {
            playAudioWithVariblePitch(1000)
    }
    @IBAction func playDarthvaderAudio(sender: AnyObject) {
            playAudioWithVariblePitch(-1000)
    }
    func playAudioWithVariblePitch(pitch: Float)
    {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        audioPlayerNode.play()
    }
    
    @IBAction func playAudioWithEcho(sender: AnyObject) {
        audioPlayer.stop()
        audioPlayer2.stop()

        audioPlayer.currentTime = 0
        audioPlayer.play()
        
        let echoDelay : NSTimeInterval = 0.25
        var playTime : NSTimeInterval!
        playTime = audioPlayer2.deviceCurrentTime + echoDelay
        audioPlayer2.currentTime = 0
        audioPlayer2.volume = 0.7
        audioPlayer2.playAtTime(playTime)
    }
    
    @IBAction func playAudioWithReverb(sender: AnyObject) {
        audioPlayer.stop()
        audioPlayer2.stop()
        
        let reverbDelay : NSTimeInterval = 0.02
        for i in 0...playerNum {
            var curDelay = reverbDelay * NSTimeInterval(i)
            var tmpAudioPlayer : AVAudioPlayer = reverbPlayers[i]
            //M_E is e=2.718...
            //dividing N by 2 made it sound ok for the case N=10
            var exponent:Double = -Double(i)/Double(playerNum/2)
            var volume = Float(pow(Double(M_E), exponent))
            tmpAudioPlayer.volume = volume
            tmpAudioPlayer.playAtTime(tmpAudioPlayer.deviceCurrentTime + curDelay)
        }
    }
    
    @IBAction func stopAudio(sender: AnyObject) {
        audioPlayer.stop()
        audioPlayer2.stop()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
