//
//  SettingsModel.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 28/06/2024.
//

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
