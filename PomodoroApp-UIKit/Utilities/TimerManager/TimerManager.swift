//
//  TimerManager.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 26/08/2024.
//

import Foundation
import UIKit

class TimerManager {
    // MARK: Private Properties
    private var secondsTimer: Timer?
    private var millisecondsTimer: Timer?
    private var backgroundTime: CFTimeInterval?
    private var hasRemainingTime: Bool { remainingTime > 0 }
    
    // MARK: Private Set Properties
    private(set) var totalSeconds: Int
    private(set) var remainingTime: Int
    private(set) var millisecondsTime: Double
    
    // MARK: Internal Properties
    var adjustRemainingTimeForMilliseconds: Bool = false
    
    // MARK: Delegate
    weak var delegate: TimerManagerDelegate?
    
    // MARK: Initialization
    init(totalSeconds: Int) {
        self.totalSeconds = totalSeconds
        remainingTime = self.totalSeconds
        millisecondsTime = 0.0
        addObservers()
    }
    
    // MARK: Deinitialization
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Timer Control
    func start() {
        guard hasRemainingTime else { return }
        
        startSecondsTimer()
        startMillisecondsTimer()
    }

    private func startSecondsTimer() {
        secondsTimer = Timer.scheduledTimer(timeInterval: 1.0,
                                            target: self,
                                            selector: #selector(updateRemainingTime),
                                            userInfo: nil,
                                            repeats: true)
    }
        
    func startMillisecondsTimer() {
        invalidateTimerMiliseconds()
        if !adjustRemainingTimeForMilliseconds {
            millisecondsTime = 0.0
        }
        
        if hasRemainingTime {
            millisecondsTimer = Timer.scheduledTimer(timeInterval: 0.01,
                                                     target: self,
                                                     selector: #selector(updateMiliseconds),
                                                     userInfo: nil,
                                                     repeats: true)
        }
    }
    
    @objc private func updateRemainingTime() {
        invalidateTimerMiliseconds()
        remainingTime -= 1
        startMillisecondsTimer()
        delegate?.remainingTimeUpdated()
        
        if !hasRemainingTime {
            stop()
            delegate?.timerEnded()
        }
    }
    
    @objc private func updateMiliseconds() {
        millisecondsTime += 0.01

        if millisecondsTime >= 1 {
            invalidateTimerMiliseconds()
            
            if adjustRemainingTimeForMilliseconds {
                remainingTime -= 1
                delegate?.remainingTimeUpdated()
                adjustRemainingTimeForMilliseconds = false
                hasRemainingTime ? start() : delegate?.timerEnded()
            }
        }
    }
    
    // MARK: Timer Invalidation
    func stop() {
        invalidateTimer()
        invalidateTimerMiliseconds()
    }
    
    func invalidateTimer() {
        secondsTimer?.invalidate()
        secondsTimer = nil
    }
    
    func invalidateTimerMiliseconds() {
        millisecondsTimer?.invalidate()
        millisecondsTimer = nil
    }
    
    // MARK: App Background Handling
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc private func appDidEnterBackground() {
        backgroundTime = CACurrentMediaTime()
        invalidateTimer()
    }

    @objc private func appWillEnterForeground() {
        guard let backgroundTime = backgroundTime else { return }
        
        let timeInBackground = CACurrentMediaTime() - backgroundTime

        if hasRemainingTime {
            remainingTime -= Int(timeInBackground)
            
            delegate?.remainingTimeUpdated()
            delegate?.appWillEnterForeground()
            start()
        }
    }
}
