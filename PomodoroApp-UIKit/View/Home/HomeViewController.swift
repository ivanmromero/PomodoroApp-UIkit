//
//  HomeViewController.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 04/05/2024.
//

import UIKit
import SwiftUI

class HomeViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setHomeNavigationBarButtons()
    }
    
    private func setHomeNavigationBarButtons() {
        self.setNavigationButton(position: .left, systemName: "clock.arrow.circlepath") { [weak self] in
            self?.navigationController?.pushViewController(HistoryViewController(), animated: true)
        }
        self.setNavigationButton(position: .right, systemName: "gear") { [weak self] in         self?.navigationController?.pushViewController(SettingsViewController(), animated: true)
        }
    }
}

//struct HomeViewController_Previews: PreviewProvider {
//    static var previews: some View {
//        ViewControllerPreview()
//    }
//}
//
//struct ViewControllerPreview: UIViewControllerRepresentable {
//    typealias UIViewControllerType = HomeViewController
//    
//    func makeUIViewController(context: Context) -> HomeViewController {
//        HomeViewController()
//    }
//    
//    func updateUIViewController(_ uiViewController: HomeViewController, context: Context) {
//        
//    }
//}
