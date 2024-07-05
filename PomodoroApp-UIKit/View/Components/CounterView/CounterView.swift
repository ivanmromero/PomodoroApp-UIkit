//
//  CounterView.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 24/06/2024.
//

import UIKit

class CounterView: UIView {
    let identifier: String = UUID().uuidString
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var counter: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    
    init(title: String, counter: String) {
        super.init(frame: .zero)
        self.setup()
        self.title.text = title
        self.counter.text = counter
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateShadowsOnLayout(layer: self.layer, for: .inner)
        updateShadowsOnLayout(layer: minusButton.layer, for: .outer)
        updateShadowsOnLayout(layer: plusButton.layer, for: .outer)
    }
    
    private func setup() {
        instantiateCustomViewOnNib(name: self.name)
        setup(minusButton)
        setup(plusButton)
        setupLayer()
    }
    
    private func setupLayer() {
        self.layer.cornerRadius = 10
        self.layer.masksToBounds = true
        
        self.layer.addInnerShadow(shadowColor: .black,
                                  shadowOpacity: 0.4,
                                  shadowRadius: 3)
        
        self.layer.addInnerShadow(shadowColor: .white,
                                  shadowOpacity: 0.8,
                                  shadowRadius: 4)
    }
    
    private func setup(_ button: UIButton) {
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.adjustsFontSizeToFitWidth = false
        button.titleLabel?.lineBreakMode = .byClipping
        button.layer.cornerRadius = 10
        
        button.layer.addBaseLayer()
        
        button.layer.addOuterShadow(shadowColor: .black,
                                    shadowOpacity: 0.2,
                                    shadowOffset: CGSize(width: 4, height: 4),
                                    shadowRadius: 6)
        
        button.layer.addOuterShadow(shadowColor: .white,
                                    shadowOpacity: 1,
                                    shadowOffset: CGSize(width: -1, height: -1),
                                    shadowRadius: 4)
        
        
        gradientButtonImage(button: button)
    }
    
    private func gradientButtonImage(button: UIButton) {
        guard let imageView =  button.imageView else { return  }
        
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
    
    private func updateShadowsOnLayout(layer: CALayer, for shadowType: ShadowType) {
        layer.sublayers?.forEach { sublayer in
            guard let shadowColor = sublayer.shadowColor else { return }
            
            updateShadow(type: shadowType,
                         layer: sublayer,
                         color: shadowColor,
                         bounds: layer.bounds,
                         cornerRadius: layer.cornerRadius)
        }
    }
    
    private func updateShadow(type: ShadowType,
                              layer: CALayer,
                              color: CGColor,
                              bounds: CGRect,
                              cornerRadius: CGFloat) {
        layer.updateFrame(with: bounds)
        
        switch type {
        case .inner:
            layer.updateInnerShadowPath(edge: getEdge(for: .inner, and: color), cornerRadius: cornerRadius)
        case .outer:
            layer.updateOuterShadowPath(edge: getEdge(for: .outer, and: color), cornerRadius: cornerRadius)
        }
    }
    
    private func getEdge(for shadowType: ShadowType, and color: CGColor) -> UIEdgeInsets {
        switch (shadowType, color) {
        case (.inner, UIColor.black.cgColor):
            return UIEdgeInsets(top: 1, left: 0, bottom: 0, right: 1)
        case (.inner, UIColor.white.cgColor):
            return UIEdgeInsets(top: 0, left: 3, bottom: 3, right: 0)
        case (.outer, UIColor.black.cgColor):
            return UIEdgeInsets(top: 2, left: 2, bottom: 0, right: 0)
        case (.outer, UIColor.white.cgColor):
            return UIEdgeInsets(top: 0, left: 0, bottom: 1, right: 1)
        default:
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    @IBAction func counterTapped(_ sender: UIButton) {
        changeCounterText(for: sender)
        
        NotificationCenter.default.post(name: NSNotification.Name(identifier), object: self)
    }
    
    private func changeCounterText(for buttonPressed: UIButton) {
        guard let counterText = counter.text,
              let counterNumber = Int(counterText)
        else { return }
        
        switch buttonPressed {
        case plusButton:
            counter.text = String(counterNumber + 1)
        case minusButton:
            counter.text = String(counterNumber - 1)
        default:
            return
        }
    }
}

