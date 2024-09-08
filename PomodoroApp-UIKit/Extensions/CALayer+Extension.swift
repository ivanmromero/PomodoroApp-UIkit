//
//  CALayer+Extension.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 26/06/2024.
//

import UIKit

extension CALayer {
    func updateFrame(with bounds: CGRect) {
        frame = bounds
    }
    
    func addBaseLayer() {
        let baseLayer = CALayer()
        baseLayer.backgroundColor = backgroundColor
        baseLayer.cornerRadius = cornerRadius
        
        insertSublayer(baseLayer, at: 0)
    }
    
    func addInnerShadow(shadowColor: UIColor = .clear,
                        shadowOffset: CGSize = CGSize(width: 0, height: 0),
                        shadowOpacity: Float = 0,
                        shadowRadius: CGFloat = 0,
                        identifier: String = ShadowType.inner.rawValue) {
        let innerShadowLayer = CALayer()
        
        innerShadowLayer.updateFrame(with: bounds)
        innerShadowLayer.masksToBounds = true
        innerShadowLayer.shadowColor = shadowColor.cgColor
        innerShadowLayer.shadowOffset = shadowOffset
        innerShadowLayer.shadowOpacity = shadowOpacity
        innerShadowLayer.shadowRadius = shadowRadius
        innerShadowLayer.cornerRadius = cornerRadius
        innerShadowLayer.name = identifier
        
        addSublayer(innerShadowLayer)
    }
    
    func addOuterShadow(shadowColor: UIColor? = nil,
                        shadowOpacity: Float = 0.0,
                        shadowOffset: CGSize = CGSize(width: 0, height: 0),
                        shadowRadius: CGFloat = 3.0,
                        identifier: String = ShadowType.outer.rawValue) {
        let outerShadowLayer = CALayer()
        
        outerShadowLayer.updateFrame(with: bounds)
        outerShadowLayer.masksToBounds = false
        outerShadowLayer.shadowColor = shadowColor?.cgColor
        outerShadowLayer.shadowOpacity = shadowOpacity
        outerShadowLayer.shadowOffset = shadowOffset
        outerShadowLayer.shadowRadius = shadowRadius
        outerShadowLayer.name = identifier
        
        insertSublayer(outerShadowLayer, at: 0)
    }
    
    func updateShadowsOnLayout(for shadowType: ShadowType) {
        sublayers?.forEach { sublayer in
            guard let shadowColor = sublayer.shadowColor else { return }
            
            sublayer.updateShadow(type: shadowType,
                                  color: shadowColor,
                                  bounds: bounds,
                                  cornerRadius: cornerRadius)
        }
    }
    
    private func updateShadow(type: ShadowType,
                              color: CGColor,
                              bounds: CGRect,
                              cornerRadius: CGFloat) {
        updateFrame(with: bounds)
        
        switch type {
        case .inner:
            updateInnerShadowPath(edge: getDefaultEdge(for: .inner, and: color),
                                  cornerRadius: cornerRadius)
        case .outer:
            updateOuterShadowPath(edge: getDefaultEdge(for: .outer, and: color),
                                  cornerRadius: cornerRadius)
        }
    }
    
    private func getDefaultEdge(for shadowType: ShadowType, and color: CGColor) -> UIEdgeInsets {
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
    
    private func updateOuterShadowPath(edge: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
                                       cornerRadius: CGFloat = 0) {
        shadowPath = UIBezierPath(roundedRect: bounds.inset(by: edge), cornerRadius: cornerRadius).cgPath
    }
    
    private func updateInnerShadowPath(edge: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
                                       cornerRadius: CGFloat = 0) {
        let path = UIBezierPath(roundedRect: bounds.inset(by: edge), cornerRadius: cornerRadius)
        let cutout = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).reversing()
        path.append(cutout)
        shadowPath = path.cgPath
    }
    
    func removeSublayer(name: String) {
        guard let sublayers = self.sublayers else { return }
        
        if let layerToRemove = sublayers.first(where: { $0.name == name }) {
            layerToRemove.removeFromSuperlayer()
        }
    }
}
