//
//  CellDeletionDelegate.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 28/10/2024.
//

import UIKit

protocol CellDeletionDelegate: AnyObject {
    func translate(cell: UITableViewCell, to translation: CGPoint)
    func translationEnded(cell: UITableViewCell)
    func didRequestDeletion(cell: UITableViewCell)
}
