//
//  UIView+Extension.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 11/06/2024.
//

import UIKit

extension UIView {
    func instantiateCustomViewOnNib(name: String) {
        let nib = UINib(nibName: name, bundle: nil)
        guard let customView = nib.instantiate(withOwner: self).first as? UIView else {
            fatalError("Error instantiating CustomView: \(name)")
        }
        customView.frame = self.bounds
        customView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        customView.translatesAutoresizingMaskIntoConstraints = true
        addSubview(customView)
    }
    
    var name: String {
        return String(describing: type(of: self))
    }
    
    func addDefaultShadow(for shadowType: ShadowType, cornerRadius: CGFloat = 10) {
        layer.cornerRadius = cornerRadius
        switch shadowType {
        case .inner:
            addDefaultInnerShadow()
        case .outer:
            addDefaultOuterShadow()
        }
    }
    
    private func addDefaultOuterShadow() {
        layer.addBaseLayer()
        
        layer.addOuterShadow(shadowColor: .black,
                             shadowOpacity: 0.2,
                             shadowOffset: CGSize(width: 4, height: 4),
                             shadowRadius: 6)

        layer.addOuterShadow(shadowColor: .white,
                             shadowOpacity: 1,
                             shadowOffset: CGSize(width: -1, height: -1),
                             shadowRadius: 4)
        
        layer.updateShadowsOnLayout(for: .outer)
    }
    
    private func addDefaultInnerShadow() {
        layer.addInnerShadow(shadowColor: .black,
                             shadowOpacity: 0.4,
                             shadowRadius: 3)
        
        layer.addInnerShadow(shadowColor: .white,
                             shadowOpacity: 0.8,
                             shadowRadius: 4)
        
        layer.updateShadowsOnLayout(for: .inner)
    }
}
