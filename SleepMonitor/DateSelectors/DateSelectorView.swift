//
//  DateSelectorView.swift
//  SleepMonitor
//
//  Created by Vadim on 12/3/24.
//

import SwiftUI

struct DateSelectorView: View {
    var viewModel: SleepChartViewModel
    var body: some View {
        HStack {
            Button("", systemImage: "chevron.backward") {
                viewModel.decrementDate()
            }
            Text(viewModel.date.formatted(date: .abbreviated, time: .omitted))
                .font(.headline)
                .frame(width: 120)
            Button("", systemImage: "chevron.forward") {
                viewModel.incrementDate()
            }
            .opacity(viewModel.date.startOfDay < Date().startOfDay ? 1 : 0)
        }
        .foregroundStyle(.primary)
    }
}

#Preview {
    DateSelectorView(viewModel: .init())
}
