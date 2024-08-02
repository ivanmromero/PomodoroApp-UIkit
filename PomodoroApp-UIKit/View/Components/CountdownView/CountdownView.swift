//
//  CountdownView.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 26/07/2024.
//

import UIKit

class CountdownView: UIView {
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var outerShadowView: UIView!
    @IBOutlet private weak var innerShadowView: UIView!
    
    private var shapeLayer: CAShapeLayer = CAShapeLayer()
    private var timer: Timer?
    private var totalTime: Int = 10
    private var remainingTime: Int = 10
    private var backgroundTime: CFTimeInterval?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupShadows()
        setupShapeLayer()
    }
    
    private func setup() {
        instantiateCustomViewOnNib(name: self.name)
        timeLabel.font = timeLabel.font.withSize(timeLabel.frame.height * 2/3)
        addObservers()
    }
    
    private func setupShadows() {
        outerShadowView.addDefaultShadow(for: .outer, cornerRadius: min(self.outerShadowView.bounds.size.width, self.outerShadowView.bounds.size.height)  / 2)
        
        innerShadowView.addDefaultShadow(for: .inner, cornerRadius: min(self.innerShadowView.bounds.width, self.innerShadowView.bounds.height) / 2)
        
        if !innerShadowView.hasPreviousLayerWith(name: "secondInnerShadow") {
            innerShadowView.layer.cornerRadius = min(self.innerShadowView.bounds.width, self.innerShadowView.bounds.height)  / 2
            
            innerShadowView.layer.addInnerShadow(shadowColor: .black,
                                             shadowOpacity: 0.4,
                                             shadowRadius: 1.5,
                                             identifier: "secondInnerShadow")
            
            innerShadowView.layer.addInnerShadow(shadowColor: .white,
                                             shadowOpacity: 0.8,
                                             shadowRadius: 3,
                                             identifier: "secondInnerShadow")
            
            innerShadowView.layer.updateShadowsOnLayout(for: .inner)
        }
    }
    
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func appDidEnterBackground() {
        backgroundTime = CACurrentMediaTime()
        invalidateTimer()
    }

    @objc func appWillEnterForeground() {
        guard let backgroundTime = backgroundTime else { return }
        let timeInBackground = CACurrentMediaTime() - backgroundTime
        remainingTime -= Int(timeInBackground)
        startAnimation(withRemainingTime: true)
        timerStart()
    }
    
    private func setupShapeLayer() {
        if !innerShadowView.hasPreviousLayerWith(name: "gradientWithMask") {
            let circularPath = UIBezierPath(arcCenter: .zero, radius: calculateRadius(for: outerShadowView), startAngle: -CGFloat.pi / 2, endAngle: CGFloat.pi * 3 / 2, clockwise: true)
            shapeLayer.path = circularPath.cgPath
            shapeLayer.strokeColor = UIColor.red.cgColor
            shapeLayer.lineWidth = abs(innerShadowView.layer.cornerRadius - outerShadowView.layer.cornerRadius) * 3
            shapeLayer.position = CGPoint(x: innerShadowView.bounds.midX, y: innerShadowView.bounds.midY)
            
            let gradientLayer = CAGradientLayer()
            gradientLayer.frame = self.bounds
            gradientLayer.colors = [UIColor.systemPurple.cgColor, UIColor.systemPink.cgColor]
            gradientLayer.startPoint = CGPoint(x: 0, y: 0)
            gradientLayer.endPoint = CGPoint(x: 1, y: 1)
            gradientLayer.mask = shapeLayer
            gradientLayer.name = "gradientWithMask"
            
            innerShadowView.clipsToBounds = true
            
            innerShadowView.layer.addSublayer(gradientLayer)
        }
    }
    
    private func calculateRadius(for view: UIView) -> CGFloat {
        let viewWidth = view.bounds.width
        let viewHeight = view.bounds.height
        return (min(viewWidth, viewHeight) / 2)
    }
    
    func startCountdown() {
        timerStart()
        startAnimation()
    }
    
    private func timerStart() {
        if remainingTime > 0 {
            updateTimeLabel()
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateCountdown), userInfo: nil, repeats: true)
        }
    }
    
    @objc private func updateCountdown() {
        remainingTime -= 1
        updateTimeLabel()
        
        if remainingTime == 0 {
            invalidateTimer()
        }
    }
    
    private func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func updateTimeLabel() {
        let minutes = remainingTime / 60
        let seconds = remainingTime % 60
        
        timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func startAnimation(withRemainingTime: Bool = false) {
        shapeLayer.removeAllAnimations()
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        basicAnimation.fromValue = withRemainingTime ? 1 - ((CFTimeInterval(totalTime - remainingTime)) / Double(totalTime)) : 1
        basicAnimation.toValue = 0
        basicAnimation.duration = withRemainingTime ? CFTimeInterval(remainingTime) : CFTimeInterval(totalTime)
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        shapeLayer.add(basicAnimation, forKey: "urSoBasic")
    }
    
    func setTimeForUse(seconds: Int) {
        totalTime = seconds
        remainingTime = totalTime
    }
}
