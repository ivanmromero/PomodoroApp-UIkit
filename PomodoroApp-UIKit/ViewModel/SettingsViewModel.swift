//
//  SettingsViewModel.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 28/06/2024.
//

import UIKit
import CoreData

class SettingsViewModel {
    private let context: NSManagedObjectContext
    private let settingsModel: SettingsModel
    
    init?() {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext 
        else { return nil }
        
        self.context = context
        self.settingsModel = SettingsModel()
    }

    func verifyFistInit() {
        guard let settings = getSettings(),
              settings.isEmpty
        else { return }
        
        for type in settingsModel.types {
            if let count = settingsModel.settingsDict[type] {
                addNewSetting(type: type, count: Int16(count))
            }
        }
    }
    
    private func addNewSetting(type: String, count: Int16) {
        let nuevoSetting = Settings(context: context)
        
        nuevoSetting.type = type
        nuevoSetting.count = count
        
        try? context.save()
    }
    
    func getSettings() -> [Settings]? {
        return try? context.fetch(Settings.fetchRequest())
    }
    
    func updateSetting(type: String, count: Int16) {
        guard let settings = getSettings(),
              let setting = settings.first(where: { $0.type ==
                  type.replacingOccurrences(of: ":", with: "") })
        else { return }
        
        setting.count = count
        
        try? context.save()
    }
}
