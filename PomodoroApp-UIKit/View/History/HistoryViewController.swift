//
//  HistoryViewController.swift
//  PomodoroApp-UIKit
//
//  Created by Ivan Romero on 11/06/2024.
//

import UIKit

final class HistoryViewController: UIViewController {
    // MARK: @IBOutlet
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var calendarButton: UIButton!
    @IBOutlet private weak var innerShadow: UIView!
    @IBOutlet private weak var dateText: UILabel!

    // MARK: ViewModel
    private let viewModel: HistoryViewModel? = .init()

    // MARK: Private properties
    private var wasInnerShadowUpdated: Bool = false
    private var selectedDate: Date = Date()
    private var tableViewContentSize: CGSize {
        self.tableView.contentSize
    }
    
    // MARK: Lazy properties
    private lazy var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .none
        
        return dateFormatter
    }()
    
    private lazy var dropdownCalendarView: UIView = {
        let view = CalendarView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        view.alpha = 0
        
        self.view.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.view.topAnchor),
            view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor)
        ])
            
        return view
    }()
    
    // MARK: Lifecycle
    deinit {
        tableView.removeObserver(self, forKeyPath: "contentSize")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        updateHeightOfInnerShadow()
        innerShadow.layer.updateShadowsOnLayout(for: .inner)
        dateText.layer.updateShadowsOnLayout(for: .inner)
        calendarButton.layer.updateShadowsOnLayout(for: .outer)
    }
    
    // MARK: Setups
    private func setup() {
        setupNavigationBar()
        setupDateText()
        setupCalenderButton()
        setupTableView()
        setupInnerShadow()
    }
    
    private func setupNavigationBar() {
        setNavigationButton(position: .left, systemName: "arrowshape.turn.up.backward") { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
        
        self.title = "History"
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "TaskDetailTableViewCell", bundle: .main), forCellReuseIdentifier: "taskdetailcell")
        
        tableView.addObserver(self, forKeyPath: "contentSize", options: [.new, .old], context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == "contentSize" else { return }
        
        updateHeightOfInnerShadow()
        innerShadow.layer.updateShadowsOnLayout(for: .inner)
        self.view.layoutIfNeeded()
    }
    
    private func updateHeightOfInnerShadow() {
        innerShadow.frame.size.height = tableViewContentSize.height + 20
    }
    
    private func setupDateText() {
        dateText.addDefaultShadow(for: .inner)
        dateText.text = dateFormatter.string(from: Date())
    }
    
    private func setupInnerShadow() {
        innerShadow.addDefaultShadow(for: .inner)
    }
    
    private func setupCalenderButton() {
        calendarButton.setTitle("", for: .normal)
        calendarButton.addDefaultShadow(for: .outer, cornerRadius: 10)
        setGradientImage(for: calendarButton)
    }

    private func setGradientImage(for button: UIButton) {
        guard let imageView = button.imageView else { return  }
        button.setImage(imageView.image?.gradientImage([.systemPurple, .systemPink]), for: .normal)
        button.setImage(imageView.image?.gradientImage([.systemPink, .systemPurple]), for: .highlighted)
    }
    
    // MARK: Actions
    @IBAction func calendarButtonTapped(_ sender: Any) {
        if self.dropdownCalendarView.isHidden {
            showDropdownCalendarWithAnimation()
        } else {
            hideDropdownCalendarWithAnimation()
        }
    }
    
    private func showDropdownCalendarWithAnimation() {
        UIView.animate(withDuration: 0.5) {
            self.dropdownCalendarView.isHidden = false
            self.dropdownCalendarView.alpha = 1
            self.dropdownCalendarView.layoutIfNeeded()
        }
    }
    
    private func hideDropdownCalendarWithAnimation() {
        UIView.animate(withDuration: 0.5, animations: {
            self.dropdownCalendarView.alpha = 0
        }, completion: { _ in
            self.dropdownCalendarView.isHidden = true
        })
    }
}

// MARK: - UITableViewDataSource
extension HistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel?.getTasks(for: selectedDate)?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "taskdetailcell", for: indexPath) as? TaskDetailTableViewCell
        else {
            return UITableViewCell()
        }
        
        let task = viewModel?.getTask(for: selectedDate, and: indexPath.row)
        
        cell.title = task?.task
        cell.subtitle = task?.type
        cell.delegate = self
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HistoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        false
    }
}

// MARK: - CellDeletionDelegate
extension HistoryViewController: CellDeletionDelegate {
    func translate(cell: UITableViewCell, to translation: CGPoint) {
        tableView?.isScrollEnabled = false
    }
    
    func translationEnded(cell: UITableViewCell) {
        tableView?.isScrollEnabled = true
    }
    
    func didRequestDeletion(cell: UITableViewCell) {
        guard let indexPath = tableView?.indexPath(for: cell) else { return }
        
        do {
            try self.viewModel?.deleteTask(for: self.selectedDate, and: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } catch {
            print(error.localizedDescription)
        }
    }
}

// MARK: - CalendarViewDelegate
extension HistoryViewController: CalendarViewDelegate {
    func layoutConstraintsFor(datePicker: UIView) -> [NSLayoutConstraint]? {
        [datePicker.topAnchor.constraint(equalTo: self.calendarButton.bottomAnchor, constant: 10),
         datePicker.trailingAnchor.constraint(equalTo:  self.view.safeAreaLayoutGuide.trailingAnchor, constant: -20)]
    }
    
    func didSelectDate(_ date: Date) {
        selectedDate = date
        dateText.text = dateFormatter.string(from: date)
        hideDropdownCalendarWithAnimation()
        tableView.reloadData()
    }
    
    func backgroundTapped() {
        if !self.dropdownCalendarView.isHidden {
            self.hideDropdownCalendarWithAnimation()
        }
    }
}
