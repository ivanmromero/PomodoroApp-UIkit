//
//  GradientLayerProvider.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 03/09/2024.
//

import UIKit

protocol GradientLayerProvider {
    func createGradientLayer(mask: CALayer) -> CAGradientLayer
}
