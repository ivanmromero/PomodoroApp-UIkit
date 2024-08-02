//
//  PlayerControlView.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 23/07/2024.
//

import UIKit

class PlayerControlView: UIView {
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var plusPlayButton: UIButton!
    @IBOutlet weak var forwardButton: UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        shadowView.addDefaultShadow(for: .outer, cornerRadius: 20)
        stopButton.addDefaultShadow(for: .outer)
        plusPlayButton.addDefaultShadow(for: .outer, cornerRadius: plusPlayButton.bounds.size.width / 2)
        forwardButton.addDefaultShadow(for: .outer)
    }
    
    private func setup() {
        self.instantiateCustomViewOnNib(name: self.name)
        setupGradient()
    }
    
    private func setupGradient() {
        setupGradient(for: stopButton)
        setupGradient(for: plusPlayButton)
        setupGradient(for: forwardButton)
    }
    
    private func setupGradient(for button: UIButton) {
        button.setImage(button.imageView?.image?.gradientImage([.systemPurple, .systemPink]), for: .normal)
        button.setImage(button.imageView?.image?.gradientImage([.gray, .gray]), for: .highlighted)
    }
}
