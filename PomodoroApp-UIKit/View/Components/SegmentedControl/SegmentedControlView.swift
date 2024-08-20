//
//  SegmentedControl.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 07/08/2024.
//

import UIKit

@IBDesignable
class SegmentedControlView: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var stackView: UIStackView!
    
    private var selectedSegmentView = UIView()
    private var selectedSegmentViewHasSet: Bool = false
    private(set) var selectedSegment: String?
    
    private var buttons: [UIButton] = [] {
        didSet {
            buttons.forEach { stackView.addArrangedSubview($0) }
        }
    }
    
    private var segmentTitles: [String] = [] {
        didSet {
            setTitles()
        }
    }
    
    @IBInspectable var quantitySegments: Int = 0 {
        didSet {
            setButtons()
        }
    }
    
    @IBInspectable var segmentTitlesByComma: String = "" {
        didSet {
            guard !segmentTitlesByComma.isEmpty  else { return }
            
            segmentTitles = segmentTitlesByComma.components(separatedBy: ",")
            selectedSegment = segmentTitles.first
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        buttons.forEach { button in
            button.applyGradientToTitle()
        }
        self.addDefaultShadow(for: .inner)
        setupSegmentedControl()
    }
    
    private func setup() {
        instantiateCustomViewOnNib(name: self.name)
    }
    
    private func setButtons() {
        var buttons: [UIButton] = []
        
        for _ in 0..<quantitySegments {
            let button = UIButton(type: .system)
            button.addTarget(self, action: #selector(buttonTapped(buttonTapped: )) , for: .touchUpInside)
            button.backgroundColor = .clear
            buttons.append(button)
        }
        
        self.buttons = buttons
    }
    
    private func setupSegmentedControl() {
        if !selectedSegmentViewHasSet {
            let positionX = ((contentView.bounds.width / CGFloat(quantitySegments)) * 0.2) / 2
            let positionY = (contentView.bounds.height * 0.3) / 2
            let width = (contentView.bounds.width / CGFloat(quantitySegments)) * 0.8
            let height = (contentView.bounds.height) * 0.7
            
            let selectedSegmentView = UIView(frame: CGRect(x: positionX, y: positionY, width: width, height: height))
            selectedSegmentView.backgroundColor = .baseBackground
            selectedSegmentView.addDefaultShadow(for: .outer)
            
            contentView.insertSubview(selectedSegmentView, at: 0)
            contentView.clipsToBounds = true
            
            self.selectedSegmentView = selectedSegmentView
            
            selectedSegmentViewHasSet = true
        }
    }
    
    private func setTitles() {
        for index in 0..<buttons.count where buttons.count == segmentTitles.count {
            buttons[index].setTitle(segmentTitles[index], for: .normal)
        }
    }
    
    @objc func buttonTapped(buttonTapped: UIButton) {
        moveSelectedSegmentView(for: buttonTapped)
        selectedSegment = buttonTapped.titleLabel?.text
    }
    
    private func moveSelectedSegmentView(for buttonTapped: UIButton) {
        for (index, button) in buttons.enumerated() where buttonTapped.titleLabel?.text == button.titleLabel?.text {
            
            let positionToMove = (contentView.bounds.width /  CGFloat(quantitySegments)) * CGFloat(index)
            let extraLeading = ((contentView.bounds.width / CGFloat(quantitySegments)) * 0.2) / 2
            let finalPositionToMove = positionToMove + extraLeading
            
            
            UIView.animate(withDuration: 0.3) {
                self.selectedSegmentView.frame.origin.x = finalPositionToMove
            }
        }
    }
}
