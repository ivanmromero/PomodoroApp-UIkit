//
//  NavigationButton.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 04/05/2024.
//

import UIKit

final class NavigationButtonView: UIView {
    // MARK: @IBOutlets
    @IBOutlet weak var navigationButtonImageView: UIImageView!
    
    // MARK: Privates Properties
    private var buttonAction: ()->() = {}
    
    // MARK: Initializations
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupNavigationButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupNavigationButton()
    }
    
    // MARK: Setups
    private func setupNavigationButton() {
        self.instantiateCustomViewOnNib(name: self.name)
        setupGesture()
    }
    
    private func setupGesture() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        navigationButtonImageView.addGestureRecognizer(tap)
    }
    
    // MARK: Action Perform
    @objc private func tapped(_ sender: Any) {
        self.buttonAction()
    }
    
    // MARK: Action Set
    func setAction(_ action: @escaping ()->()) {
        self.buttonAction = action
    }
}
