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
    
    var webView: WKWebView

    override init() {
        self.performanceMetricsModel = PerformanceMetricsModel()
        self.webView = WKWebView()
        super.init()
        webView.navigationDelegate = self
        setupProgressObserver()
    }
    
    init(performanceMetricsModel: PerformanceMetricsModel) {
        self.performanceMetricsModel = performanceMetricsModel
        self.webView = WKWebView()
        super.init()
        webView.navigationDelegate = self
        setupProgressObserver()
    }
    
    private func setupProgressObserver() {
        webView.addObserver(self, forKeyPath: "estimatedProgress", options: .new, context: nil)
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
        DispatchQueue.main.async {
                self.performanceMetricsModel.numberOfRedirects = 0
            }
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
            self.evaluateWebStorageUsage()
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
        DispatchQueue.main.async {
            self.performanceMetricsModel.numberOfRedirects += 1
        }
    }

    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        incrementNetworkRequestCount()
    }
    
    func evaluateWebStorageUsage() {
        let jsScript = """
        (function() {
            function getStorageSize(storage) {
                return Object.keys(storage).reduce(function(size, key) {
                    return size + ((storage[key].length + key.length) * 2);
                }, 0);
            }

            return {
                localStorageSize: getStorageSize(localStorage),
                sessionStorageSize: getStorageSize(sessionStorage)
            };
        })();
        """

        webView.evaluateJavaScript(jsScript) { [weak self] (result, error) in
            if let storageSizes = result as? [String: Any] {
                DispatchQueue.main.async {
                    self?.performanceMetricsModel.localStorageSize = storageSizes["localStorageSize"] as? Int ?? 0
                    self?.performanceMetricsModel.sessionStorageSize = storageSizes["sessionStorageSize"] as? Int ?? 0
                }
            }
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress", let change = change, let newValue = change[.newKey] as? Double {
            DispatchQueue.main.async {
                self.performanceMetricsModel.pageLoadProgress = newValue
            }
        }
    }

    deinit {
        webView.removeObserver(self, forKeyPath: "estimatedProgress")
    }
}

