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
    @State private var zoomLevel: CGFloat = 1.0

    var body: some View {
        VStack {
            HStack{
                Button(action: {
                        // Back action
                    }) {
                        Image(systemName: "arrow.left").imageScale(.medium)
                }
                
                Button(action: {
                        // Forward action
                    }) {
                        Image(systemName: "arrow.right").imageScale(.medium)
                }
                
                Button(action: {
                        loadWebPage()
                    }) {
                        Image(systemName: "arrow.clockwise").imageScale(.medium)
                }
                
                Spacer().frame(width: 10)
                
                TextField("Enter URL", text: $urlString)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onSubmit {
                        loadWebPage()
                }.frame(minWidth: 0, maxWidth: .infinity)
                
                Button("Go") {
                    loadWebPage()
                }
                
                Menu {
                    Button("Zoom In") {
                        zoomLevel += 0.1
                    }
                    Button("Zoom Out") {
                        zoomLevel -= 0.1
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }.frame(width:50)
            }.padding()

            // main call to load webpage
            WebView(loadableURL: $loadableURL, zoomLevel: $zoomLevel)
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

