//
//  WebViewStateModel.swift
//  webkit-browser
//
//  Created by Connor O'Brien on 12/23/23.
//

import Foundation
import SwiftUI
import WebKit

class WebViewStateModel: NSObject, ObservableObject, WKNavigationDelegate {
    @Published var canGoBack: Bool = false
    @Published var canGoForward: Bool = false
    private var navigationStartTime: Date?
    private var performanceMetricsModel = PerformanceMetricsModel()
    
    
    var webView: WKWebView = WKWebView()

    override init() {
        super.init()
        webView.navigationDelegate = self
    }
    
    init(performanceMetricsModel: PerformanceMetricsModel) {
        self.performanceMetricsModel = performanceMetricsModel
        super.init()
        webView.navigationDelegate = self
    }
    
    func getCurrentURL() -> String {
        webView.url?.absoluteString ?? ""
    }

    func goBack() {
        if webView.canGoBack {
            webView.goBack()
        }
    }

    func goForward() {
        if webView.canGoForward {
            webView.goForward()
        }
    }

    func reload() {
        webView.reload()
    }

    func loadRequest(_ request: URLRequest) {
        webView.load(request)
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        navigationStartTime = Date()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        canGoBack = webView.canGoBack
        canGoForward = webView.canGoForward
        if let startTime = navigationStartTime {
            let loadTime = Date().timeIntervalSince(startTime)
            performanceMetricsModel.pageLoadTime = loadTime
            navigationStartTime = nil // Reset for the next navigation
        }
    }
    
    func setZoom(_ zoom: CGFloat) {
        webView.pageZoom = zoom
        webView.reload()
    }
}

