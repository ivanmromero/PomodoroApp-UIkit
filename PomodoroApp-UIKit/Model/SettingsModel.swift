//
//  SettingsModel.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 28/06/2024.
//

struct SettingsModel {
    let types: [String] = [ "Pomodoro lenght",
                            "Basic rest lenght",
                            "Long rest cadence",
                            "Long rest Lenght"]
    
    var settingsDict: [String: Int] {
        var dictionary: [String: Int] = [:]
        let counters: [Int] = [25, 5, 4, 15]
        
        for (index, type) in types.enumerated() {
            dictionary[type] = counters[index]
        }
        
        return dictionary
    }
}
