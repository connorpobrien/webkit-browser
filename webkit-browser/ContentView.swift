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
        @State private var url: URL = URL(string: "http://www.apple.com")!

        var body: some View {
            VStack {
                HStack {
                    TextField("Enter URL", text: $urlString)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()

                    Button("Go") {
                        reloadUrl()
                    }
                }

                WebView(url: $url)
                // Add buttons for Back, Forward, Refresh here
            }
        }

        func reloadUrl() {
            if let newUrl = URL(string: urlString) {
                url = newUrl
            }
        }
    }


#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
