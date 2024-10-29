//
//  Date+Extension.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 28/10/2024.
//

import Foundation

extension Date {
    func isSame(_ component: Calendar.Component, that otherDate: Date) -> Bool {
        let calendar = Calendar.current
        
        let selfComponent = calendar.component(component, from: self)
        let otherComponent = calendar.component(component, from: otherDate)

        return selfComponent == otherComponent
    }
}
