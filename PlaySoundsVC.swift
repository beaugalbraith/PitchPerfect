//
//  PlaySoundsVC.swift
//  Pitch Perfect
//
//  Created by gamma on 1/13/17.
//  Copyright © 2017 Beau Galbraith. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsVC: UIViewController {
    private enum ButtonType: Int {
        case slow = 0
        case fast = 1
        case chipmunk = 2
        case vader = 3
        case echo = 4
        case reverb = 5
    }
    
    // MARK: UIButton Outlets
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    @IBAction private func playSound(_ sender: UIButton) {
        
        NSLog("button pressed")
        NSLog("\(sender)")
        NSLog("sender.tag: \(sender.tag)")
        
        // setupAudio in our pseudo-model implementation
        setupAudio()
        
        switch(ButtonType(rawValue: sender.tag)!) {
        case .slow:
            playSound(rate: 0.5)
        case .fast:
            playSound(rate: 1.5)
        case .chipmunk:
            playSound(pitch: 1000)
        case .vader:
            playSound(pitch: -1000)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        }
        
        configureUI(.playing)
    }
    
    @IBAction private func stopSound(_ sender: UIButton) {
        NSLog("stopping audio playback")
        stopAudio()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopButton.isEnabled = false
    }
    
    // MARK: Toggle Button States
    func configureUI(_ playState: PlayingState) {
        switch(playState) {
        case .playing:
            setPlayButtonsEnabled(false)
            stopButton.isEnabled = true
        case .notPlaying:
            setPlayButtonsEnabled(true)
            stopButton.isEnabled = false
        }
    }
    
    func setPlayButtonsEnabled(_ enabled: Bool) {
        snailButton.isEnabled = enabled
        chipmunkButton.isEnabled = enabled
        rabbitButton.isEnabled = enabled
        vaderButton.isEnabled = enabled
        echoButton.isEnabled = enabled
        reverbButton.isEnabled = enabled
    }

    func showAlertEnum(_ alertEnum: AlertEnum, message: String) {
        let alert = UIAlertController(title: alertEnum.rawValue, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: AlertEnum.dismissAlert.rawValue, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    var recordedAudioURL:URL!
    var audioFile:AVAudioFile!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!

}
