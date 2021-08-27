//
//  MovieListUITests.swift
//  MovieListUITests
//
//  Created by yomi on 2021/8/27.
//

import XCTest

class MovieListUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    
    func testMovieInfo() throws {
        measure(
            metrics: [
              XCTClockMetric(),
              XCTCPUMetric(),
              XCTStorageMetric(),
              XCTMemoryMetric()
            ]
          ) {
            let tablesQuery = app.tables
            
            app.buttons["Release Date"].tap()
            wait(for: [], timeout: 1.0)
            XCTAssertTrue(tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Tora! Tora! Tora!"]/*[[".cells.staticTexts[\"Tora! Tora! Tora!\"]",".staticTexts[\"Tora! Tora! Tora!\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
            tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Tora! Tora! Tora!"]/*[[".cells.staticTexts[\"Tora! Tora! Tora!\"]",".staticTexts[\"Tora! Tora! Tora!\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
            app.navigationBars["Tora! Tora! Tora!"].buttons["Movie List"].tap()
            
            app/*@START_MENU_TOKEN@*/.buttons["Popularity"]/*[[".segmentedControls.buttons[\"Popularity\"]",".buttons[\"Popularity\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
            wait(for: [], timeout: 1.0)
            XCTAssertTrue(tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["334.321"]/*[[".cells.staticTexts[\"334.321\"]",".staticTexts[\"334.321\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
            tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["334.321"]/*[[".cells.staticTexts[\"334.321\"]",".staticTexts[\"334.321\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
            app.navigationBars["The Haunting of Helena"].buttons["Movie List"].tap()
            
            app/*@START_MENU_TOKEN@*/.buttons["Vote Count"]/*[[".segmentedControls.buttons[\"Vote Count\"]",".buttons[\"Vote Count\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
            wait(for: [], timeout: 1.0)
            XCTAssertTrue(tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["29718"]/*[[".cells.staticTexts[\"29718\"]",".staticTexts[\"29718\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists)
            tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["29718"]/*[[".cells.staticTexts[\"29718\"]",".staticTexts[\"29718\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
            app.navigationBars["Inception"].buttons["Movie List"].tap()
          }
    }
}
