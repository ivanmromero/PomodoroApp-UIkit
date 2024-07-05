//
//  UIImage+Extension.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 11/06/2024.
//

import UIKit

extension UIImage {
    func gradientImage(_ colors: [UIColor], heightPercentAdjust: CGFloat = 1.0) -> UIImage? {
        guard let source = withRenderingMode(.alwaysTemplate).cgImage else {
            return nil
        }
        // Create gradient
        let cgColors = colors.map({ $0.cgColor })
        let colors = cgColors as CFArray
        let space = CGColorSpaceCreateDeviceRGB()
        
        guard let gradient = CGGradient(colorsSpace: space,
                                        colors: colors,
                                        locations: nil)
        else {
            return nil
        }
        
        let size = CGSize(width: size.width, height: size.height * heightPercentAdjust)
        
        let renderer = UIGraphicsImageRenderer(bounds: CGRect(origin: .zero, size: size))
        return renderer.image { (context) in
            let context = context.cgContext
            context.translateBy(x: 0, y: size.height)
            context.scaleBy(x: 1.0, y: -1.0)
            
            context.setBlendMode(.normal)
            let rect = CGRect.init(x: 0, y: 0, width: size.width, height: size.height)
            
            // Apply gradient
            context.clip(to: rect, mask: source)
            
            context.drawLinearGradient(gradient,
                                       start: CGPoint(x: 0, y: size.height),
                                       end: CGPoint(x: size.width, y: 0),
                                       options: .drawsAfterEndLocation)
        }
    }
}
