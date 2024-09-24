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

enum SettingType: String, CaseIterable {
    case pomodoroLength = "Pomodoro lenght"
    case basicRestLength = "Basic rest lenght"
    case longRestCadence = "Long rest cadence"
    case longRestLength = "Long rest Lenght"
    
    var defaultValue: Int {
        switch self {
        case .pomodoroLength: return 25
        case .basicRestLength: return 5
        case .longRestCadence: return 4
        case .longRestLength: return 15
        }
    }
}
