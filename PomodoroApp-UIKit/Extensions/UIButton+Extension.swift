//
//  UIButton+Extension.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 06/08/2024.
//

import UIKit

extension UIButton {
    func applyGradientToTitle(colors: [UIColor] = [.systemPurple, .systemPink],
                              startPoint: CGPoint = CGPoint(x: 0, y: 0),
                              endPoint: CGPoint = CGPoint(x: 1, y: 1),
                              for state: UIControl.State = .normal) {
        guard let titleLabel = self.titleLabel,
              let text = titleLabel.text,
              !text.isEmpty
        else {
            return
        }
        
        self.layoutIfNeeded()
        
        guard titleLabel.bounds.size != .zero else { return }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors.map { $0.cgColor }
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        gradientLayer.frame = titleLabel.bounds
        
        let renderer = UIGraphicsImageRenderer(size: gradientLayer.bounds.size)
        let gradientImage = renderer.image { context in
            gradientLayer.render(in: context.cgContext)
        }
        
        self.setTitleColor(UIColor(patternImage: gradientImage), for: state)
    }
}
