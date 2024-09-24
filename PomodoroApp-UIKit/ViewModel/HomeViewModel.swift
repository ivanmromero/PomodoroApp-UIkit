//
//  HomeViewModel.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 16/09/2024.
//

import UIKit
import CoreData

class HomeViewModel {
    // MARK: Private Properties
    private let context: NSManagedObjectContext? = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    private var settingsUsed: [Settings]?
    
    // MARK: Task
    private var task: Tasks? {
        try? context?.fetch(Tasks.fetchRequest()).last
    }
    
    // MARK: Settings
    private func getSettings() -> [Settings]? {
        guard let context else { return nil }
        
        let settingsRequest: NSFetchRequest<Settings> = Settings.fetchRequest()
        
        settingsUsed = try? context.fetch(settingsRequest)
        
        return settingsUsed
    }
    
    func getSettingValue(for type: SettingType) -> Int {
        guard let settings = getSettings(),
              let setting = settings.first(where: { $0.type == type.rawValue })
        else { return type.defaultValue }
        
        let value: Int = Int(setting.count)
        
        return type == .longRestCadence ? value : value * 60
    }
    
    // MARK: Session Information
    func saveSessionInformation(completedStages: Int, completedRests: Int) {
        guard let context else { return }
        
        let newSessionInformation = SessionInformations(context: context)
        
        newSessionInformation.pomodoros = Int16(completedStages)
        newSessionInformation.rests = Int16(completedRests)
        
        guard let settingsUsed else { return }
        newSessionInformation.settings = NSSet(array: settingsUsed)
        
        newSessionInformation.task = task
        
        try? context.save()
    }
}
