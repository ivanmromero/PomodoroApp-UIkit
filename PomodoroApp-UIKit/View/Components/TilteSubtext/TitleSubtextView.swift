//
//  TitleSubtextView.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 07/07/2024.
//

import UIKit

class TitleSubtextView: UIView {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtextLabel: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    
    init(titleText: String, subtext: String, axis: NSLayoutConstraint.Axis) {
        super.init(frame: .zero)
        instantiateCustomViewOnNib(name: name)
        titleLabel.text = titleText
        subtextLabel.text = subtext
        stackView.axis = axis
        prepare(for: axis)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func change(fontSize: CGFloat, for component: TitleSubtextComponent) {
        let component = getLabel(for: component)
        
        component.font = component.font.withSize(fontSize)
    }
    
    func change(text: String,for component: TitleSubtextComponent) {
        let component = getLabel(for: component)
        
        component.text = text
    }
    
    private func prepare(for axis: NSLayoutConstraint.Axis) {
        axis == .horizontal ? prepareForHorizontalAxis() : prepareForVerticalAxis()
    }
    
    private func prepareForVerticalAxis() {
        stackView.spacing = 3
        titleLabel.textAlignment = .center
        subtextLabel.textAlignment = .center
    }
    
    private func prepareForHorizontalAxis() {
        stackView.spacing = 20
        titleLabel.textAlignment = .left
        subtextLabel.textAlignment = .left
    }
    
    private func getLabel(for component: TitleSubtextComponent) -> UILabel {
        component == .title ? titleLabel : subtextLabel
    }
    
    enum TitleSubtextComponent {
        case title, subtext
    }
}
