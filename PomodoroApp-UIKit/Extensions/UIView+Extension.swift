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
        addSubview(customView)
    }
    
    var name: String {
        return String(describing: type(of: self))
    }
}
