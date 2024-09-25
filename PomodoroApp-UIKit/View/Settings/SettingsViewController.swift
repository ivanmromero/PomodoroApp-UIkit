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
        title = "Settings"
        setupBackbutton()
        viewModel?.verifyFirstInit()
        addCountersViews()
    }
    
    private func setupBackbutton() {
        setNavigationButton(position: .left, systemName: "arrowshape.turn.up.backward") { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
    }
    
    private func addCountersViews() {
        guard let settings = viewModel?.getSettings() else { return }

        for setting in settings {
            let lastView = view.subviews.last
            let counterView = CounterView(title: "\(setting.type ?? ""):", counter: "\(setting.count)")
            
            view.addSubview(counterView)
            
            setup(counterView, with: lastView)
            addObserver(with: counterView.identifier)
        }
    }
    
    private func setup(_ counterView: CounterView, with lastView: UIView?) {
        counterView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            counterView.topAnchor.constraint(equalTo: lastView?.bottomAnchor ?? view.safeAreaLayoutGuide.topAnchor , constant: 20),
            counterView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            counterView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            counterView.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    private func addObserver(with identifier: String) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.counterChanged(_:)), name: NSNotification.Name(identifier), object: nil)
    }
    
    @objc private func counterChanged(_ notification: NSNotification) {
        guard let counterView = notification.object as? CounterView,
              let type = counterView.title.text,
              let count = Int16(counterView.counter.text ?? "")
        else { return }
        
        viewModel?.updateSetting(type: type, count: count)
    }
}
