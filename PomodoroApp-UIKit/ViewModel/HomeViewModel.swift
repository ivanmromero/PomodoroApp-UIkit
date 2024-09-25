//
//  HomeViewModel.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 16/09/2024.
//

import UIKit
import CoreData

final class HomeViewModel {
    // MARK: Private Properties
    private let context: NSManagedObjectContext
        
    // MARK: Initialization
    init?() {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
        else { return nil }
        self.context = context
    }
    
    // MARK: Last Task
    private var task: Tasks? {
        try? context.fetch(Tasks.fetchRequest()).last
    }
    
    // MARK: Settings
    private var settings: [Settings]? {
        try? context.fetch(Settings.fetchRequest())
    }
    
    func getSettingValue(for type: SettingType) -> Int {
        guard let settings = settings,
              let setting = settings.first(where: { $0.type == type.rawValue })
        else { return type.defaultValue }
        
        let value: Int = Int(setting.count)
        
        return type == .longRestCadence ? value : value * 60
    }
    
    // MARK: Session Information
    func saveSessionInformation(completedStages: Int, completedRests: Int) {
        let newSessionInformation = SessionsInformation(context: context)
        
        newSessionInformation.pomodoros = Int16(completedStages)
        newSessionInformation.rests = Int16(completedRests)
        
        guard let settings else { return }
        newSessionInformation.settings = NSSet(array: settings)
        
        newSessionInformation.task = task
        
        try? context.save()
    }
}
