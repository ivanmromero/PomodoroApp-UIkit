//
//  NewTaskViewControllerDelegate.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 12/08/2024.
//

import Foundation

protocol NewTaskViewControllerDelegate: AnyObject {
    func taskDidAdded(task: String)
}
