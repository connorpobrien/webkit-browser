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
    @StateObject private var webViewStateModel = WebViewStateModel()

    var body: some View {
        VStack {
            HStack{
                Button(action: webViewStateModel.goBack) {
                    Image(systemName: "arrow.left").imageScale(.medium)
                }.disabled(!webViewStateModel.canGoBack)
                
                Button(action: webViewStateModel.goForward) {
                    Image(systemName: "arrow.right").imageScale(.medium)
                }.disabled(!webViewStateModel.canGoForward)
                
                Button(action: webViewStateModel.reload) {
                    Image(systemName: "arrow.clockwise").imageScale(.medium)
                }
                
                Spacer().frame(width: 10)
                
                TextField("Enter URL", text: $urlString)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onSubmit {
                        loadWebPage()
                }.frame(minWidth: 0, maxWidth: .infinity)
                
                Button("Go", action: loadWebPage)
                
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
            WebView(webViewStateModel: webViewStateModel, loadableURL: $loadableURL, zoomLevel: $zoomLevel)
        }
    }
    
    private func loadWebPage() {
        // Check if the input is likely a URL or a search query
        if urlString.contains(".") && !urlString.contains(" ") {
            let formattedURLString = urlString.hasPrefix("http://") || urlString.hasPrefix("https://") ? urlString : "https://" + urlString
            loadableURL = URL(string: formattedURLString)
        } else {
            // Likely a search query, so perform a Google search
            let searchQuery = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let searchURLString = "https://www.google.com/search?q=\(searchQuery)"
            loadableURL = URL(string: searchURLString)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// TODO:
// fix scaling for macos
// performance metrics page
// bookmarks
// homepage
// custom themes / colors / effects
// individual user sign in
// additional tabs
// translation feature
// Resource Inspector: A tool for developers to inspect web page elements, scripts, network requests, and more.
// Automated testing tool
