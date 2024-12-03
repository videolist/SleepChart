//
//  SlipMonitorApp.swift
//  SlipMonitor
//
//  Created by Vadim on 11/25/24.
//

import SwiftUI

@main
struct SlipMonitorApp: App {
    var body: some Scene {
        WindowGroup {
            HealthKitAuthorizationView()
                .toolbarColorScheme(.dark)
                .toolbarBackground(.visible)
        }

    }
}
