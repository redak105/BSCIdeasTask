//
//  BSCIdeasTaskTests.swift
//  BSCIdeasTaskTests
//
//  Created by Radek Zmeskal on 26/05/2018.
//  Copyright © 2018 Radek Zmeskal. All rights reserved.
//

import XCTest

class BSCIdeasTaskTests: XCTestCase {
    
    /// sesion test
    var sessionTest: URLSession!
    
    override func setUp() {
        super.setUp()
        sessionTest = URLSession(configuration: URLSessionConfiguration.default)
    }
    
    override func tearDown() {
        sessionTest = nil
        super.tearDown()
    }
    
    // Asynchronous test: success fast, failure slow
    func testServer() {
        // create request
        let url = URL(string: "http://private-9aad-note10.apiary-mock.com/notes")
        
        // create expectation return valur
        let promise = expectation(description: "Status code: 200")
        
        // test connection
        let dataTask = sessionTest.dataTask(with: url!) { data, response, error in
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                // test response
                if statusCode == 200 {
                    promise.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        // run task
        dataTask.resume()
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
