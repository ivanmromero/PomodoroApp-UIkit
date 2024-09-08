//
//  DefaultGradientLayerProvider.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 03/09/2024.
//

import UIKit

class DefaultGradientLayerProvider: GradientLayerProvider {
    // MARK: Private Properties
    private let frame: CGRect
    
    
    // MARK: Initialization
    init(frame: CGRect = .zero) {
        self.frame = frame
    }
    
    // MARK: Gradient Later Creator
    func createGradientLayer(mask: CALayer) -> CAGradientLayer {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.frame
        gradientLayer.colors = [UIColor.systemPurple.cgColor, UIColor.systemPink.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        gradientLayer.mask = mask
        gradientLayer.name = "gradientWithMask"
        return gradientLayer
    }
}
