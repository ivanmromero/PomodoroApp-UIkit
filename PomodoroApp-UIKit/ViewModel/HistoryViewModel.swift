//
//  HistoryViewModel.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 14/10/2024.
//

import CoreData
import UIKit

class HistoryViewModel {
    // MARK: Private Properties
    private let context: NSManagedObjectContext
    
    private var tasks: [Tasks]? {
        try? context.fetch(Tasks.fetchRequest())
    }
        
    // MARK: Initialization
    init?() {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        else { return nil }
        self.context = context
    }
    
    // MARK: Tasks control
    func getTasks(for date: Date) -> [Tasks]? {
        tasks?.reversed().filter { task in
            guard let taskDate = task.date else { return false }
            return Calendar.current.isDate(taskDate, inSameDayAs: date)
        }
    }
    
    func getTask(for date: Date, and index: Int) -> Tasks? {
        getTasks(for: date)?[index]
    }
    
    func deleteTask(for date: Date, and index: Int) throws {
        guard let task = getTask(for: date, and: index) else { return }
        
        context.delete(task)
        
        do {
            try context.save()
        } catch {
            throw error
        }
    }
}
