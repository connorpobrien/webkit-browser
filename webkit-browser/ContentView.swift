//
//  ContentView.swift
//  webkit-browser
//
//  Created by Connor O'Brien on 12/22/23.
//

import SwiftUI
import WebKit
import SwiftData

struct Bookmark: Identifiable, Codable {
    var id = UUID()
    var title: String
    var url: String
}

struct ContentView: View {
    @State private var urlString: String = "https://www.apple.com"
    @State private var loadableURL: URL? = URL(string: "https://www.apple.com")
    @State private var pageZoom: CGFloat = 0.7
    @State private var homeURL: String = "https://www.apple.com"
    @State private var isEditingHomeURL: Bool = false
    @State private var newHomeURL: String = ""
    @State private var accentColor: Color = .blue
    @State private var newBookmarkTitle: String = ""
    @State private var showingAddBookmark: Bool = false
    @State private var bookmarks: [Bookmark] = []
    @AppStorage("bookmarks") var bookmarksData = Data()
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
                
                Button(action: goToHomePage) {
                    Image(systemName: "house").imageScale(.medium).foregroundColor(accentColor)
                }
                
                Spacer().frame(width: 10)
                
                TextField("Enter URL", text: $urlString)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .onSubmit {
                        loadWebPage()
                }.frame(minWidth: 0, maxWidth: .infinity)
                
                Button("Go", action: loadWebPage)
                
                Menu {
                    if bookmarks.isEmpty {
                        Text("No Bookmarks").disabled(true)
                    } else {
                        ForEach(bookmarks) { bookmark in
                            Button(action: {
                                loadableURL = URL(string: bookmark.url)
                            }) {
                                Text(bookmark.title)
                            }
                        }
                    }
                } label: {
                    Image(systemName: "book.fill")
                }.frame(width: 50)
                
                Menu {
                    Button("Zoom In") {
                        let newZoom = pageZoom + 0.1
                        pageZoom = newZoom
                        webViewStateModel.setZoom(newZoom)
                    }
                    Button("Zoom Out") {
                        let newZoom = pageZoom - 0.1
                        pageZoom = newZoom
                        webViewStateModel.setZoom(newZoom)
                    }
                    Button("Change Home URL") {
                        isEditingHomeURL = true
                        newHomeURL = homeURL
                    }
                    Button("Change Accent Color") {
                        accentColor = Color(
                            red: .random(in: 0...1),
                            green: .random(in: 0...1),
                            blue: .random(in: 0...1)
                        )
                    }
                    Button("Add Bookmark") {
                        showingAddBookmark = true
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }.frame(width:50)
            }.padding()
            
            if isEditingHomeURL {
                TextField("Enter new home URL", text: $newHomeURL, onCommit: updateHomeURL)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }
            
            if showingAddBookmark {
                TextField("Enter Bookmark Title", text: $newBookmarkTitle, onCommit: addBookmark)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
            }

            // main call to load webpage
            WebView(webViewStateModel: webViewStateModel, loadableURL: $loadableURL, pageZoom: $pageZoom)
        }.accentColor(accentColor)
    }
    
    private func goToHomePage() {
        if let url = URL(string: homeURL) {
            loadableURL = url
        }
    }
    
    private func updateHomeURL() {
        if URL(string: newHomeURL) != nil {
            homeURL = newHomeURL
        }
        isEditingHomeURL = false
    }
    
    private func loadWebPage() {
        // Check if the input is likely a URL or a search query
        if urlString.contains(".") && !urlString.contains(" ") {
            let formattedURLString = urlString.hasPrefix("http://") || urlString.hasPrefix("https://") ? urlString : "https://" + urlString
            loadableURL = URL(string: formattedURLString)
        } else {
            let searchQuery = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            let searchURLString = "https://www.google.com/search?q=\(searchQuery)"
            loadableURL = URL(string: searchURLString)
        }
    }
    
    private func saveBookmarks() {
        bookmarksData = (try? JSONEncoder().encode(bookmarks)) ?? Data()
    }
    
    private func addBookmark() {
        let currentURL = webViewStateModel.getCurrentURL() 
        let bookmark = Bookmark(title: newBookmarkTitle, url: currentURL)
        bookmarks.append(bookmark)
        saveBookmarks()
        showingAddBookmark = false
        newBookmarkTitle = ""  // Reset for next input
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// TODO:
// performance metrics page
// additional tabs
// individual user sign in
// translation feature
// fun color/effect features
// Resource Inspector: A tool for developers to inspect web page elements, scripts, network requests, and more.
// Automated testing tool
// Reader Mode: Implement a reader mode that strips away clutter like ads and popups from web pages, presenting users with clean, readable text. WebKit can help parse and render content in a reader-friendly format.
// JavaScript Console: Integrate a JavaScript console for advanced users or developers. This would allow users to run JavaScript commands directly on the current web page.
// Web Animations API: Utilize WebKit's support for the Web Animations API to create interactive, animated user interfaces.
