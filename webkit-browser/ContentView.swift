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
    @State private var urlString: String = "https://www.apple.com"
    @State private var loadableURL: URL? = URL(string: "https://www.apple.com")

    var body: some View {
        VStack {
            HStack{
                TextField("Enter URL", text: $urlString)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onSubmit {
                        loadWebPage()
                    }

                Button("Go") {
                    loadWebPage()
                }
            }
            .padding()

            WebView(loadableURL: $loadableURL)
            
            // Add buttons for Back, Forward, Refresh here
        }
    }
    
    private func loadWebPage() {
        if let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: encodedString) {
            loadableURL = url
        }
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

