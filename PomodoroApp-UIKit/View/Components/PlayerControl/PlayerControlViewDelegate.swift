//
//  PlayerControlViewDelegate.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 08/09/2024.
//

protocol PlayerControlViewDelegate: AnyObject {
    func didTapStopButton()
    func didTapForwardButton(state: PlusPlayPauseButtonState)
    func didTapPlusPlayPauseButton(state: PlusPlayPauseButtonState)
}
