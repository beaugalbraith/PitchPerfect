//
//  RecordSoundsVC.swift
//  Pitch Perfect
//
//  Created by gamma on 1/12/17.
//  Copyright © 2017 Beau Galbraith. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsVC: UIViewController, AVAudioRecorderDelegate {
    
    private var audioRecorder: AVAudioRecorder!
    
    // MARK: UI Components
    @IBOutlet private weak var recordButton: UIButton!
    @IBOutlet private weak var stopRecordingButton: UIButton!
    @IBOutlet private weak var recordingLabel: UILabel!
    
    @IBAction private func recordingPushed(_ sender: UIButton) {
        stopRecordingButton.isEnabled = true
        recordingLabel.text = "Recording in Progress"
        recordButton.isEnabled = false
        
        // order of preferred paths to save recorded file
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let name = "recordedVoice.wav"
        let pathArray = [dirPath, name]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        NSLog((filePath?.absoluteString)!)
        
        let session = AVAudioSession.sharedInstance()
        // if we fail to set category then app will crash
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
        // if we fail to assign audioRecorder then app will crash
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        
        // so we can implement AVAudioRecorderDelegate protocol
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction private func stopRecordingPushed(_ sender: UIButton) {
        NSLog("stop recording pushed")
        
        recordingLabel.text = "Tap to Record"
        stopRecordingButton.isEnabled = false
        recordButton.isEnabled = true
        audioRecorder.stop()
        
        let audioSession = AVAudioSession.sharedInstance()
        // if we can't make audioSession active then we will crash, as opposed to silently failing
        try! audioSession.setActive(false)
    }
    
    // MARK: Delegation Functions
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            NSLog("audioRecorderDidFinish: \(audioRecorder.url)")
            
            // if successful move to next scene and send recorded file via sender variable
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
            
            NSLog("finished recording")
        } else {
            NSLog("finish recording failed")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "stopRecording" {
            
            // must cast to our custom PlaySoundsVC class
            let playSoundsVC = segue.destination as! PlaySoundsVC
            
            let recordedAudioURL = audioRecorder.url
            NSLog("prepareForSegue: \(audioRecorder.url)")
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
    override func viewDidLoad() {
        NSLog("view did load")
        // start with the stop button disabled
        stopRecordingButton.isEnabled = false
        super.viewDidLoad()
    }
    
    
}

