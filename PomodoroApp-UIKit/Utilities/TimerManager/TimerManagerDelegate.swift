//
//  TimerManagerDelegate.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 26/08/2024.
//

import Foundation

protocol TimerManagerDelegate: AnyObject {
    func remainingTimeUpdated()
    func appWillEnterForeground()
    func timerEnded()
}
