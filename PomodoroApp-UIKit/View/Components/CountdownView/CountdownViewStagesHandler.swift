//
//  CountdownViewStagesHandler.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 04/09/2024.
//

final class CountdownViewStagesHandler {
    // MARK: Private Properties
    private var secondsOfStage: Int
    private var stagesQuantity: Int {
        didSet {
            currentStage += 1
        }
    }
    private var secondsToBasicRest: Int
    private var secondsToLongRest: Int
    
    // MARK: Private Set Properties
    private(set) var isTimeToRest: Bool = false
    private(set) var currentStage: Int = 1
    private(set) var secondsToNextStage: Int = 0
    
    // MARK: Internal Properties
    var completedRests: Int {
        let numberOfRests = isTimeToRest ? currentStage - 2 : currentStage - 1
        
        return numberOfRests < 0 ? 0 : numberOfRests
    }
    
    var completedStages: Int {
        currentStage - 1
    }
    
    // MARK: Initialization
    init(secondsOfStage: Int, stagesQuantity: Int, secondsToBasicRest: Int, secondsToLongRest: Int) {
        self.secondsOfStage = secondsOfStage
        self.stagesQuantity = stagesQuantity
        self.secondsToBasicRest = secondsToBasicRest
        self.secondsToLongRest = secondsToLongRest
    }
    
    // MARK: Private Funcs
    private func getSecondsToRest() -> Int {
        stagesQuantity > 1 ? secondsToBasicRest : secondsToLongRest
    }
    
    // MARK: Stages Control
    func canAdvanceToNextStage() -> Bool {
        let canAdvance = stagesQuantity > 0
        
        if !canAdvance {
            isTimeToRest = false
        }
        
        return canAdvance
    }
    
    func advanceToNextStage() {
        guard canAdvanceToNextStage() else { return }
        
        isTimeToRest.toggle()
        
        secondsToNextStage = !isTimeToRest ? secondsOfStage : getSecondsToRest()
        
        if isTimeToRest {
            stagesQuantity -= 1
        }
    }
}
