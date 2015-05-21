//
//  ViewController.swift
//  Pinch Perfect
//
//  Created by Xiaohe Hu on 5/18/15.
//  Copyright (c) 2015 Xiaohe Hu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingInProgress: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        //Hide the stop button
        stopButton.hidden = true
        recordButton.enabled = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        recordingInProgress.hidden = false
        stopButton.hidden = false
        recordButton.enabled = false
        //TODO: Record the user's voice
        println("in recordAudio")
    }

    @IBAction func tapOnStopBtn(sender: AnyObject) {
        recordingInProgress.hidden = true
    }
}

