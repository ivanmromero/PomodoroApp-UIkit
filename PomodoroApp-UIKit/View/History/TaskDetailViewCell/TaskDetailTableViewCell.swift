//
//  TaskDetailTableViewCell.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 05/10/2024.
//

import UIKit

final class TaskDetailTableViewCell: UITableViewCell {
    // MARK: @IBOutlets
    @IBOutlet private weak var titleSubtextView: TitleSubtextView!
    @IBOutlet private weak var outerShadowView: UIView!
    
    // MARK: Private Properties
    private let deleteView = UIView()
    private var originalCenter: CGPoint = .zero
    private var deleteViewWidthConstraint: NSLayoutConstraint?
    private var deleteMaxWidth: CGFloat { self.bounds.width }
    private var panGesture: UIPanGestureRecognizer?
    
    // MARK: Delegate
    weak var delegate: CellDeletionDelegate?
    
    // MARK: Internal Properties
    var title: String? {
        didSet {
            if let title,
               !title.isEmpty {
                titleSubtextView.titleText = title
            }
        }
    }
    
    var subtitle: String? {
        didSet {
            if let subtitle,
               !subtitle.isEmpty {
                titleSubtextView.subtextText = subtitle
            }
        }
    }
    
    // MARK: Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        setupOuterShadow()
    }
    
    override func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
    
    // MARK: Setups
    private func setup() {
        setupTitleSubtextView()
        setupDeleteView()
        setupPanGesture()
    }
    
    private func setupOuterShadow() {
        outerShadowView.addDefaultShadow(for: .outer)
    }
    
    private func setupTitleSubtextView() {
        titleSubtextView.change(numberOfLines: 1, for: .title)
        titleSubtextView.change(numberOfLines: 1, for: .subtext)
        titleSubtextView.change(adjustsFontSizeToFitWidth: false, for: .title)
        titleSubtextView.change(lineBreakMode: .byTruncatingTail, for: .title)
        titleSubtextView.change(spacing: 10)
    }
    
    private func setupDeleteView() {
        deleteView.backgroundColor = .systemRed
        deleteView.translatesAutoresizingMaskIntoConstraints = false
        deleteView.layer.cornerRadius = 10
        deleteView.frame.size.width = 0
        addTrashImage()
        
        addSubview(deleteView)
        
        deleteViewWidthConstraint = deleteView.widthAnchor.constraint(equalToConstant: 0)
        
        
        NSLayoutConstraint.activate([deleteView.centerYAnchor.constraint(equalTo: outerShadowView.centerYAnchor),
                                     deleteView.leadingAnchor.constraint(equalTo: outerShadowView.trailingAnchor, constant: 15),
                                     deleteViewWidthConstraint!,
                                     deleteView.heightAnchor.constraint(equalTo: outerShadowView.heightAnchor)])
    }
    
    private func addTrashImage() {
        let image = UIImage(systemName: "trash")
        let imageView = UIImageView(image: image)
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        deleteView.addSubview(imageView)
        
        NSLayoutConstraint.activate([imageView.centerYAnchor.constraint(equalTo: deleteView.centerYAnchor),
                                     imageView.leadingAnchor.constraint(equalTo: deleteView.leadingAnchor, constant: 20),
                                     imageView.heightAnchor.constraint(equalTo: deleteView.heightAnchor, multiplier: 0.4),
                                     imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor)])
    }

    private func setupPanGesture() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        panGesture?.delegate = self
        self.addGestureRecognizer(panGesture!)
    }
    
    // MARK: Pan Handle
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: self)
        
        switch gesture.state {
        case .began:
            originalCenter = center
        case .changed:
            switch shouldTraslateView(translation: translation) {
            case true:
                self.delegate?.translate(cell: self, to: translation)
                updateCenter(with: translation)
                updateDeleteViewWidthConstant(with: translation)
                layoutIfNeeded()
            case false:
                animateToOriginalPosition()
            }
        case .ended:
            switch hasMovedEnough()  {
            case true:
                animateDelete()
            case false:
                animateToOriginalPosition()
            }
        default:
            break
        }
    }
    
    private func shouldTraslateView(translation: CGPoint) -> Bool {
        translation.x < 0 && abs(translation.x) > abs(translation.y)
    }
    
    private func updateCenter(with translation: CGPoint) {
        center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y)
    }
    
    private func updateDeleteViewWidthConstant(with translation: CGPoint) {
        deleteViewWidthConstraint?.constant = abs(translation.x)
    }
    
    private func hasMovedEnough() -> Bool {
        originalCenter.x - center.x > bounds.width / 2
    }

    // MARK: Delete Animation
    private func animateDelete() {
        UIView.animate(withDuration: 0.2) {
            while self.deleteViewWidthConstraint?.constant ?? 0 < self.deleteMaxWidth {
                self.center = CGPoint(x: self.center.x - 1, y: self.originalCenter.y)
                self.deleteViewWidthConstraint?.constant += 1
                self.layoutIfNeeded()
            }
        } completion: { _ in
            self.outerShadowView.isHidden = true
            self.delegate?.translationEnded(cell: self)
            self.delegate?.didRequestDeletion(cell: self)
        }
    }
    
    // MARK: Reposition Animation
    private func animateToOriginalPosition() {
        UIView.animate(withDuration: 0.3) {
            self.center = self.originalCenter
        } completion: { _ in
            self.delegate?.translationEnded(cell: self)
        }
    }
}
