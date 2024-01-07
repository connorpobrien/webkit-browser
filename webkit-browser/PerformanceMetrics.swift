//
//  PerformanceMetrics.swift
//  webkit-browser
//
//  Created by Connor O'Brien on 1/7/24.
//

import Foundation
import SwiftUI

struct MetricView: View {
    var label: String
    var value: String

    var body: some View {
        HStack {
            Text(label)
            Spacer()
            Text(value)
        }
    }
}

class PerformanceMetricsModel: ObservableObject {
    @Published var cpuUsage: Double = 0.0
    @Published var gpuUsage: Double = 0.0
    @Published var memoryUsage: Double = 0.0
    @Published var networkRequests: Int = 0
    @Published var HTTPRequests: Int = 0
    @Published var pageLoadTime: Double = 0.0
    @Published var DOMSize: Int = 0
    @Published var DOMNodes: Int = 0
    @Published var DataUsage: Double = 0.0
    @Published var TimeToFirstPaint: Double = 0.0
    @Published var JSExecutionTime: Double = 0
    
    @Published var CacheHits: Int = 0
    @Published var CacheMisses: Int = 0
    @Published var ImagesLoadTime: Double = 0
    @Published var CSSLoadTime: Double = 0
    @Published var FPS: Double = 0
    
    

    // Add methods to update these metrics
}

struct PerformanceMetricsPanel: View {
    @ObservedObject var metricsModel: PerformanceMetricsModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("Performance Metrics").font(.headline)
            MetricView(label: "CPU Usage:", value: String(format: "%.2f%%", metricsModel.cpuUsage))
            MetricView(label: "GPU Usage:", value: String(format: "%.2f%%", metricsModel.gpuUsage))
            MetricView(label: "Memory Usage:", value: String(format: "%.2f MB", metricsModel.memoryUsage))
            MetricView(label: "Network Requests:", value: "\(metricsModel.networkRequests)")
            MetricView(label: "HTTP Requests:", value: "\(metricsModel.HTTPRequests)")
            MetricView(label: "Page Load Time:", value: String(format: "%.2f s", metricsModel.pageLoadTime))
            MetricView(label: "DOM Size:", value: "\(metricsModel.DOMSize)")
            MetricView(label: "DOM Nodes:", value: "\(metricsModel.DOMNodes)")
            MetricView(label: "Data Usage:", value: String(format: "%.2f MB", metricsModel.DataUsage))
            MetricView(label: "Time To First Paint:", value: String(format: "%.2f s", metricsModel.TimeToFirstPaint))
            MetricView(label: "JS Execution Time:", value: String(format: "%.2f s", metricsModel.JSExecutionTime))
        }
        .padding()
        .frame(width: 300)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
