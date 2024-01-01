//
//  WebView.swift
//  webkit-browser
//
//  Created by Connor O'Brien on 12/22/23.
//

import SwiftUI
import WebKit

#if os(iOS)
    import UIKit
    typealias PlatformView = UIView
#elseif os(macOS)
    import AppKit
    typealias PlatformView = NSView
#endif

struct WebView: View {
    @ObservedObject var webViewStateModel: WebViewStateModel
    @Binding var loadableURL: URL?
    @Binding var pageZoom: CGFloat

    var body: some View {
        PlatformWebView(webViewStateModel: webViewStateModel, loadableURL: $loadableURL, pageZoom: $pageZoom)
    }
}

#if os(iOS)
struct PlatformWebView: UIViewRepresentable {
    var webViewStateModel: WebViewStateModel
    @Binding var loadableURL: URL?
    @Binding var pageZoom: CGFloat // not used (yet?)

    func makeUIView(context: Context) -> WKWebView {
        let webview = webViewStateModel.webView
        return webview
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = loadableURL, uiView.url != url {
            uiView.load(URLRequest(url: url))
            DispatchQueue.main.async {
                self.loadableURL = nil // Reset the loadableURL to prevent reloading
            }
        }
        // Implement zooming for ios
    }
}
#elseif os(macOS)
struct PlatformWebView: NSViewRepresentable {
    var webViewStateModel: WebViewStateModel
    @Binding var loadableURL: URL?
    @Binding var pageZoom: CGFloat

    func makeNSView(context: Context) -> WKWebView {
        let webView = webViewStateModel.webView
        webView.pageZoom = pageZoom
        return webView
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
        if let url = loadableURL, nsView.url != url {
            nsView.load(URLRequest(url: url))
            DispatchQueue.main.async {
                self.loadableURL = nil // Reset the loadableURL to prevent reloading
            }
        }
        nsView.pageZoom = pageZoom // Update page zoom
    }
}
#endif
