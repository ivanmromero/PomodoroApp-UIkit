//
//  CALayer+Extension.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 26/06/2024.
//

import UIKit

extension CALayer {
    func addInnerShadow(shadowColor: UIColor = .clear,
                        shadowOffset: CGSize = CGSize(width: 0, height: 0),
                        shadowOpacity: Float = 0,
                        shadowRadius: CGFloat = 0) {
        let innerShadowLayer = CALayer()
        
        innerShadowLayer.updateFrame(with: bounds)
        innerShadowLayer.masksToBounds = true
        innerShadowLayer.shadowColor = shadowColor.cgColor
        innerShadowLayer.shadowOffset = shadowOffset
        innerShadowLayer.shadowOpacity = shadowOpacity
        innerShadowLayer.shadowRadius = shadowRadius
        innerShadowLayer.cornerRadius = cornerRadius
        
        addSublayer(innerShadowLayer)
    }
    
    func updateInnerShadowPath(edge: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
                               cornerRadius: CGFloat = 0) {
        let path = UIBezierPath(roundedRect: bounds.inset(by: edge), cornerRadius: cornerRadius)
        let cutout = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).reversing()
        path.append(cutout)
        shadowPath = path.cgPath
    }
    
    func updateFrame(with bounds: CGRect) {
        frame = bounds
    }
    
    func addOuterShadow(shadowColor: UIColor? = nil,
                        shadowOpacity: Float = 0.0,
                        shadowOffset: CGSize = CGSize(width: 0, height: 0),
                        shadowRadius: CGFloat = 3.0) {
        let outerShadowLayer = CALayer()
        
        outerShadowLayer.updateFrame(with: bounds)
        outerShadowLayer.masksToBounds = false
        outerShadowLayer.shadowColor = shadowColor?.cgColor
        outerShadowLayer.shadowOpacity = shadowOpacity
        outerShadowLayer.shadowOffset = shadowOffset
        outerShadowLayer.shadowRadius = shadowRadius
        
        insertSublayer(outerShadowLayer, at: 0)
    }
    
    func updateOuterShadowPath(edge: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0),
                               cornerRadius: CGFloat = 0) {
        shadowPath = UIBezierPath(roundedRect: bounds.inset(by: edge), cornerRadius: cornerRadius).cgPath
    }
    
    func addBaseLayer() {
        let baseLayer = CALayer()
        baseLayer.backgroundColor = backgroundColor
        baseLayer.cornerRadius = cornerRadius
        
        insertSublayer(baseLayer, at: 0)
    }
}
