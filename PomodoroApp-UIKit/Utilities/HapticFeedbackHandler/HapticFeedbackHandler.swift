//
//  HapticFeedbackHandler.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 23/09/2024.
//

import UIKit

class HapticFeedbackHandler {
    static func impactOccurred(intensity: CGFloat = 1) {
        let hapticFeedback: UIImpactFeedbackGenerator = UIImpactFeedbackGenerator()
        hapticFeedback.prepare()
        hapticFeedback.impactOccurred(intensity: intensity)
    }
}
