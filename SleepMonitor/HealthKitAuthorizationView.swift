//
//  HealthKitAuthorizationView.swift
//  SlipMonitor
//
//  Created by Vadim on 11/25/24.
//

import SwiftUI
import HealthKitUI

struct HealthKitAuthorizationView: View {
    @State var trigger = false
    @State var viewModel = SleepChartViewModel()

    var body: some View {
        TimeSelectionView(viewModel: viewModel)
        // If HealthKit data is available, request authorization
        // when this view appears.
            .onAppear() {

                // Check that Health data is available on the device.
                if HKHealthStore.isHealthDataAvailable() {
                    // Modifying the trigger initiates the health data
                    // access request.
                    trigger.toggle()
                }
            }
        // Requests access to share and read HealthKit data types
        // when the trigger changes.
        .healthDataAccessRequest(store: viewModel.healthStore,
                                 shareTypes: [],
                                 readTypes: viewModel.types,
                                 trigger: trigger) { result in
            switch result {

            case .success(_):
                viewModel.isAuthenticated = true
            case .failure(let error):
                // Handle the error here.
                fatalError("*** An error occurred while requesting authentication: \(error) ***")
            }
        }

    }
}

#Preview {
    HealthKitAuthorizationView()
}
