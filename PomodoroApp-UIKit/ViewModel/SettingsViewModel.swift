//
//  SettingsViewModel.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 28/06/2024.
//

import UIKit
import CoreData

final class SettingsViewModel {
    // MARK: Private Properties
    private let context: NSManagedObjectContext
    private let settingsTypes: [SettingType]
    
    // MARK: Initialization
    init?() {
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext 
        else { return nil }
        
        self.context = context
        self.settingsTypes = SettingType.allCases
    }

    // MARK: First init
    func verifyFirstInit() {
        guard let settings = getSettings(),
              settings.isEmpty
        else { return }
        
        settingsTypes.forEach { addNewSetting(type: $0.rawValue, count: Int16($0.defaultValue)) }
    }
    
    // MARK: Settings cru
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
