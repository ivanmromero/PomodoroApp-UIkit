//
//  CalendarView.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 03/10/2024.
//

import UIKit

final class CalendarView: UIView {
    // MARK: @IBOutlets
    @IBOutlet private weak var datePicker: UIDatePicker!
    @IBOutlet private weak var blurEffect: UIVisualEffectView!
    @IBOutlet private weak var todayButton: UIButton!
    
    // MARK: Private properties
    private let todayDate: Date = .init()
    private var lastSelectedDate: Date
    private var wasCalendarheaderTitleButtonTapped: Bool = false
    private var canPressSameDate: Bool = false
    
    // MARK: Delegate
    var delegate: CalendarViewDelegate?
    
    // MARK: Inits
    override init(frame: CGRect) {
        self.lastSelectedDate = todayDate
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        self.lastSelectedDate = todayDate
        super.init(coder: coder)
        setup()
    }
    
    // MARK: Lifecycle
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if superview != nil {
            setupConstraintsForCalendarView()
        }
    }
    
    // MARK: Setups
    private func setup() {
        instantiateCustomViewOnNib(name: self.name)
        setupCornerRadius()
        setupDatePicker()
        setupDatePickerInteractions()
    }
    
    private func setupCornerRadius() {
        self.blurEffect.layer.cornerRadius = 10
        self.blurEffect.layer.masksToBounds = true
    }
    
    private func setupDatePicker() {
        datePicker.maximumDate = todayDate
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
    
    private func setupConstraintsForCalendarView() {
        blurEffect.translatesAutoresizingMaskIntoConstraints = false
        
        if let constraints = delegate?.layoutConstraintsFor(datePicker: blurEffect) {
            NSLayoutConstraint.activate(constraints)
            
            return
        }
        
        NSLayoutConstraint.activate([
            blurEffect.centerXAnchor.constraint(equalTo: centerXAnchor),
            blurEffect.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func setupDatePickerInteractions() {
        setupCalendarHeaderTitleButtonInteraction()
        setupDatesCollectionViewInteractions()
    }
    
    private func setupCalendarHeaderTitleButtonInteraction() {
        guard let calendarHeaderTitleButton = datePicker.findSubviewFor(searchedViewName: "_UICalendarHeaderTitleButton") as? UIButton else { return }
        
        calendarHeaderTitleButton.addTarget(self, action: #selector(calendarHeaderTitleButtonTapped), for: .touchUpInside)
    }
    
    private func setupDatesCollectionViewInteractions() {
        guard let datesCollectionView = datePicker.findSubviewFor(searchedViewName: "UICollectionView") as? UICollectionView else { return }
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dateTapped))
        tapGestureRecognizer.cancelsTouchesInView = false
        
        datesCollectionView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    // MARK: Actions
    @IBAction func backgroundViewTapped(_ sender: UITapGestureRecognizer) {
        delegate?.backgroundTapped()
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        if !wasCalendarheaderTitleButtonTapped {
            lastSelectedDate = sender.date
            delegate?.didSelectDate(sender.date)
        }
    }
    
    @objc private func calendarHeaderTitleButtonTapped() {
        todayButton.isHidden = !wasCalendarheaderTitleButtonTapped
        canPressSameDate = true
        
        wasCalendarheaderTitleButtonTapped.toggle()
    }
    
    @objc private func dateTapped() {
        guard canPressSameDate,
              lastSelectedDate.isSame(.day, that: datePicker.date),
              (!lastSelectedDate.isSame(.month, that: datePicker.date) || !lastSelectedDate.isSame(.year, that: datePicker.date))
        else { return }
        
        datePickerValueChanged(datePicker)
        canPressSameDate = false
    }
    
    @IBAction func todayButtonTapped(_ sender: UIButton) {
        changeDate(to: todayDate)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            guard let self else { return }
            
            self.datePickerValueChanged(self.datePicker)
        }
    }

    // MARK: Modifiers
    func changeDate(to date: Date) {
        datePicker.date = date
    }
}
