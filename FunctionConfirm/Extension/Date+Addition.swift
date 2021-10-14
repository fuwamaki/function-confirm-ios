//
//  Date+Addition.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2021/10/09.
//  Copyright © 2021 fuwamaki. All rights reserved.
//

import Foundation

extension Date {
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }

    var month: Int {
        return Calendar.current.component(.month, from: self)
    }

    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
}

// MARK: Other Time
extension Date {
    // ◯秒後
    func secondAfter(_ second: Int) -> Date {
        let day = Calendar.current.date(byAdding: .second, value: second, to: self)
        return day!
    }

    // ◯秒前
    func secondBefore(_ second: Int) -> Date {
        let day = Calendar.current.date(byAdding: .second, value: -second, to: self)
        return day!
    }

    // ◯分後
    func minuteAfter(_ minute: Int) -> Date {
        let day = Calendar.current.date(byAdding: .minute, value: minute, to: self)
        return day!
    }

    // ◯分前
    func minuteBefore(_ minute: Int) -> Date {
        let day = Calendar.current.date(byAdding: .minute, value: -minute, to: self)
        return day!
    }

    // ◯時間後
    func hourAfter(_ hour: Int) -> Date {
        let day = Calendar.current.date(byAdding: .hour, value: hour, to: self)
        return day!
    }

    // ◯時間前
    func hourBefore(_ hour: Int) -> Date {
        let day = Calendar.current.date(byAdding: .hour, value: -hour, to: self)
        return day!
    }

    // その日の0時00分
    var startTime: Date {
        return Calendar.current.startOfDay(for: self)
    }
}

// MARK: Other Day
extension Date {
    var yesterday: Date {
        let day = Calendar.current.date(byAdding: .day, value: -1, to: self)
        return day!
    }

    var tomorrow: Date {
        let day = Calendar.current.date(byAdding: .day, value: 1, to: self)
        return day!
    }

    var oneWeekBefore: Date {
        let day = Calendar.current.date(byAdding: .day, value: -7, to: self)
        return day!
    }

    var oneWeekAfter: Date {
        let day = Calendar.current.date(byAdding: .day, value: 7, to: self)
        return day!
    }

    var oneMonthBefore: Date {
        let day = Calendar.current.date(byAdding: .month, value: -1, to: self)
        return day!
    }

    var oneMonthAfter: Date {
        let day = Calendar.current.date(byAdding: .month, value: 1, to: self)
        return day!
    }

    var oneYearBefore: Date {
        let day = Calendar.current.date(byAdding: .year, value: -1, to: self)
        return day!
    }

    var oneYearAfter: Date {
        let day = Calendar.current.date(byAdding: .year, value: 1, to: self)
        return day!
    }

    var beginningOfTheMonth: Date {
        let component = Calendar.current.dateComponents([.year, .month], from: self)
        return Calendar.current.date(from: component)!
    }

    var endOfTheMonth: Date {
        let beginningOfTheMonth = self.beginningOfTheMonth
        let add = DateComponents(month: 1, day: -1)
        return Calendar.current.date(byAdding: add, to: beginningOfTheMonth)!
    }

    var beginningOfTheYear: Date {
        let component = Calendar.current.dateComponents([.year], from: self)
        return Calendar.current.date(from: component)!
    }

    var endOfTheYear: Date {
        let beginningOfTheYear = self.beginningOfTheYear
        let add = DateComponents(year: 1, day: -1)
        return Calendar.current.date(byAdding: add, to: beginningOfTheYear)!
    }
}

// MARK: WeekDay
extension Date {
    enum WeekDay: Int {
        case sunday = 0
        case monday = 1
        case tuesday = 2
        case wednesday = 3
        case thursday = 4
        case friday = 5
        case saturday = 6
    }

    var weekDayIndex: Int {
        let weekday = (Calendar.current as NSCalendar)
            .components( .weekday, from: self)
            .weekday!
        // index値を1-7から0-6に変換
        return weekday - 1
    }

    var weekDay: WeekDay {
        return WeekDay(rawValue: weekDayIndex)!
    }

    var isSunday: Bool {
        return weekDay == .sunday
    }

    var isMonday: Bool {
        return weekDay == .monday
    }

    var isTuesday: Bool {
        return weekDay == .tuesday
    }

    var isWednesday: Bool {
        return weekDay == .wednesday
    }

    var isThursday: Bool {
        return weekDay == .thursday
    }

    var isFriday: Bool {
        return weekDay == .friday
    }

    var isSaturday: Bool {
        return weekDay == .saturday
    }
}

// MARK: DateFormatter
extension Date {
    var yyyyMMddHHmmss: String {
        return DateFormatter.yyyyMMddHHmmss.string(from: self)
    }

    var yyyyMMddHHmm: String {
        return DateFormatter.yyyyMMddHHmm.string(from: self)
    }

    var yyyyMMdd: String {
        return DateFormatter.yyyyMMdd.string(from: self)
    }

    var MMdd: String {
        return DateFormatter.MMdd.string(from: self)
    }

    var HHmm: String {
        return DateFormatter.HHmm.string(from: self)
    }

    var kanjiyyyyMMddHHmmss: String {
        return DateFormatter.kanjiyyyyMMddHHmmss.string(from: self)
    }

    var kanjiyyyyMMddHHmm: String {
        return DateFormatter.kanjiyyyyMMddHHmm.string(from: self)
    }

    var kanjiyyyyMMdd: String {
        return DateFormatter.kanjiyyyyMMdd.string(from: self)
    }

    var kanjiMMdd: String {
        return DateFormatter.kanjiMMdd.string(from: self)
    }

    var kanjiHHmm: String {
        return DateFormatter.kanjiHHmm.string(from: self)
    }

    var kanjiyyyyMMddE: String {
        return DateFormatter.kanjiyyyyMMddE.string(from: self)
    }
}
