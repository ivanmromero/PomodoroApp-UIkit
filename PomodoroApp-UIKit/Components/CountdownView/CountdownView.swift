//
//  CountdownView.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 26/07/2024.
//

import UIKit

final class CountdownView: UIView {
    // MARK: @IBOutlets
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var stageLabel: UILabel!
    @IBOutlet private weak var outerShadowView: UIView!
    @IBOutlet private weak var innerShadowView: UIView!
    
    // MARK: Private properties
    private var timerManager: TimerManager?
    private var circularGradientCountdownAnimation: CircularGradientStrokeEndAnimation?
    private var stagesHandler: CountdownViewStagesHandler?
    
    // MARK: Delegate
    var delegate: CountdownViewDelegate?
    
    // MARK: Initializations
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    // MARK: Override funcs
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setupShadows()
    }
    
    // MARK: Setups
    private func setup() {
        instantiateCustomViewOnNib(name: self.name)
        setupTimeLabel()
    }
    
    private func setupTimeLabel() {
        timeLabel.font = timeLabel.font.withSize(timeLabel.frame.height * 2/3)
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
    
    private func setupCircularGradientAnimation() {
        if !innerShadowView.hasPreviousLayerWith(name: "gradientWithMask") {
            let gradientLayerProvider = DefaultGradientLayerProvider(frame: self.bounds)
            self.circularGradientCountdownAnimation = CircularGradientStrokeEndAnimation(gradientLayerProvider: gradientLayerProvider)
            
            let radius = calculateRadius(for: outerShadowView)
            let lineWidth = abs(innerShadowView.layer.cornerRadius - outerShadowView.layer.cornerRadius) * 3
            let position = CGPoint(x: innerShadowView.bounds.midX, y: innerShadowView.bounds.midY)
            
            circularGradientCountdownAnimation?.addAnimation(to: innerShadowView, 
                                                             with: radius, lineWidth, position)
        }
    }
    
    // MARK: Private Funcs
    private func calculateRadius(for view: UIView) -> CGFloat {
        let viewWidth = view.bounds.width
        let viewHeight = view.bounds.height
        return (min(viewWidth, viewHeight) / 2)
    }
    
    private func updateLabels() {
        updateTimeLabel()
        updateStagelabel()
    }
    
    private func updateTimeLabel() {
        guard let remainingTime = timerManager?.remainingTime,
              remainingTime >= 0
        else {
            timeLabel.text = "00:00"
            return
        }
        
        let minutes = remainingTime / 60
        let seconds = remainingTime % 60
        
        timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }
    
    private func updateStagelabel() {
        guard let stagesHandler = stagesHandler 
        else {
            stageLabel.text = "P0"
            return
        }
        
        stageLabel.text = !stagesHandler.isTimeToRest ? "P\(stagesHandler.currentStage)" : "REST"
    }
    
    private func startCircularGradientAnimation(withRemainingTime: Bool = false) {
        guard let totalTime = timerManager?.totalSeconds,
              let remainingTime = timerManager?.remainingTime
        else { return }
        
        let totalTimeInterval = CFTimeInterval(totalTime)
        let remainingTimeInterval = CFTimeInterval(remainingTime)
        
        circularGradientCountdownAnimation?.start(totalTime: totalTimeInterval,
                                                  remainingTime: remainingTimeInterval,
                                                  withRemainingTime: withRemainingTime)
    }
    
    private func invalidateTimer() {
        timerManager?.stop()
        timerManager = nil
    }
    
    // MARK: Countdown Control
    func startCountdown(totalSeconds: Int,
                        stagesQuantity: Int = 0,
                        secondsToBasicRest: Int = 0,
                        secondsToLongRest: Int = 0) {
        self.timerManager = TimerManager(totalSeconds: totalSeconds)
        
        if [stagesQuantity, secondsToBasicRest, secondsToLongRest].allSatisfy({ $0 != 0 }) {
            self.stagesHandler = CountdownViewStagesHandler(secondsOfStage: totalSeconds,
                                               stagesQuantity: stagesQuantity,
                                               secondsToBasicRest: secondsToBasicRest,
                                               secondsToLongRest: secondsToLongRest)
        }
        
        timerManager?.delegate = self
        timerManager?.start()
        updateLabels()
        setupCircularGradientAnimation()
        startCircularGradientAnimation()
    }
        
    func pauseCountdown() {
        timerManager?.stop()

        circularGradientCountdownAnimation?.pause()
    }
    
    func resumeCountdown() {
        circularGradientCountdownAnimation?.resume()
        
        timerManager?.adjustRemainingTimeForMilliseconds = true
        timerManager?.startMillisecondsTimer()
    }
    
    func stopCountdown() {
        invalidateTimer()
        delegate?.timerFinished(completedStages: stagesHandler?.completedStages ?? 0,
                                completedRests: stagesHandler?.completedRests ?? 0)
        stagesHandler = nil
        updateLabels()
        circularGradientCountdownAnimation?.stop()
        innerShadowView.layer.removeSublayer(name: "gradientWithMask")
    }
        
    func nextStage() {
        invalidateTimer()
        timerEnded()
    }
}

//MARK: - TimerManagerDelegate
extension CountdownView: TimerManagerDelegate {
    func remainingTimeUpdated() {
        updateTimeLabel()
    }
    
    func appWillEnterForeground() {
        startCircularGradientAnimation(withRemainingTime: true)
    }
    
    func timerEnded() {
        guard let stagesHandler = stagesHandler else { return }
        
        if stagesHandler.canAdvanceToNextStage() {
            stagesHandler.advanceToNextStage()
            startCountdown(totalSeconds: stagesHandler.secondsToNextStage)
        } else {
            stopCountdown()
        }
    }
}
