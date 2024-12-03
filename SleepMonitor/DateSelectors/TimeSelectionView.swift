//
//  TimeSelectionView.swift
//  SlipMonitor
//
//  Created by Vadim on 11/25/24.
//

import SwiftUI

struct TimeSelectionView: View {
    @Bindable var viewModel: SleepChartViewModel
    @State var navPath = NavigationPath()
    var body: some View {
        NavigationStack() {
            VStack {
                Spacer()
                DatePicker(
                    "Start Time",
                    selection: $viewModel.startTime,
                    displayedComponents: .hourAndMinute
                )
                DatePicker(
                    "End Time",
                    selection: $viewModel.endTime,
                    displayedComponents: .hourAndMinute
                )
                Spacer()
                Spacer()

            }
            .toolbarBackground(.visible)
            .toolbar {
                ToolbarItem {
                    Button("Next") {
                        viewModel.showShart = true
                    }
                }
            }
            .padding(.horizontal, 30)
            .navigationDestination(isPresented: $viewModel.showShart) {
                SleepChartView(viewModel: viewModel)

            }
            .navigationTitle("Set Night Time")
        }
    }
}

private struct TestView: View {
    @State var viewModel = SleepChartViewModel()
    var body: some View {
        TimeSelectionView(viewModel: viewModel)
    }
}

#Preview {
    TestView()
}
