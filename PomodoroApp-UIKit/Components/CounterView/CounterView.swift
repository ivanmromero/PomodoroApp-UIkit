//
//  CounterView.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 24/06/2024.
//

import UIKit

final class CounterView: UIView {
    // MARK: @IBOutlets
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var counter: UILabel!
    @IBOutlet private weak var plusButton: UIButton!
    @IBOutlet private weak var minusButton: UIButton!
    
    // MARK: Properties
    let identifier: String = UUID().uuidString
    
    init(title: String, counter: String) {
        super.init(frame: .zero)
        self.setup()
        self.title.text = title
        self.counter.text = counter
    }
    
    // MARK: Initializations
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    // MARK: Override Funcs
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.layer.updateShadowsOnLayout(for: .inner)
        minusButton.layer.updateShadowsOnLayout(for: .outer)
        plusButton.layer.updateShadowsOnLayout(for: .outer)
    }
    
    // MARK: Setups
    private func setup() {
        instantiateCustomViewOnNib(name: self.name)
        setup(minusButton)
        setup(plusButton)
        setupLayer()
    }
    
    private func setupLayer() {
        self.addDefaultShadow(for: .inner, cornerRadius: 10)
    }
    
    private func setup(_ button: UIButton) {
        button.addDefaultShadow(for: .outer, cornerRadius: 10)
        setGradientImage(for: button)
    }
    
    private func setGradientImage(for button: UIButton) {
        guard let imageView = button.imageView else { return  }
        
        switch button {
        case plusButton:
            button.setImage(imageView.image?.gradientImage([.systemPurple, .systemPink]), for: .normal)
            button.setImage(imageView.image?.gradientImage([.systemPink, .systemPurple]), for: .highlighted)
        case minusButton:
            button.setImage(imageView.image?.gradientImage([.systemPurple, .systemPink], heightPercentAdjust: 0.7), for: .normal)
            button.setImage(imageView.image?.gradientImage([.systemPink, .systemPurple], heightPercentAdjust: 0.7), for: .highlighted)
        default:
            return
        }
    }
    
    // MARK: @IBActions
    @IBAction func counterTapped(_ sender: UIButton) {
        changeCounterText(for: sender)
        
        NotificationCenter.default.post(name: NSNotification.Name(identifier), object: self)
    }
    
    private func changeCounterText(for buttonPressed: UIButton) {
        guard let counterText = counter.text,
              let counterNumber = Int(counterText)
        else { return }
        
        let finalCounter: String
        
        switch buttonPressed {
        case plusButton:
            finalCounter = String(counterNumber + 1)
        case minusButton:
            finalCounter = String(counterNumber - 1)
        default:
            return
        }
        
        counter.text = finalCounter
    }
}
