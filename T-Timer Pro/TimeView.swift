//
//  TimeView.swift
//  T-Timer Pro
//
//  Created by DellMac on 2019-11-23.
//  Copyright © 2019 CCS. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import SwiftDate
import Toucan

@IBDesignable
class TimeView: UIView {
    
    static let fullCircle: CGFloat = 2.0 * .pi
    var startArc:CGFloat = -0.25 * fullCircle
    var endArc: CGFloat  = -0.25 * fullCircle

    @IBInspectable var outlineColor: UIColor = UIColor.blue
    @IBInspectable var counterColor: UIColor! = UIColor(named: "apple")
    @IBInspectable var lineColor: UIColor = UIColor.black
    @IBInspectable var digitColot: UIColor = UIColor.black
    
    var hourDuration: Int = 0
    var minuteDuration: Int = 60
    var secondDuration: Int = 0
    
//    var totalMiniutes: CGFloat {
//        get {
//            return CGFloat(hourDuration * 60 + minuteDuration) + CGFloat(secondDuration) / 60.0
//        }
//    }

    var totalMins: CGFloat {
        get {
            return totalSeconds / 60
        }
    }
    var toleranceOfFullByMin: CGFloat {
        get {
            if (totalMins == 5) {
                return 0.25
            }
            else if (totalMins == 120) {
                return 5
            }
            else {
                return totalMins / 12
            }
        }
    }
        
    var totalSeconds: CGFloat {
        get {
            return CGFloat(hourDuration * 3600 + minuteDuration * 60) + CGFloat(secondDuration)
        }
    }
    var toleranceOfFull: CGFloat {
        get {
            return toleranceOfFullByMin * 60
        }
    }
    var centerPoint: CGPoint = CGPoint(x: 0, y: 0)
    var radius: CGFloat = 0
    var digitWidth: CGFloat = 20
    var lineWidth: CGFloat = 10
    var radianPerSec: CGFloat {
        get {
            return (TimeView.fullCircle / totalSeconds)
        }
    }
    func angleToSecond(_ angle: CGFloat) -> CGFloat {
        return angle / radianPerSec
    }
    
    var startPoint: CGPoint = CGPoint(x: 0, y: 0)
    var endPoint: CGPoint  = CGPoint(x: 0, y: 0) {
        didSet {
            let angle = centerPoint.angleBetweenPoints(firstPoint: startPoint, secondPoint: endPoint, clockWise: false)
            //centerPoint.angleBetweenPoints(firstPoint: startPoint, secondPoint: endPoint) * -1 + start
            let secondsConsume = angleToSecond(angle)
            let halfOfFull: CGFloat = totalSeconds / 2.0
            if (secondCounter.value > (totalSeconds - toleranceOfFull) && secondsConsume < halfOfFull) {
                secondCounter.accept(totalSeconds)
            }
            else if (secondCounter.value < toleranceOfFull && secondsConsume >  halfOfFull) {
                secondCounter.accept(0)
            }
            else {
                let adjust = (totalMins == 5) ? pruneForSmallUnit(value: secondsConsume) : prune(value: secondsConsume)
                secondCounter.accept(adjust)
            }
            //setNeedsDisplay()
        }
    }
    
    var disposeBag: DisposeBag = DisposeBag()
    let secondCounter = BehaviorRelay<CGFloat>(value: 0.0)                                                                                                                    //ReplaySubject<CGFloat> = ReplaySubject<CGFloat>.create(bufferSize: 2)
    let timerStatus: BehaviorRelay<TimerStatus> = BehaviorRelay<TimerStatus>(value: .STOP)
    let timerEvent: PublishRelay<TimerEvent> = PublishRelay<TimerEvent>()
    
