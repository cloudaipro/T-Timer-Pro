//
//  TimeStatus.swift
//  T-Timer Pro
//
//  Created by DellMac on 2019-12-08.
//  Copyright © 2019 CCS. All rights reserved.
//

import Foundation

enum TimerStatus {
    case SETTING
    case START
    case STOP
}
enum TimerEvent {
    case TIMEUP
    case LASTONEMINUTE
    case REWARDING
    case LASTSECOND(Int)
}
