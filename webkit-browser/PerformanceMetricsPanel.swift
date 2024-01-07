//
//  PerformanceMetricsPanel.swift
//  webkit-browser
//
//  Created by Connor O'Brien on 1/7/24.
//

import Foundation

class PerformanceMetricsModel: ObservableObject {
    @Published var cpuUsage: Double = 0.0
    @Published var memoryUsage: Double = 0.0
    @Published var networkRequests: Int = 0

    // Add methods to update these metrics
}
