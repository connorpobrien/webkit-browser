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
    @Binding var loadableURL: URL?

    var body: some View {
        PlatformWebView(loadableURL: $loadableURL)
    }
}

#if os(iOS)
struct PlatformWebView: UIViewRepresentable {
    @Binding var loadableURL: URL?

    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        // Only load the URL if it's non-nil
        if let url = loadableURL {
            uiView.load(URLRequest(url: url))
            // Reset the loadableURL to prevent reloading
            DispatchQueue.main.async {
                loadableURL = nil
            }
        }
    }
}
#elseif os(macOS) || os(OSX)
struct PlatformWebView: NSViewRepresentable {
    @Binding var loadableURL: URL?

    func makeNSView(context: Context) -> WKWebView {
        WKWebView()
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
        // Only load the URL if it's non-nil
        if let url = loadableURL {
            nsView.load(URLRequest(url: url))
            // After loading the URL, reset the loadableURL to prevent reloading
            DispatchQueue.main.async {
                self.loadableURL = nil
            }
        }
    }
}
#endif
