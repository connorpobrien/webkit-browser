//
//  PerformanceMetrics.swift
//  webkit-browser
//
//  Created by Connor O'Brien on 1/7/24.
//

import Foundation
import SwiftUI
import MachO

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
    @Published var memoryUsage: Double = 0.0
    @Published var networkRequests: Int = 0
    @Published var networkTraffic: Double = 0.0
    @Published var pageLoadTime: Double = 0.0
    @Published var DOMSize: Int = 0
    @Published var DOMNodes: Int = 0
    @Published var DataUsage: Double = 0.0
    @Published var TimeToFirstPaint: Double = 0.0
    @Published var JSExecutionTime: Double = 0
    
    func updateMemoryUsage() {
        var info = mach_task_basic_info()
        var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size) / 4

        let kerr: kern_return_t = withUnsafeMutablePointer(to: &info) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
            }
        }

        if kerr == KERN_SUCCESS {
            let memoryUsedInMegabytes = Double(info.resident_size) / 1024 / 1024
            DispatchQueue.main.async {
                self.memoryUsage = memoryUsedInMegabytes
            }
        } else {
            print("Error with task_info(): \(kerr)")
        }
    }
}

struct PerformanceMetricsPanel: View {
    @ObservedObject var metricsModel: PerformanceMetricsModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("Performance Metrics").font(.headline)
            MetricView(label: "Memory Usage:", value: String(format: "%.2f MB", metricsModel.memoryUsage))
            MetricView(label: "Network Requests:", value: "\(metricsModel.networkRequests)")
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
