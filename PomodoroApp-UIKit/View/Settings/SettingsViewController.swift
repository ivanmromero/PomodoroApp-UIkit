//
//  SettingsViewController.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 11/06/2024.
//

import UIKit
import SwiftUI
import CoreData

class SettingsViewController: UIViewController {
    private let viewModel: SettingsViewModel? = SettingsViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackbutton()
        viewModel?.verifyFistInit()
        title = "Settings"
        
        var counterViews: [CounterView] = []
        
        guard let settings = viewModel?.getSettings() else { return }

        for (index,setting) in settings.enumerated() {
            let counterView = CounterView(title: "\(setting.type ?? ""):", counter: "\(setting.count)")
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.counterChanged(_:)), name: NSNotification.Name(counterView.identifier), object: nil)
            
            counterViews.append(counterView)
            counterView.translatesAutoresizingMaskIntoConstraints = false
            
            view.addSubview(counterView)
            let topConstraint = index == 0 ? view.safeAreaLayoutGuide.topAnchor : counterViews[index-1].bottomAnchor
            
            NSLayoutConstraint.activate([
                counterView.topAnchor.constraint(equalTo: topConstraint, constant: 20),
                counterView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                counterView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                counterView.heightAnchor.constraint(equalToConstant: 75)
            ])
        }
    }
    
    private func setupBackbutton() {
        setNavigationButton(position: .left, systemName: "arrowshape.turn.up.backward") { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func counterChanged(_ notification: NSNotification) {
        guard let counterView = notification.object as? CounterView,
              let type = counterView.title.text,
              let count = Int16(counterView.counter.text ?? "")
        else { return }
        
        viewModel?.updateSetting(type: type, count: count)
    }
}
