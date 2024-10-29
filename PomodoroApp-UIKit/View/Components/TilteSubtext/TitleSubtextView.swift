//
//  TitleSubtextView.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 07/07/2024.
//

import UIKit

@IBDesignable
final class TitleSubtextView: UIView {
    // MARK: @IBOutlets
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtextLabel: UILabel!
    @IBOutlet private weak var stackView: UIStackView!
    
    // MARK: @IBInspectables
    @IBInspectable var titleText: String = "title" {
        didSet {
            titleLabel?.text = titleText
        }
    }
    
    @IBInspectable var subtextText: String = "subtext" {
        didSet {
            subtextLabel?.text = subtextText
        }
    }
    
    @IBInspectable var axisRawValue: Int = 0 {
        didSet {
            stackView?.axis = axis
            prepare(for: axis)
        }
    }
    
    private var axis: NSLayoutConstraint.Axis {
        axisRawValue == 0 ? .vertical : .horizontal
    }
    
    // MARK: TitleSubtext Components
    enum TitleSubtextComponent {
        case title, subtext
    }
    
    // MARK: Initializations
    init(titleText: String, subtext: String, axis: NSLayoutConstraint.Axis) {
        super.init(frame: .zero)
        instantiateCustomViewOnNib(name: name)
        titleLabel.text = titleText
        subtextLabel.text = subtext
        stackView.axis = axis
        prepare(for: axis)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        instantiateCustomViewOnNib(name: name)
    }
        
    // MARK: Setups
    private func prepare(for axis: NSLayoutConstraint.Axis) {
        axis == .horizontal ? prepareForHorizontalAxis() : prepareForVerticalAxis()
    }
    
    private func prepareForVerticalAxis() {
        stackView?.spacing = 3
        titleLabel?.textAlignment = .center
        titleLabel?.font = titleLabel.font.withSize(20)
        subtextLabel?.textAlignment = .center
    }
    
    private func prepareForHorizontalAxis() {
        stackView?.spacing = 20
        titleLabel?.textAlignment = .left
        titleLabel?.font = titleLabel.font.withSize(30)
        subtextLabel?.textAlignment = .left
    }
    
    private func getLabel(for component: TitleSubtextComponent) -> UILabel {
        component == .title ? titleLabel : subtextLabel
    }
    
    // MARK: Modifiers
    func change(fontSize: CGFloat, for component: TitleSubtextComponent) {
        let component = getLabel(for: component)
        
        component.font = component.font.withSize(fontSize)
    }
    
    func change(text: String,for component: TitleSubtextComponent) {
        getLabel(for: component).text = text
    }
    
    func change(numberOfLines: Int, for component: TitleSubtextComponent) {
        getLabel(for: component).numberOfLines = numberOfLines
    }
    
    func change(adjustsFontSizeToFitWidth: Bool, for component: TitleSubtextComponent) {
        getLabel(for: component).adjustsFontSizeToFitWidth = adjustsFontSizeToFitWidth
    }
    
    func change(lineBreakMode: NSLineBreakMode, for component: TitleSubtextComponent) {
        getLabel(for: component).lineBreakMode = .byTruncatingTail
    }
    
    func change(spacing: CGFloat) {
        stackView?.spacing = spacing
    }
}
