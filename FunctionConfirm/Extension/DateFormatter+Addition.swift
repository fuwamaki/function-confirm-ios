//
//  DateFormatter+Addition.swift
//  FunctionConfirm
//
//  Created by yusaku maki on 2021/10/09.
//  Copyright © 2021 fuwamaki. All rights reserved.
//

import Foundation

extension DateFormatter {
    static var yyyyMMddHHmmss: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter
    }

    static var yyyyMMddHHmm: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter
    }

    static var yyyyMMdd: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter
    }

    static var MMdd: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter
    }

    static var HHmm: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter
    }

    // MARK: kanji
    static var kanjiyyyyMMddHHmmss: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日 HH時mm分ss秒"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter
    }

    static var kanjiyyyyMMddHHmm: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日 HH時mm分"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter
    }

    static var kanjiyyyyMMdd: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter
    }

    static var kanjiMMdd: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM年dd月"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter
    }

    static var kanjiHHmm: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH時mm分"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter
    }

    // MARK: kanji week
    static var kanjiyyyyMMddE: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy年MM月dd日(E)"
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter
    }
}
