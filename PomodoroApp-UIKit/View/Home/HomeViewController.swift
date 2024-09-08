//
//  HomeViewController.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 04/05/2024.
//

import UIKit
import SwiftUI

class HomeViewController: UIViewController {
    // MARK: @IBOutlets
    @IBOutlet weak var countdownView: CountdownView!
    @IBOutlet weak var playerControlView: PlayerControlView!
    @IBOutlet weak var taskInfoView: TitleSubtextView!
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setHomeNavigationBarButtons()
        setupCountdownView()
        setupPlayerControlView()
        setupTaskInfoView()
    }
    
    // MARK: Setups
    private func setHomeNavigationBarButtons() {
        self.setNavigationButton(position: .left, systemName: "clock.arrow.circlepath") { [weak self] in
            self?.navigationController?.pushViewController(HistoryViewController(), animated: true)
        }
        self.setNavigationButton(position: .right, systemName: "gear") { [weak self] in         self?.navigationController?.pushViewController(SettingsViewController(), animated: true)
        }
    }
    
    private func setupCountdownView() {
        countdownView.delegate = self
    }
    
    private func setupPlayerControlView() {
        playerControlView.delegate = self
    }
    
    private func setupTaskInfoView() {
        taskInfoView.titleLabel.adjustsFontSizeToFitWidth = false
        taskInfoView.titleLabel.numberOfLines = 1
        taskInfoView.titleLabel.lineBreakMode = .byTruncatingTail
        setDefaultTaskInfoTexts()
    }
    
    private func setDefaultTaskInfoTexts() {
        taskInfoView.titleText = "Gotta do some work?"
        taskInfoView.subtextText = "Press plus button when you are ready"
    }
}

// MARK: - CountdownViewDelegate
extension HomeViewController: CountdownViewDelegate {
    func timerFinished(completedStages: Int, completedRests: Int) {
        resetPlayerControl()
        setDefaultTaskInfoTexts()
    }
}

// MARK: - PlayerControlViewDelegate
extension HomeViewController: PlayerControlViewDelegate {
    func didTapStopButton() {
        countdownView.stopCountdown()
        resetPlayerControl()
        setDefaultTaskInfoTexts()
    }
    
    private func resetPlayerControl() {
        playerControlView.change(isEnabled: false, playerControlButton: .stop)
        playerControlView.change(isEnabled: false, playerControlButton: .forward)
        playerControlView.resetPlusPlayPauseButtonState()
    }
    
    func didTapForwardButton(state: PlusPlayPauseButtonState) {
        if state == .play {
            playButtonPressed()
        }
        
        countdownView.nextStage()
    }
    
    func didTapPlusPlayPauseButton(state: PlusPlayPauseButtonState) {
        switch state {
        case .plus:
            plusButtonPressed()
        case .play:
            playButtonPressed()
        case .pause:
            pauseButtonPressed()
        }
    }
    
    private func plusButtonPressed() {
        presentNewTask()
    }

    private func playButtonPressed() {
        countdownView.resumeCountdown()
        changePlusPlayPauseButtonToNextState()
    }

    private func pauseButtonPressed() {
        countdownView.pauseCountdown()
        changePlusPlayPauseButtonToNextState()
    }
    
    private func changePlusPlayPauseButtonToNextState() {
        playerControlView.changePlusPlayPauseButtonToNextState()
    }
    
    private func presentNewTask() {
        let newTaskViewController: NewTaskViewController = NewTaskViewController()
        
        newTaskViewController.delegate = self
        
        navigationController?.present(newTaskViewController, animated: true)
        let hapticFeedback = UIImpactFeedbackGenerator()
        hapticFeedback.prepare()
        hapticFeedback.impactOccurred(intensity: 2)
    }
}

// MARK: - NewTaskViewControllerDelegate
extension HomeViewController: NewTaskViewControllerDelegate {
    func taskDidAdded(task: String, taskType: String) {
        taskInfoView.titleText = task
        taskInfoView.subtextText = taskType
        startTimer()
        prepareTimerForStart()
    }
    
    private func startTimer() {
        countdownView.startCountdown(totalSeconds: 5, stagesQuantity: 4, secondsToBasicRest: 2, secondsToLongRest: 7)
    }
    
    private func prepareTimerForStart() {
        playerControlView.change(isEnabled: true, playerControlButton: .stop)
        playerControlView.change(isEnabled: true, playerControlButton: .forward)
        changePlusPlayPauseButtonToNextState()
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
