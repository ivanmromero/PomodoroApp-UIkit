//
//  CountdownViewDelegate.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 29/08/2024.
//

import Foundation

protocol CountdownViewDelegate: AnyObject {
    func timerFinished(completedStages: Int, completedRests: Int)
}
