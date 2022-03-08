//
//  News_FeedUITests.swift
//  News FeedUITests
//
//  Created by Manish Tamta on 04/03/2022.
//

import XCTest

class News_FeedUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["L’ambassade d’allemagne au Maroc dément la publication d’un rapport des renseignements"]/*[[".cells.staticTexts[\"L’ambassade d’allemagne au Maroc dément la publication d’un rapport des renseignements\"]",".staticTexts[\"L’ambassade d’allemagne au Maroc dément la publication d’un rapport des renseignements\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let newsFeedNewsdetailviewNavigationBar = app.navigationBars["News_Feed.NewsDetailView"]
        let saveButtonOnDetail = newsFeedNewsdetailviewNavigationBar.buttons["Save"]
        let backNavigationButton = newsFeedNewsdetailviewNavigationBar.buttons["Back"]
        let alertOkButton = app.alerts.scrollViews.otherElements.buttons["OK"]

        saveButtonOnDetail.tap()
        alertOkButton.tap()
        backNavigationButton.tap()
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
