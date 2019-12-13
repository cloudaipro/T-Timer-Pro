//
//  RoundButton.swift
//  T-Timer Pro
//
//  Created by DellMac on 2019-12-08.
//  Copyright © 2019 CCS. All rights reserved.
//

import Foundation
import UIKit
import ObjectiveC
import RxSwift
import RxCocoa
import Action

@IBDesignable
class RoundButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        setupButton()
    }
    func setupButton() {
        layer.cornerRadius  = frame.size.height/2
        layer.masksToBounds = true
        self.tintColor = nil
    }
}

