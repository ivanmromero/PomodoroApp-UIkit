//
//  NewTaskViewModel.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 07/08/2024.
//

import UIKit
import CoreData

final class NewTaskViewModel {
    // MARK: Private Properties
    private var context: NSManagedObjectContext
    
    // MARK: Initialization
    init?() {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        else { return nil }
        self.context = context
    }
    
    // MARK: Task create
    func createTask(with taskText: String, and taskType: String) -> Bool {
        let tasks = Tasks(context: context)
        
        tasks.task = taskText
        tasks.date = Date()
        tasks.type = taskType
        
        do {
            try context.save()
            return true
        } catch {
            return false
        }
    }
}
