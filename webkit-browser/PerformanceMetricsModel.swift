//
//  PerformanceMetricsModel.swift
//  webkit-browser
//
//  Created by Connor O'Brien on 1/7/24.
//

import Foundation
import SwiftUI

struct PerformanceMetricsPanel: View {
    @ObservedObject var metricsModel: PerformanceMetricsModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("Performance Metrics").font(.headline)
            HStack {
                Text("CPU Usage:")
                Spacer()
                Text("\(metricsModel.cpuUsage, specifier: "%.2f")%")
            }
            HStack {
                Text("Memory Usage:")
                Spacer()
                Text("\(metricsModel.memoryUsage, specifier: "%.2f") MB")
            }
            HStack {
                Text("Network Requests:")
                Spacer()
                Text("\(metricsModel.networkRequests)")
            }
        }
        .padding()
        .frame(width: 300)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
