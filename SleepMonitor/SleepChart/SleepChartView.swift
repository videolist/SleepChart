//
//  SleepChartView.swift
//  SlipMonitor
//
//  Created by Vadim on 11/25/24.
//

import SwiftUI
import Charts
import HealthKit

struct SleepChartView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var viewModel: SleepChartViewModel
    private var categories: [String] {
        let categories: [HKCategoryValueSleepAnalysis] = [.awake, .asleepREM, .asleepCore, .asleepDeep]
        return categories.map(\.name)
    }
    var body: some View {
        VStack {
            Text("Sleep Chart")
                .font(.title)
                .padding(.top)
            Spacer()

            DateSelectorView(viewModel: viewModel)

            Chart(viewModel.samples, id:\.startDate) { sample in
                LineMark(
                    x: .value("Start time", sample.startDate.addingTimeInterval(900)),
                    y: .value("Sleep Phase", categories[sample.value - 2])
                )
                .lineStyle(.init(lineWidth: 10, lineCap: .round, lineJoin: .bevel))
                .foregroundStyle(Gradient(colors: [
                    .purple.opacity(0.5),
                    .blue.opacity(0.5),
                    .mint.opacity(0.5),
                    .orange.opacity(0.5)
                ]))
                .interpolationMethod(.catmullRom)

                RectangleMark(
                    xStart: .value("Start time", sample.startDate),
                    xEnd: .value("End time", sample.endDate),
                    y: .value("Sleep Phase", categories[sample.value - 2]), height: .ratio(1)
                )
                .cornerRadius(10)
                .foregroundStyle(by: .value("Sleep Phase", categories[sample.value - 2]))

            }
            .chartYScale(domain: categories)
            .chartXScale(domain: viewModel.currentNightRange)
            .chartXAxis {
                let nightStart = viewModel.currentNightRange.lowerBound
                let nightEnd = viewModel.currentNightRange.upperBound
                let values = stride(from: nightStart, to: nightEnd,  by: 2 * 3600).map { $0 }
                AxisMarks(
                    format: Date.FormatStyle.dateTime.hour(.twoDigits(amPM: .abbreviated)),
                    values: values
                )

                AxisMarks(values: values) { value in
                    if let value = value.as(Date.self) {
                        if value == nightStart || value == nightEnd {
                            AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5))
                            AxisTick(stroke: StrokeStyle(lineWidth: 0.5))
                        }
                    }
                }
            }
            .chartLegend(.visible)
            .onAppear {
                viewModel.fetchSleepData()
            }
            .frame(height: 300)
            .padding()

            Spacer()
        }
        .toolbarBackground(.visible)
        .onChange(of: viewModel.date) { _, _ in
            viewModel.fetchSleepData()
        }
        .overlay {
            if viewModel.samples.isEmpty {
                Text("No Data")
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    SleepChartView(viewModel: .init(
        sleepDataFetcher: MockSleepDataFetcher()
    ))
}

extension HKCategoryValueSleepAnalysis {
    var name: String {
        switch self {
        case .asleepCore: return "Core"
        case .asleepDeep: return "Deep"
        case .asleepREM: return "REM"
        case .awake: return "Awake"
        case .inBed: return "In Bed"
        default: return ""
        }
    }
}
