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

class ViewController: UIViewController {
    var lastLocation = CGPoint(x: 0, y: 0)
    @IBOutlet weak var timeView: TimeView!
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var btnStartOrStop: RoundButton!
    @IBOutlet weak var message: UILabel!
    
    var disposeBag: DisposeBag = DisposeBag()
    
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
                    self.btnStartOrStop.setTitle("RESET", for: .normal)
                    self.btnStartOrStop.backgroundColor = UIColor(named: "tomato")
                    self.btnStartOrStop.setTitleColor(UIColor.white, for: .normal)
                }
                else if (status == .STOP) {
                    self.btnStartOrStop.setTitle("START", for: .normal)
                    self.btnStartOrStop.backgroundColor = UIColor(named: "babyBlue")
                    self.btnStartOrStop.setTitleColor(UIColor.black, for: .normal)
                }
        }).disposed(by: disposeBag)
        
        timeView.counterArc.share().subscribe(onNext: { [unowned self] value in
            self.message.text = "\(value)"
            }).disposed(by: disposeBag)
    }

    @IBAction func openSetting(_ sender: Any) {

    }
    
    @objc func panGestureAction(sender: UIPanGestureRecognizer) {
        //let translation = sender.translation(in: timeView)
        let point = sender.location(in: timeView)
        //timeView.center = CGPoint(x: timeView.center.x + translation.x, y: timeView.center.y + translation.y)
        //sender.setTranslation(CGPoint.zero, in: timeView)
        timeView.endPoint = point
        //print(point)
        //print(translation)
    }
    
    @IBAction func startOrReset(_ sender: Any) {
        if (timeView.timerStatus.value == .STOP) {
            timeView.start()
        }
        else if (timeView.timerStatus.value == .START) {
            timeView.reset()
        }
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

