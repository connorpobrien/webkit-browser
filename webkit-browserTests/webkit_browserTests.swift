//
//  webkit_browserTests.swift
//  webkit-browserTests
//
//  Created by Connor O'Brien on 12/22/23.
//

import XCTest
import WebKit
@testable import webkit_browser

final class webkit_browserTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWebViewStateModelInitialization() {
        let model = WebViewStateModel()
        XCTAssertFalse(model.canGoBack)
        XCTAssertFalse(model.canGoForward)
        XCTAssertEqual(model.currentURL, "")
    }
    
    func testMemoryUsageUpdate() {
        let model = PerformanceMetricsModel()
        let expectation = XCTestExpectation(description: "Memory usage should be updated")

        model.updateMemoryUsage()

        // Wait for a short time to allow the memory usage update to complete
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if model.memoryUsage != 0 {
                expectation.fulfill()
            }
        }

        wait(for: [expectation], timeout: 1.5)

        XCTAssertNotEqual(model.memoryUsage, 0)
    }
    
    func testURLLoading() {
        let model = WebViewStateModel()
        let testURL = URL(string: "https://www.example.com/")!
        model.loadRequest(URLRequest(url: testURL))
        XCTAssertEqual(model.getCurrentURL(), testURL.absoluteString)
    }
    
    func testZoomLevelChange() {
        let model = WebViewStateModel()
        let expectedZoom: CGFloat = 1.5
        model.setZoom(expectedZoom)
        XCTAssertEqual(model.webView.pageZoom, expectedZoom)
    }
}
