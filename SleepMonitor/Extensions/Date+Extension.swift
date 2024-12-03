//
//  Date+Extension.swift
//  SlipMonitor
//
//  Created by Vadim on 11/25/24.
//

import Foundation

extension Date {
    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)!
    }

    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }

    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }

    var nightRange: ClosedRange<Date> {
        let start = Calendar.current.date(bySettingHour: 21, minute: 0, second: 0, of: yesterday) ?? self
        let end = Calendar.current.date(bySettingHour: 8, minute: 0, second: 0, of: self) ?? self
        return start...end
    }
}
