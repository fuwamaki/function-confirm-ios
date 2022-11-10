//
//  SampleCalendarViewController.swift
//  FunctionConfirm
//
//  Created by fuwamaki on 2022/06/08.
//  Copyright © 2022 fuwamaki. All rights reserved.
//

import UIKit

final class SampleCalendarViewController: UIViewController {

    let dateComponents: [DateComponents] = []
    var dateComponent: DateComponents?
//    var dateComponent: DateComponents = DateComponents(year: 2022, month: 6, day: 20)

    // memo: StoryboardではUICalendarViewのcomponentがない
    override func viewDidLoad() {
        super.viewDidLoad()
        let calendarView = UICalendarView()
        // これがないと表示されない。ソースコードでAutoLayout設定をするのに必須
        calendarView.translatesAutoresizingMaskIntoConstraints = false
//        calendarView.delegate = self
        calendarView.availableDateRange = DateInterval(start: .now, end: .now.addingTimeInterval(40*24*3600))
        view.addSubview(calendarView)
        NSLayoutConstraint.activate([
            self.view.topAnchor.constraint(equalTo: calendarView.topAnchor),
            self.view.leftAnchor.constraint(equalTo: calendarView.leftAnchor),
            self.view.rightAnchor.constraint(equalTo: calendarView.rightAnchor)
        ])
        let selection = UICalendarSelectionSingleDate(delegate: self)
        selection.selectedDate = dateComponent
        calendarView.selectionBehavior = selection
//        let selection = UICalendarSelectionMultiDate(delegate: self)
//        selection.selectedDates = dateComponents
//        calendarView.selectionBehavior = selection

//        navigationItem.hidesBackButton = true
    }
}

extension SampleCalendarViewController: UICalendarSelectionSingleDateDelegate {
    func dateSelection(
        _ selection: UICalendarSelectionSingleDate,
        didSelectDate dateComponents: DateComponents?
    ) {}
}

extension SampleCalendarViewController: UICalendarSelectionMultiDateDelegate {
    func multiDateSelection(
        _ selection: UICalendarSelectionMultiDate,
        didSelectDate dateComponents: DateComponents
    ) {}

    func multiDateSelection(
        _ selection: UICalendarSelectionMultiDate,
        didDeselectDate dateComponents: DateComponents
    ) {}
}

extension SampleCalendarViewController: UICalendarViewDelegate {
    // swiftlint:disable cyclomatic_complexity
    func calendarView(
        _ calendarView: UICalendarView,
        decorationFor dateComponents: DateComponents
    ) -> UICalendarView.Decoration? {
        switch dateComponents.day {
        case 1: return .default()
        case 2: return .default(color: .red)
        case 3: return .default(color: .blue)
        case 4: return .default(color: .yellow)
        case 5: return .image(UIImage.init(systemName: "doc.text"))
        case 6: return .image(UIImage.init(systemName: "calendar"), color: .systemPink)
        case 7: return .image(UIImage.init(systemName: "calendar"), color: .systemPink, size: .small)
        case 8: return .image(UIImage.init(systemName: "calendar"), color: .systemPink, size: .medium)
        case 9: return .image(UIImage.init(systemName: "calendar"), color: .systemPink, size: .large)
        case 10: return .customView {
            let label = UILabel()
            label.text = "X day"
            return label
        }
        case 11: return .customView {
            let label = UILabel()
            label.text = "X day"
            label.textColor = .green
            return label
        }
        default: return nil
        }
    }
}
