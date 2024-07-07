//
//  UIViewController+Extension.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 11/06/2024.
//

import UIKit

extension UIViewController {    
    var navigationBarHeight: CGFloat {
        navigationController?.navigationBar.frame.height ?? 0
    }
    
    var navigationBarWidth: CGFloat {
        navigationController?.navigationBar.frame.width ?? 0
    }
    
    func setNavigationButton(position: NavigationButtonPosition, systemName: String, action: (() -> ())? = nil) {
        let navigationButton = NavigationButtonView()
        
        // set image
        navigationButton.navigationButtonImageView.image = UIImage(systemName: systemName)?.gradientImage([UIColor.systemPurple, UIColor.systemPink])?.withRenderingMode(.alwaysOriginal)

        // set frame
        navigationButton.frame = CGRect(x: 0, y: 0, width: navigationBarHeight, height: navigationBarHeight)
        
        // set action
        navigationButton.buttonAction = action ?? {}

        let barButtonItem = UIBarButtonItem(customView: navigationButton)
        
        switch position {
        case .left:
            self.navigationItem.leftBarButtonItem = barButtonItem
        case .right:
            self.navigationItem.rightBarButtonItem = barButtonItem
        }
    }
    
    enum NavigationButtonPosition {
        case left, right
    }
}
