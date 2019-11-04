//
//  FastlaneSnapshot.swift
//  FastlaneSnapshot
//
//  Created by Luc-Antoine Dupont on 17/10/2019.
//  Copyright © 2019 Luc-Antoine Dupont. All rights reserved.
//

import XCTest

class FastlaneSnapshot: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        
        let app = XCUIApplication()
        setupSnapshot(app)
        app.launch()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
    


    func testGenerateScreenshots() {
        let app = XCUIApplication()
        let tablesQuery = app.tables
        screenshotEnglish(app, tablesQuery)
    }
    
    private func screenshotFrench(_ app: XCUIElement, _ tablesQuery: XCUIElementQuery) {
        snapshot("Categories")
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Livres"]/*[[".cells.staticTexts[\"Livres\"]",".staticTexts[\"Livres\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        snapshot("Items")
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Ne t'enfuis plus"]/*[[".cells.staticTexts[\"Ne t'enfuis plus\"]",".staticTexts[\"Ne t'enfuis plus\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        snapshot("Features")
        tablesQuery.cells.containing(.staticText, identifier:"Auteur").children(matching: .button).element.tap()
        snapshot("FeatureChoice")
        app.tabBars.buttons["Carte"].tap()
        snapshot("Annotations")
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Château de Chantilly"]/*[[".cells.staticTexts[\"Château de Chantilly\"]",".staticTexts[\"Château de Chantilly\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        snapshot("AnnotationDetails")
//        let button = app.navigationBars["39 km"].children(matching: .button).element(boundBy: 1)
//        button.tap()
//        snapshot("Map")
    }
    
    private func screenshotEnglish(_ app: XCUIElement, _ tablesQuery: XCUIElementQuery) {
        snapshot("Categories")
        
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Books"]/*[[".cells.staticTexts[\"Books\"]",".staticTexts[\"Books\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        snapshot("Items")
        
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Orléans"]/*[[".cells.staticTexts[\"Orléans\"]",".staticTexts[\"Orléans\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        snapshot("Features")
        
        tablesQuery.cells.containing(.staticText, identifier:"Author").buttons["Details"].tap()
        snapshot("FeatureChoice")
        
        app.tabBars.buttons["Carte"].tap()
        //        app.alerts["Allow “Storage” to access your location?"].scrollViews.otherElements.buttons["Allow While Using App"].tap()
        snapshot("Annotations")
        
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Empire State Building"]/*[[".cells.staticTexts[\"Empire State Building\"]",".staticTexts[\"Empire State Building\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        snapshot("AnnotationDetails")
        
//        app.navigationBars["4139 km"].children(matching: .button).element(boundBy: 1).tap()
//        snapshot("Map")
    }

}
