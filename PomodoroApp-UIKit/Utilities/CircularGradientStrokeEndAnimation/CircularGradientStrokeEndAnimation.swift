//
//  CircularGradientCountdownAnimation.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 03/09/2024.
//

import UIKit

class CircularGradientStrokeEndAnimation {
    // MARK: Private Properties
    private let shapeLayer: CAShapeLayer
    private let gradientLayerProvider: GradientLayerProvider
    
    // MARK: Initialization
    init(gradientLayerProvider: GradientLayerProvider = DefaultGradientLayerProvider()) {
        self.shapeLayer = CAShapeLayer()
        self.gradientLayerProvider = gradientLayerProvider
    }
    
    // MARK: Private Funcs
    private func setupShapeLayer(radius: CGFloat, lineWidth: CGFloat, position: CGPoint) {
        let path = createCircularPath(radius: radius)
        configureShapeLayer(path: path, lineWidth: lineWidth, position: position)
    }
    
    private func createCircularPath(radius: CGFloat) -> CGPath {
        UIBezierPath(arcCenter: .zero,
                     radius: radius,
                     startAngle: -CGFloat.pi / 2,
                     endAngle: CGFloat.pi * 3 / 2,
                     clockwise: true).cgPath
    }
    
    private func configureShapeLayer(path: CGPath, lineWidth: CGFloat, position: CGPoint) {
        shapeLayer.path = path
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.position = position
    }
    
    private func createGradientLayer(mask: CALayer) -> CAGradientLayer {
        gradientLayerProvider.createGradientLayer(mask: mask)
    }
    
    // MARK: Add Animation
    func addAnimation(to view: UIView, with radius: CGFloat, _ lineWidth: CGFloat, _ position: CGPoint) {
        setupShapeLayer(radius: radius, lineWidth: lineWidth, position: position)
        let gradientLayer = createGradientLayer(mask: shapeLayer)
        view.clipsToBounds = true
        view.layer.addSublayer(gradientLayer)
    }
    
    // MARK: Animation Control
    func start(totalTime: TimeInterval, remainingTime: TimeInterval, withRemainingTime: Bool = false) {
        stop()
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.fromValue = withRemainingTime ? 1 - ((CFTimeInterval(totalTime - remainingTime)) / Double(totalTime)) : 1
        basicAnimation.toValue = 0
        basicAnimation.duration = withRemainingTime ? CFTimeInterval(remainingTime) : CFTimeInterval(totalTime)
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
    }
    
    func pause() {
        let pausedTime: CFTimeInterval = shapeLayer.convertTime(CACurrentMediaTime(), from: nil)
        shapeLayer.speed = 0.0
        shapeLayer.timeOffset = pausedTime
    }
    
    func resume() {
        let pausedTime: CFTimeInterval = shapeLayer.timeOffset
        shapeLayer.speed = 1.0
        shapeLayer.timeOffset = 0.0
        shapeLayer.beginTime = 0.0
        let timeSincePause: CFTimeInterval = shapeLayer.convertTime(CACurrentMediaTime(), from: nil) - pausedTime
        shapeLayer.beginTime = timeSincePause
    }
    
    func stop() {
        shapeLayer.removeAllAnimations()
    }
}