    let region: Region = Region.current
    var endTime: DateInRegion = Region.current.nowInThisRegion()
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupView(frame)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        secondCounter.subscribe { [ unowned self] (event) in
            guard let newValue = event.element else { return }
            let radian = ((newValue == self.totalSeconds) ? newValue - 0.01 : newValue) * self.radianPerSec
            self.endArc = (radian < 0.5 * .pi) ? radian * -1 - 0.5 * .pi : 1.5 * .pi - radian;
            self.setNeedsDisplay()
        }.disposed(by: disposeBag)
    }

    var ttimer: Disposable?
    func start() {
        endTime = Region.current.nowInThisRegion() + Int(secondCounter.value).seconds
        ttimer = Observable<Int>.interval(RxTimeInterval(1.0), scheduler: MainScheduler.instance)
            .subscribe (onNext: { [unowned self] (event) in
                let newCountArc = (self.endTime - Region.current.nowInThisRegion()) //self.secondCounter.value - 1 //Region.current.nowInThisRegion() - self.endTime
                if (newCountArc <= 0) {
                    self.timerStatus.accept(.STOP)
                    self.secondCounter.accept(0.0)
                    self.timerEvent.accept(.TIMEUP)
                    self.ttimer?.dispose()
                    return
                }
                if (Int(newCountArc) == 60) {
                    self.timerEvent.accept(.LASTONEMINUTE)
                }
                self.secondCounter.accept(CGFloat(newCountArc))
                //print("\(newCountArc)")
                }, onError: { [unowned self]  _ in
                    self.timerStatus.accept(.STOP)
            }, onCompleted: { [unowned self] in
                self.timerStatus.accept(.STOP)
            })
        timerStatus.accept(.START)
    }
    
    
    func pause() {
        
    }
    
    func stopTimer() {
        ttimer?.dispose()
        timerStatus.accept(.STOP)
    }
    
    var backImg: UIImage? = nil
    func setupView(_ rect: CGRect) {
        backImg = UIImage(named: "santa-cartoon")

        centerPoint = CGPoint(x: rect.midX, y: rect.midY)
        radius = min(rect.width, rect.height) / 2.0 - digitWidth - lineWidth
        startPoint = CGPoint(x: rect.width / 2, y: 0)

    }
    override func draw(_ rect: CGRect) {
        if (centerPoint.x == 0) {
            setupView(rect)
        }
        
        drawBackground(rect)
        
        let path = UIBezierPath()
        counterColor.setStroke()
        counterColor.setFill()

        path.move(to: centerPoint)
        path.addArc(withCenter: centerPoint, radius: radius, startAngle: startArc, endAngle: endArc, clockwise: false)
        path.close()
        path.fill()
                    
        path.stroke()
    }
    
    func drawBackground(_ rect: CGRect) {
        if (backImg != nil) {
            let top =  CGPoint.pointOnCircle(center: centerPoint, radius: radius, angle: 1.5 * .pi)
            let left = CGPoint.pointOnCircle(center: centerPoint, radius: radius, angle: .pi)
            Toucan(image: backImg!).maskWithEllipse().image?.draw(in: CGRect(x: left.x, y: top.y, width: radius * 2, height: radius * 2))
        //backImg?.draw(in: CGRect(x: left.x, y: top.y, width: radius * 2, height: radius * 2))
        }
        if (totalMins == 60) {
            backgroundType60(rect)
        }
        else if (totalMins == 120) {
            backgroundType120(rect)
        }
        else if (totalMins == 5) {
            backgroundType5(rect)
        }
    }
    
    // 60 mininutes
    func backgroundType60(_ rect: CGRect) {
        let digitRadius = radius + lineWidth + digitWidth / 2.0
        let lineRadius = radius + lineWidth
        var lineStart: CGPoint = CGPoint(x: 0,y: 0)
        var lineEnd: CGPoint = CGPoint(x: 0,y: 0)
        var charStart: CGPoint = CGPoint(x: 0, y: 0)
        var angle: CGFloat = 0.0
        let unitAngle: CGFloat = TimeView.fullCircle / 60
        
        let path = UIBezierPath()
        lineColor.setStroke()
        var stringToDraw: String = ""
        path.lineWidth = 4
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes: [NSAttributedString.Key: Any] = [.paragraphStyle: paragraphStyle]
        for  i in 0...59 {
            angle = CGFloat(i) * unitAngle
            if (i % 5 == 0) {
                lineStart = CGPoint.pointOnCircle(center: centerPoint, radius: radius + 2, angle: angle)
                lineEnd = CGPoint.pointOnCircle(center: centerPoint, radius: lineRadius, angle: angle)
                path.move(to: lineStart)
                path.addLine(to: lineEnd)
                
                stringToDraw = "\(60 - ((i <= 45) ? (i + 15) : (i - 45)))"
                charStart = CGPoint.pointOnCircle(center: centerPoint, radius: digitRadius, angle: angle)
                let inRect = CGRect(x: charStart.x - 8, y: charStart.y - 8, width: 16, height: 16)
                NSString(string: stringToDraw).draw(in: inRect, withAttributes: attributes)
            }
        }
        path.close()
        path.stroke()
        
        path.lineWidth = 2
        for  i in 0...59 {
            angle = CGFloat(i) * unitAngle
            if (i % 5 != 0) {
                lineStart = CGPoint.pointOnCircle(center: centerPoint, radius: radius + 4, angle: angle)
                lineEnd = CGPoint.pointOnCircle(center: centerPoint, radius: lineRadius - 4, angle: angle)
                path.move(to: lineStart)
                path.addLine(to: lineEnd)
            }
        }
        path.close()
        path.stroke()
    }
    
    // 120 mininutes
    func backgroundType120(_ rect: CGRect) {
        let digitRadius = radius + lineWidth + digitWidth / 2.0
        let lineRadius = radius + lineWidth
        var lineStart: CGPoint = CGPoint(x: 0,y: 0)
        var lineEnd: CGPoint = CGPoint(x: 0,y: 0)
        var charStart: CGPoint = CGPoint(x: 0, y: 0)
        var angle: CGFloat = 0.0
        let unitAngle: CGFloat = TimeView.fullCircle / 120
        
        let path = UIBezierPath()
        lineColor.setStroke()
        var stringToDraw: String = ""
        path.lineWidth = 4
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes: [NSAttributedString.Key: Any] = [.paragraphStyle: paragraphStyle]
        for  i in 0...119 {
            angle = CGFloat(i) * unitAngle
            if (i % 10 == 0) {
                lineStart = CGPoint.pointOnCircle(center: centerPoint, radius: radius + 2, angle: angle)
                lineEnd = CGPoint.pointOnCircle(center: centerPoint, radius: lineRadius, angle: angle)
                path.move(to: lineStart)
                path.addLine(to: lineEnd)
                
                stringToDraw = "\(120 - ((i <= 90) ? (i + 30) : (i - 90)))"
                print(stringToDraw)
                charStart = CGPoint.pointOnCircle(center: centerPoint, radius: digitRadius, angle: angle)
                let inRect = CGRect(x: charStart.x - 12, y: charStart.y - 8, width: 24, height: 16)
                NSString(string: stringToDraw).draw(in: inRect, withAttributes: attributes)
            }
        }
        path.close()
        path.stroke()
        
        path.lineWidth = 2
        for  i in 0...119 {
            angle = CGFloat(i) * unitAngle
            if (i % 10 == 5) {
                lineStart = CGPoint.pointOnCircle(center: centerPoint, radius: radius + 4, angle: angle)
                lineEnd = CGPoint.pointOnCircle(center: centerPoint, radius: lineRadius - 4, angle: angle)
                path.move(to: lineStart)
                path.addLine(to: lineEnd)
            }
        }
        path.close()
        path.stroke()
    }
    
    // 5 mininutes
    func backgroundType5(_ rect: CGRect) {
        let digitRadius = radius + lineWidth + digitWidth / 2.0
        let lineRadius = radius + lineWidth
        var lineStart: CGPoint = CGPoint(x: 0,y: 0)
        var lineEnd: CGPoint = CGPoint(x: 0,y: 0)
        var charStart: CGPoint = CGPoint(x: 0, y: 0)
        var angle: CGFloat = 0.0
        let unitAngle: CGFloat = TimeView.fullCircle / 20
        
        let path = UIBezierPath()
        lineColor.setStroke()
        var stringToDraw: String = ""
        path.lineWidth = 4
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        let attributes: [NSAttributedString.Key: Any] = [.paragraphStyle: paragraphStyle]
        for  i in 0...19 {
            angle = CGFloat(i) * unitAngle
            if ((i + 1) % 4 == 0) {
                lineStart = CGPoint.pointOnCircle(center: centerPoint, radius: radius + 2, angle: angle)
                lineEnd = CGPoint.pointOnCircle(center: centerPoint, radius: lineRadius, angle: angle)
                path.move(to: lineStart)
                path.addLine(to: lineEnd)
                stringToDraw = "\((4 - ((i + 1) / 4) + 5) % 5)"

                charStart = CGPoint.pointOnCircle(center: centerPoint, radius: digitRadius, angle: angle)
                let inRect = CGRect(x: charStart.x - 12, y: charStart.y - 8, width: 24, height: 16)
                NSString(string: stringToDraw).draw(in: inRect, withAttributes: attributes)
            }
        }
        path.close()
        path.stroke()
        
        path.lineWidth = 2
        for  i in 0...19 {
            angle = CGFloat(i) * unitAngle
            if ((i + 1) % 4 != 0) {
                lineStart = CGPoint.pointOnCircle(center: centerPoint, radius: radius + 4, angle: angle)
                lineEnd = CGPoint.pointOnCircle(center: centerPoint, radius: lineRadius - 4, angle: angle)
                path.move(to: lineStart)
                path.addLine(to: lineEnd)
            }
        }
        path.close()
        path.stroke()
    }
    
    func prune(value: CGFloat) -> CGFloat {
        let iVal:Int = Int(value)
        let err:Int = iVal % 60
        let snapTolerance: Int = 30 /* 0.5 min, 30 secs, snap to per miniute */
        return (err < snapTolerance) ? CGFloat(iVal - err) : CGFloat(iVal - err + 60)
            //(err >= 0.75) ? CGFloat(iVal + 1) : CGFloat(iVal) + 0.5
    }
    func pruneForSmallUnit(value: CGFloat) -> CGFloat {
        let iVal:Int = Int(value)
        let err:CGFloat = (value - CGFloat(iVal))
        
        if (err <= 8) {/* less 8 seconds */
            return CGFloat(iVal);
        }
        else if (err <= 22) {
            return CGFloat(iVal) + 15;
        }
        else if (err >= 52) {
            return CGFloat(iVal) + 60;
        }
        else if (err >= 38) {
            return CGFloat(iVal) + 45;
        }
        else {
            return CGFloat(iVal) + 30;
        }
    }
}
