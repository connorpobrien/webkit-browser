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
        print("Navigation started")
        navigationStartTime = Date()
        resetNetworkRequestCount()
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("Navigation Finished")
        DispatchQueue.main.async {
            self.canGoBack = webView.canGoBack
            self.canGoForward = webView.canGoForward

            if let startTime = self.navigationStartTime {
                let loadTime = Date().timeIntervalSince(startTime)
                print("Page Load Time: \(loadTime)")
                self.performanceMetricsModel.pageLoadTime = loadTime
                self.navigationStartTime = nil
            }
            
            self.evaluateDOMSize()
            self.evaluateDOMNodes()
        }
    }
    
    func setZoom(_ zoom: CGFloat) {
        webView.pageZoom = zoom
        webView.reload()
    }
    
    func evaluateDOMSize() {
        let jsDOMSize = "new Blob([document.documentElement.outerHTML]).size;"
        webView.evaluateJavaScript(jsDOMSize) { [weak self] (result, error) in
            if let size = result as? Int {
                DispatchQueue.main.async {
                    self?.performanceMetricsModel.DOMSize = size
                }
            }
        }
    }

    func evaluateDOMNodes() {
        let jsDOMNodes = "document.getElementsByTagName('*').length;"
        webView.evaluateJavaScript(jsDOMNodes) { [weak self] (result, error) in
            if let count = result as? Int {
                DispatchQueue.main.async {
                    self?.performanceMetricsModel.DOMNodes = count
                }
            }
        }
    }
    
    func incrementNetworkRequestCount() {
        DispatchQueue.main.async {
            self.performanceMetricsModel.networkRequests += 1
        }
    }

    func resetNetworkRequestCount() {
        DispatchQueue.main.async {
            self.performanceMetricsModel.networkRequests = 0
        }
    }

    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        incrementNetworkRequestCount()
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        incrementNetworkRequestCount()
    }

}

