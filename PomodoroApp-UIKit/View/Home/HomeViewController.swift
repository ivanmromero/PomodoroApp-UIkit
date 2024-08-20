//
//  HomeViewController.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 04/05/2024.
//

import UIKit
import SwiftUI

class HomeViewController: UIViewController {
    @IBOutlet weak var countdownView: CountdownView!
    @IBOutlet weak var playerControlView: PlayerControlView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setHomeNavigationBarButtons()
        setPlusButton()
    }
    
    private func setHomeNavigationBarButtons() {
        self.setNavigationButton(position: .left, systemName: "clock.arrow.circlepath") { [weak self] in
            self?.navigationController?.pushViewController(HistoryViewController(), animated: true)
        }
        self.setNavigationButton(position: .right, systemName: "gear") { [weak self] in         self?.navigationController?.pushViewController(SettingsViewController(), animated: true)
        }
    }
    
    private func setPlusButton() {
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(createNewTask))
        
        playerControlView.plusPlayButton.addGestureRecognizer(gesture)
    }
    
    @objc func createNewTask() {
        let newTaskViewController: NewTaskViewController = NewTaskViewController()
        
        newTaskViewController.delegate = self
        
        navigationController?.present(newTaskViewController, animated: true)
        let hapticFeedback = UIImpactFeedbackGenerator()
        hapticFeedback.prepare()
        hapticFeedback.impactOccurred(intensity: 2)
    }
}

extension HomeViewController: NewTaskViewControllerDelegate {
    func taskDidAdded(task: String) {
        print("Se imprimio la task en el homeviewcontroller: ", task)
        startTimer()
    }
    
    private func startTimer() {
        countdownView.startCountdown()
    }
    
    private func prepareTimerForStart() {
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
