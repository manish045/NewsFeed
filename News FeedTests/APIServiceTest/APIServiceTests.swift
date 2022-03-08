//
//  APIServiceTest.swift
//  News FeedTests
//
//  Created by Manish Tamta on 08/03/2022.
//

import XCTest
@testable import News_Feed

class APIServiceTests: XCTestCase {
    
    var apiService: APIService?
    
    override func setUp() {
        apiService = APIService.shared
    }
    
    override func tearDown() {
        apiService = nil
    }
    
    func test_fetchNewsFeed() {
        let expect = XCTestExpectation(description: "callback")
        apiService?.performRequest(endPoint: .newsFeed, parameters: [:]) { (result: APIResult<TestModel, APIError>) in
            expect.fulfill()
        }
    }

   
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    struct TestModel: BaseModel {}

}
