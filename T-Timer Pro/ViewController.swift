//
//  ViewController.swift
//  T-Timer Pro
//
//  Created by DellMac on 2019-11-23.
//  Copyright © 2019 CCS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import AVFoundation
import MediaPlayer

class ViewController: UIViewController {
    var lastLocation = CGPoint(x: 0, y: 0)
    @IBOutlet weak var timeView: TimeView!
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var btnStartOrStop: RoundButton!
    @IBOutlet weak var message: UILabel!
    
    var disposeBag: DisposeBag = DisposeBag()
    var audioPlayer = AVAudioPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(sender:)))
        pan.maximumNumberOfTouches = 1
        pan.minimumNumberOfTouches = 1
        timeView.addGestureRecognizer(pan)
        
        timeView.timerStatus
            .subscribe (onNext: { [unowned self] status in
                if (status == .START) {
                    self.btnStartOrStop.setTitle("STOP", for: .normal)
                    self.btnStartOrStop.backgroundColor = UIColor(named: "tomato")
                    self.btnStartOrStop.setTitleColor(UIColor.white, for: .normal)
                }
                else if (status == .STOP) {
                    self.btnStartOrStop.setTitle("START", for: .normal)
                    self.btnStartOrStop.backgroundColor = UIColor(named: "babyBlue")
                    self.btnStartOrStop.setTitleColor(UIColor.black, for: .normal)
                }
        }).disposed(by: disposeBag)
        
        timeView.secondCounter.share()
            .subscribe(onNext: { [unowned self] value in
                self.btnStartOrStop.isEnabled = (value > 0.0)
                self.message.text = "\(Int(value / 60)) m : \(Int(value) % 60) s"
            }).disposed(by: disposeBag)
        
        timeView.timerEvent.share()
            .subscribe(onNext: {[unowned self] event in
                if (event == .LASTONEMINUTE) {
                    self.LastOneMinute()
                }
                else if (event == .TIMEUP) {
                    self.TimeUp()
                }
            }).disposed(by: disposeBag)
        
        let sound = Bundle.main.path(forResource: "Alla_Turca", ofType: ".mp3")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
        }
        catch {
            print(error)
        }
    }

    @IBAction func openSetting(_ sender: Any) {

    }
    
    @objc func panGestureAction(sender: UIPanGestureRecognizer) {
        if (timeView.timerStatus.value == .START) {
            return
        }
        let point = sender.location(in: timeView)
        timeView.endPoint = point
    }
    
    @IBAction func startOrReset(_ sender: Any) {
        if (timeView.timerStatus.value == .STOP) {
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord, options: [.duckOthers, .defaultToSpeaker])
                try AVAudioSession.sharedInstance().setActive(true)
                UIApplication.shared.beginReceivingRemoteControlEvents()
            } catch {
                 NSLog("Audio Session error: \(error)")
            }
            timeView.start()
        }
        else if (timeView.timerStatus.value == .START) {
            timeView.stopTimer()
        }
    }
    
    func LastOneMinute() {
        let utterance = AVSpeechUtterance(string: "one minute left")
        //utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        //utterance.rate = 0.1

        let synthesizer = AVSpeechSynthesizer()
        synthesizer.speak(utterance)
    }
    
    func TimeUp() {
        let volumeView = MPVolumeView()
        volumeView.volumeSlider.value = 1.0
        audioPlayer.play()
    }
    
    
    
//    @IBAction func panAction(_ sender: Any) {
////        guard let src = sender as? UIPanGestureRecognizer else {
////            return
////        }
////
////        if src.state == .began{
////            lastLocation = timeView.center
////        }else if src.state == .changed{
////            let translation = src.translation(in: timeView)
////            timeView.center = CGPoint(x: lastLocation.x + translation.x
////            , y: lastLocation.y + translation.y)
////        }
//    }
    
    
}

private extension MPVolumeView {
    var volumeSlider: UISlider {
        self.showsRouteButton = false
        self.showsVolumeSlider = false
        self.isHidden = true
        var slider = UISlider()
        for subview in self.subviews {
            if subview.isKind(of: UISlider.self){
                slider = subview as! UISlider
                slider.isContinuous = false
                (subview as! UISlider).value = 1
                return slider
            }
        }
        return slider
    }
}
