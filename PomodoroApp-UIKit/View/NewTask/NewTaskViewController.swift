//
//  NewTaskViewController.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 05/08/2024.
//

import UIKit

class NewTaskViewController: UIViewController {
    // MARK: @IBOutlets
    @IBOutlet weak var dissmissButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var taskTextView: UITextView!
    @IBOutlet weak var taskTextViewInnerShadow: UIView!
    @IBOutlet weak var dismissButtonBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var segmentedControlView: SegmentedControlView!
    
    // MARK: Private Properties
    private let newTaskViewModel = NewTaskViewModel()
    private var taskText: String?
    
    // MARK: Delegate
    weak var delegate: NewTaskViewControllerDelegate?
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    
        taskTextViewInnerShadow.layer.updateShadowsOnLayout(for: .inner)
        addButton.addDefaultShadow(for: .outer)
    }
    
    // MARK: Deinitializer
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Setups
    private func setup() {
        setupTaskTextView()
        setupAddButton()
        setupDissmissButton()
        addObservers()
    }
    
    private func setupAddButton() {
        addButton.setTitle("Add", for: .normal)
        addButton.applyGradientToTitle(colors: [.systemPurple, .systemPink])
    }
    
    private func setupDissmissButton() {
        dissmissButton.setImage(dissmissButton.imageView?.image?.gradientImage([.systemPurple, .systemPink]), for: .normal)
    }
    
    private func setupTaskTextView() {
        taskTextView.delegate = self
        taskTextViewInnerShadow.addDefaultShadow(for: .inner)
        taskTextView.textContainer.maximumNumberOfLines = 4
        taskTextView.becomeFirstResponder()
    }
    
    // MARK: Keyboard Handling
    private func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
           let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            let keyboardHeight = keyboardFrame.cgRectValue.height - (self.view.safeAreaInsets.bottom) / 2
            adjustAddButtonPosition(keyboardHeight: keyboardHeight, animationDuration: animationDuration)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double {
            adjustAddButtonPosition(keyboardHeight: 0, animationDuration: animationDuration)
        }
    }
    
    private func adjustAddButtonPosition(keyboardHeight: CGFloat, animationDuration: Double) {
        dismissButtonBottomConstraint.constant = keyboardHeight
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: @IBActions
    @IBAction func addButtonTapped(_ sender: UIButton) {
        guard let taskText = taskText,
              let taskType = segmentedControlView.selectedSegment,
              !taskText.isEmpty,
              !taskType.isEmpty,
              let newTaskViewModel = newTaskViewModel
        else { return }
        
        if newTaskViewModel.createTask(with: taskText, and: taskType) {
            dissmissTapped(dissmissButton as Any)
            delegate?.taskDidAdded(task: taskText, taskType: taskType)
        }
    }
    
    @IBAction func dissmissTapped(_ sender: Any) {
        dismiss(animated: true)
    }
}

// MARK: - UITextViewDelegate
extension NewTaskViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        self.taskText = textView.text
    }
}
