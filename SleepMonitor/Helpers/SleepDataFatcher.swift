//
//  SleepDataFatcher.swift
//  SlipMonitor
//
//  Created by Vadim on 11/25/24.
//

import Foundation
import HealthKit

protocol SleepDataFatcherProtocol {
    func fetchData(
        healthStore: HKHealthStore,
        startTime: Date,
        endTime: Date,
        completion: @escaping ([HKCategorySample]) -> Void
    )
}

struct SleepDataFatcher: SleepDataFatcherProtocol {
    func fetchData(
        healthStore: HKHealthStore,
        startTime: Date,
        endTime: Date,
        completion: @escaping ([HKCategorySample]) -> Void
    ) {
        let sleepType = HKCategoryType(.sleepAnalysis)
        let predicate = HKQuery.predicateForSamples(
            withStart: startTime,
            end: endTime,
            options: .strictStartDate
        )
        let query = HKSampleQuery(
            sampleType: sleepType,
            predicate: predicate,
            limit: HKObjectQueryNoLimit,
            sortDescriptors: nil
        ) { (query, samples, error) in
            completion(samples as? [HKCategorySample] ?? [])
        }

        healthStore.execute(query)
    }
}

struct MockSleepDataFetcher: SleepDataFatcherProtocol {
    func fetchData(
        healthStore: HKHealthStore,
        startTime: Date,
        endTime: Date,
        completion: @escaping ([HKCategorySample]) -> Void
    ) {
        let start = startTime.timeIntervalSince1970
        let end = endTime.timeIntervalSince1970
        let values: [HKCategoryValueSleepAnalysis] = [.asleepCore, .asleepDeep, .asleepREM, .awake]
        var samples: [HKCategorySample] = []
        let interval: TimeInterval = 30 * 60
        for (index, time) in stride(from: start, to: end, by: interval).enumerated() {
            let value = values[index % values.count]
            let sample = HKCategorySample(
                type: HKCategoryType(.sleepAnalysis),
                value: value.rawValue,
                start: Date(timeIntervalSince1970: time),
                end: Date(timeIntervalSince1970: time + interval)
            )
            samples.append(sample)
        }
        completion(samples)
    }
}
