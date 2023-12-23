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

    var body: some View {
        VStack {
            TextField("Enter URL", text: $urlString)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("Go") {
                // reload
            }

            WebView(urlString: $urlString)
            // Add buttons for Back, Forward, Refresh here
        }
    }
    
//    func reloadUrl() {
//        if let newURL = URL(string: urlString) {
//            urlString = newURL
//        }
//    }
}


//#Preview {
//    ContentView()
//        .modelContainer(for: Item.self, inMemory: true)
//}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

