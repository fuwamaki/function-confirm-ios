//
//  EKSampleViewController.swift
//  FunctionConfirm
//
//  Created by fuwamaki on 2022/03/14.
//  Copyright © 2022 fuwamaki. All rights reserved.
//

import Foundation
import UIKit
import EventKit
import EventKitUI

final class EKSampleViewController: UIViewController {

    @IBOutlet private weak var titleTextField: UITextField!
    @IBOutlet private weak var startDatePicker: UIDatePicker!
    @IBOutlet private weak var endDatePicker: UIDatePicker!
    @IBOutlet private weak var noteTextField: UITextField!

    @IBAction private func clickAddSchedule(_ sender: Any) {
        guard EKEventStore.authorizationStatus(for: .event) == .authorized else { return }
        do {
            try eventStore.save(event, span: .thisEvent)
            showAlert(title: "登録完了", message: "カレンダーに予定を登録しました。")
        } catch {
            showAlert(title: "エラー", message: "カレンダーに登録失敗しました。")
        }
    }

    @IBAction private func clickShowAddView(_ sender: Any) {
        guard EKEventStore.authorizationStatus(for: .event) == .authorized else { return }
        let viewController = EKEventEditViewController()
        viewController.eventStore = eventStore
        viewController.event = event
        viewController.editViewDelegate = self
        present(viewController, animated: true)
    }

    private let eventStore = EKEventStore()

    private var event: EKEvent {
        let event = EKEvent(eventStore: eventStore)
        event.title = titleTextField.text
        event.startDate = startDatePicker.date
        event.endDate = endDatePicker.date
        event.notes = noteTextField.text
        event.calendar = eventStore.defaultCalendarForNewEvents
        return event
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeDatePicker()
        confirmEventStoreAuth()
    }

    private func initializeDatePicker() {
        startDatePicker.date = Date()
        endDatePicker.date = Date().hourAfter(3)
    }

    private func confirmEventStoreAuth() {
        if EKEventStore.authorizationStatus(for: .event) == .notDetermined {
            eventStore.requestAccess(to: .event) { granted, error in
                if let error = error {
                    debugPrint(error.localizedDescription)
                } else {
                    debugPrint("EKEventStore.authorizationStatus: \(granted)")
                }
            }
        }
    }

    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

//extension EKSampleViewController: UINavigationControllerDelegate {}

extension EKSampleViewController: EKEventEditViewDelegate {
//    func eventEditViewControllerDefaultCalendar(
//        forNewEvents controller: EKEventEditViewController
//    ) -> EKCalendar {
//        <#code#>
//    }

    func eventEditViewController(
        _ controller: EKEventEditViewController,
        didCompleteWith action: EKEventEditViewAction
    ) {
        controller.dismiss(animated: true)
        switch action {
        case .saved:
            showAlert(title: "登録完了", message: "カレンダーに予定を登録しました。")
        default: break
        }
    }
}
