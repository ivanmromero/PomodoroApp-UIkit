//
//  PlayerControlView.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 23/07/2024.
//

import UIKit

final class PlayerControlView: UIView {
    // MARK: @IBOutlets
    @IBOutlet weak private var shadowView: UIView!
    @IBOutlet weak private var stopButton: UIButton!
    @IBOutlet weak private var plusPlayPauseButton: UIButton!
    @IBOutlet weak private var forwardButton: UIButton!
    
    // MARK: Privates Properties
    private var plusPlayPauseButtonState: PlusPlayPauseButtonState = PlusPlayPauseButtonState() {
        didSet {
            set(image: plusPlayPauseButtonState.image, for: plusPlayPauseButton)
        }
    }
    
    // MARK: Delegate
    var delegate: PlayerControlViewDelegate?
    
    
    // MARK: Initializations
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: Override Funcs
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        shadowView.addDefaultShadow(for: .outer, cornerRadius: 20)
        stopButton.addDefaultShadow(for: .outer)
        plusPlayPauseButton.addDefaultShadow(for: .outer, cornerRadius: plusPlayPauseButton.bounds.size.width / 2)
        forwardButton.addDefaultShadow(for: .outer)
    }
    
    // MARK: Setups
    private func setup() {
        self.instantiateCustomViewOnNib(name: self.name)
        setupGradient()
        setupButtons()
    }
    
    private func setupButtons() {
        change(isEnabled: false, playerControlButton: .stop)
        change(isEnabled: false, playerControlButton: .forward)
    }
    
    private func setupGradient() {
        set(image: stopButton.imageView?.image, for: stopButton)
        set(image: plusPlayPauseButton.imageView?.image, for: plusPlayPauseButton)
        set(image: forwardButton.imageView?.image, for: forwardButton)
    }
    
    private func set(image: UIImage?, for button: UIButton) {
        button.setImage(image?.gradientImage([.systemPurple, .systemPink]), for: .normal)
        button.setImage(image?.gradientImage([.gray, .gray]), for: .highlighted)
        button.setImage(image?.gradientImage([.gray, .gray]), for: .disabled)
    }
    
    // MARK: @IBActions
    @IBAction func buttonTapped(_ button: UIButton) {
        switch button {
        case stopButton:
            delegate?.didTapStopButton()
        case forwardButton:
            delegate?.didTapForwardButton(state: plusPlayPauseButtonState)
        case plusPlayPauseButton:
            delegate?.didTapPlusPlayPauseButton(state: plusPlayPauseButtonState)
        default:
            return
        }
    }
    
    // MARK: Buttons Control
    func change(isEnabled: Bool, playerControlButton: PlayerControlButton) {
        switch playerControlButton {
        case .stop:
            stopButton.isEnabled = isEnabled
        case .plusPlayPause:
            plusPlayPauseButton.isEnabled = isEnabled
        case .forward:
            forwardButton.isEnabled = isEnabled
        }
    }
    
    func resetPlusPlayPauseButtonState() {
        self.plusPlayPauseButtonState = .plus
    }
    
    func changePlusPlayPauseButtonToNextState() {
        let nextState = plusPlayPauseButtonState.nextState
        
        self.plusPlayPauseButtonState = nextState
    }
}

// MARK: - Player Control Buttons
enum PlayerControlButton {
    case stop
    case plusPlayPause
    case forward
}

// MARK: - PlusPlayPause Button State
enum PlusPlayPauseButtonState {
    case plus
    case play
    case pause
    
    init() {
        self = .plus
    }
    
    var image: UIImage? {
        switch self {
        case .plus:
            UIImage(systemName: "plus")
        case .play:
            UIImage(systemName: "play")
        case .pause:
            UIImage(systemName: "pause")
        }
    }
    
    var nextState: PlusPlayPauseButtonState {
        switch self {
        case .plus:
                .pause
        case .play:
                .pause
        case .pause:
                .play
        }
    }
}
