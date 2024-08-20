//
//  NewTaskViewModel.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 07/08/2024.
//

import Foundation
import UIKit
import CoreData

class NewTaskViewModel {
    private var contex: NSManagedObjectContext
    
    init?() {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        else { return nil }
        self.contex = context
    }
    
    func createTask(with taskText: String, and taskType: String) -> Bool {
        let tasks = Tasks(context: contex)
        
        tasks.task = taskText
        tasks.date = Date()
        tasks.type = taskType
        
        do {
            try contex.save()
            return true
        } catch {
            return false
        }
    }
}
