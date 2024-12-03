//
//  SleepChartViewModel.swift
//  SlipMonitor
//
//  Created by Vadim on 11/25/24.
//

import Foundation
import HealthKit

@Observable
class SleepChartViewModel {
    let sleepDataFetcher: SleepDataFatcherProtocol
    let healthStore = HKHealthStore()
    var date: Date
    var startTime: Date
    var endTime: Date
    init(
        sleepDataFetcher: SleepDataFatcherProtocol = SleepDataFatcher()
    ) {
        self.sleepDataFetcher = sleepDataFetcher
        let date = Date().yesterday
        startTime = date.nightRange.lowerBound
        endTime = date.nightRange.upperBound
        self.date = date
    }

    var isAuthenticated: Bool = false
    var showShart = false
    let types: Set<HKSampleType> = [HKCategoryType(.sleepAnalysis)]
    var samples: [HKCategorySample] = []

    private var nightStartHour: Int? {
        Calendar.current.dateComponents([.hour], from: startTime).hour
    }
    private var nightStartMinute: Int? {
        Calendar.current.dateComponents([.minute], from: startTime).minute
    }
    private var nightStart: Date? {
        guard let nightStartHour, let nightStartMinute else {
            return nil
        }
        return Calendar.current.date(
            bySettingHour: nightStartHour,
            minute: nightStartMinute,
            second: 0,
            of: date.yesterday
        )
    }
    private var nightEndHour: Int? {
        Calendar.current.dateComponents([.hour], from: endTime).hour
    }
    private var nightEndMinute: Int? {
        Calendar.current.dateComponents([.minute], from: endTime).minute
    }
    private var nightEnd: Date? {
        guard let nightEndHour, let nightEndMinute else {
            return nil
        }
        return Calendar.current.date(
            bySettingHour: nightEndHour,
            minute: nightEndMinute,
            second: 0,
            of: date
        )
    }
    var nightTimeRange: ClosedRange<Date> {
        startTime ... endTime
    }
    
    var currentNightRange: ClosedRange<Date> {
        guard let nightStart, let nightEnd else {
            return Date()...Date()
        }
        return nightStart...nightEnd
    }

    func incrementDate() {
        date = Calendar.current.date(byAdding: .day, value: 1, to: date) ?? date
    }

    func decrementDate() {
        date = Calendar.current.date(byAdding: .day, value: -1, to: date) ?? date
    }

    func fetchSleepData() {
        sleepDataFetcher.fetchData(
            healthStore: healthStore,
            startTime: currentNightRange.lowerBound,
            endTime: currentNightRange.upperBound
        ) { samples in
            self.samples = samples
            print(samples)
        }
    }
}

