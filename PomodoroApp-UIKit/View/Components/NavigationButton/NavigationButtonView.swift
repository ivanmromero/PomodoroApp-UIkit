//
//  NavigationButton.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 04/05/2024.
//

import UIKit

final class NavigationButtonView: UIView {
    @IBOutlet weak var navigationButtonImageView: UIImageView!
    
    var buttonAction: ()->() = {}
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupNavigationButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupNavigationButton()
    }
    
    private func setupNavigationButton() {
        self.instantiateCustomViewOnNib(name: self.name)
        addGesture()
    }
    
    @objc func tapped(_ sender: Any) {
        self.buttonAction()
    }
    
    private func addGesture() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        navigationButtonImageView.addGestureRecognizer(tap)
    }
    
    func setAction(_ action: @escaping ()->()) {
        self.buttonAction = action
    }
}
