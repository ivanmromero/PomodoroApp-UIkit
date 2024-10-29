//
//  CalendarViewDelegate.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 05/10/2024.
//

import Foundation
import UIKit

protocol CalendarViewDelegate: AnyObject {
    func layoutConstraintsFor(datePicker: UIView) -> [NSLayoutConstraint]?
    func didSelectDate(_ date: Date)
    func backgroundTapped()
}

extension CalendarViewDelegate {
    func backgroundTapped() {
        return
    }
}
