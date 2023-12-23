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
    @Binding var urlString: String

    var body: some View {
        PlatformWebView(urlString: $urlString)
    }
}

#if os(iOS)
struct PlatformWebView: UIViewRepresentable {
    @Binding var urlString: String

    func makeUIView(context: Context) -> WKWebView {
        WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            uiView.load(URLRequest(url: url))
        }
    }
}
#elseif os(macOS) || os(OSX)
struct PlatformWebView: NSViewRepresentable {
    @Binding var urlString: String

    func makeNSView(context: Context) -> WKWebView {
        WKWebView()
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
        if let url = URL(string: urlString) {
            nsView.load(URLRequest(url: url))
        }
    }
}
#endif
