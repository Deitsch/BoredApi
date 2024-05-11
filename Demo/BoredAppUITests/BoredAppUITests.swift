//
//  BoredAppUITests.swift
//  BoredAppUITests
//
//  Created by Simon Deutsch on 06.05.24.
//

import XCTest

final class BoredAppUITests: XCTestCase {

    override func setUpWithError() throws { }

    override func tearDownWithError() throws { }

    func testLoadActivity() throws {
        let app = XCUIApplication()
        app.setArgumentTestMode()
        app.launch()


        let activityNameField = app.staticTexts["acticity-name"]
        let activityNameFieldExists = activityNameField.waitForExistence(timeout: .default)

        if !activityNameFieldExists {
            XCTFail("Failed to load activity")
            return
        }
        let name1 = activityNameField.label
        app.navigationBars["I am Bored"].buttons["Refresh"].tap()
        let name2 = activityNameField.label
        
        XCTAssertNotEqual(name1, name2)

    }
}

extension XCUIApplication {
    func setArgumentTestMode() {
        launchArguments = ["testMode"]
    }
}

extension TimeInterval {
    static let `default` = TimeInterval(2)
    static let long = TimeInterval(5)
}
