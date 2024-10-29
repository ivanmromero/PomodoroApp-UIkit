//
//  HomeViewController.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 04/05/2024.
//

import UIKit
import SwiftUI

final class HomeViewController: UIViewController {
    // MARK: @IBOutlets
    @IBOutlet weak var countdownView: CountdownView!
    @IBOutlet weak var playerControlView: PlayerControlView!
    @IBOutlet weak var taskInfoView: TitleSubtextView!
    
    // MARK: Private Properties
    private let viewModel: HomeViewModel? = HomeViewModel()
    
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
        taskInfoView.change(adjustsFontSizeToFitWidth: false, for: .title)
        taskInfoView.change(numberOfLines: 1, for: .title)
        taskInfoView.change(lineBreakMode: .byTruncatingTail, for: .title)
        setDefaultTaskInfoTexts()
    }
    
    // MARK: Private funcs
    private func setDefaultTaskInfoTexts() {
        taskInfoView.titleText = "Gotta do some work?"
        taskInfoView.subtextText = "Press plus button when you are ready"
    }
    
    private func updateSettingsNavigationBarButton(isEnabled: Bool) {
        updateNavigationButtonState(isEnabled: isEnabled, position: .right)
    }
}

// MARK: - CountdownViewDelegate

extension HomeViewController: CountdownViewDelegate {
    func timerFinished(completedStages: Int, completedRests: Int) {
        updateSettingsNavigationBarButton(isEnabled: true)
        resetPlayerControl()
        setDefaultTaskInfoTexts()
        viewModel?.saveSessionInformation(completedStages: completedStages, completedRests: completedRests)
    }
}

// MARK: - PlayerControlViewDelegate

extension HomeViewController: PlayerControlViewDelegate {

    // MARK: Stop Button control
    func didTapStopButton() {
        countdownView.stopCountdown()
        resetPlayerControl()
        setDefaultTaskInfoTexts()
        updateSettingsNavigationBarButton(isEnabled: true)
        HapticFeedbackHandler.impactOccurred(intensity: 3)
    }
    
    private func resetPlayerControl() {
        playerControlView.change(isEnabled: false, playerControlButton: .stop)
        playerControlView.change(isEnabled: false, playerControlButton: .forward)
        playerControlView.resetPlusPlayPauseButtonState()
    }
    
    // MARK: PlusPlayPause Button control
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
        HapticFeedbackHandler.impactOccurred()
    }

    private func pauseButtonPressed() {
        countdownView.pauseCountdown()
        changePlusPlayPauseButtonToNextState()
        HapticFeedbackHandler.impactOccurred()
    }
    
    private func changePlusPlayPauseButtonToNextState() {
        playerControlView.changePlusPlayPauseButtonToNextState()
    }
    
    private func presentNewTask() {
        let newTaskViewController: NewTaskViewController = NewTaskViewController()
        
        newTaskViewController.delegate = self
        
        navigationController?.present(newTaskViewController, animated: true)
        HapticFeedbackHandler.impactOccurred(intensity: 2)
    }
    
    // MARK: Forward Button control
    func didTapForwardButton(state: PlusPlayPauseButtonState) {
        if state == .play {
            playButtonPressed()
        }
        
        HapticFeedbackHandler.impactOccurred()
        countdownView.nextStage()
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
    
    private func prepareTimerForStart() {
        playerControlView.change(isEnabled: true, playerControlButton: .stop)
        playerControlView.change(isEnabled: true, playerControlButton: .forward)
        changePlusPlayPauseButtonToNextState()
    }
    
    // MARK: Timer Control
    private func startTimer() {
        startCountdownView()
        updateSettingsNavigationBarButton(isEnabled: false)
    }
    
    private func startCountdownView() {
        guard let totalSeconds: Int = viewModel?.getSettingValue(for: .pomodoroLength),
              let stagesQuantity: Int = viewModel?.getSettingValue(for: .longRestCadence),
              let secondsToBasicRest: Int = viewModel?.getSettingValue(for: .basicRestLength),
              let secondsToLongRest: Int = viewModel?.getSettingValue(for: .longRestLength)
        else { return }
        
        countdownView.startCountdown(totalSeconds: totalSeconds,
                                     stagesQuantity: stagesQuantity,
                                     secondsToBasicRest: secondsToBasicRest,
                                     secondsToLongRest: secondsToLongRest)
    }
}
