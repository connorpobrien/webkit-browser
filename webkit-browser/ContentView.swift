//
//  ContentView.swift
//  webkit-browser
//
//  Created by Connor O'Brien on 12/22/23.
//

import SwiftUI
import WebKit
import SwiftData

struct ContentView: View {
    @State private var urlString: String = "http://www.apple.com"

    var body: some View {
        VStack {
            HStack {
                TextField("Enter URL", text: $urlString)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()

                Button("Go") {
                    // Load the URL in WKWebView
                }
            }

            if let url = URL(string: urlString) {
                    WebView(url: url)
                } else {
                    Text("Invalid URL")
                }

            // Add buttons for Back, Forward, Refresh here
        }
    }
}


#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
