//
//  ContentView.swift
//  webkit-browser
//
//  Created by Connor O'Brien on 12/22/23.
//

import SwiftUI
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

            WebView(urlString: $urlString)

            // Add buttons for Back, Forward, Refresh here
        }
    }
}


#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
