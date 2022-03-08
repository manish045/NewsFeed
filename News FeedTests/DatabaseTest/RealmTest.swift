//
//  RealmTest.swift
//  News FeedTests
//
//  Created by Manish Tamta on 08/03/2022.
//

import XCTest
import RealmSwift
@testable import News_Feed

class RealmTest: XCTestCase {
    
    var dataBase: NewsDBHandler!
    var newsFeedModel: NewsFeedModel!
    
    override func setUp() {
        dataBase = NewsDBHandler.shared
        
        // Use an in-memory Realm identified by the name of the current test.
        // This ensures that each test can't accidentally access or modify the data
        // from other tests or the application itself, and because they're in-memory,
        // there's nothing that needs to be cleaned up.
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        let realm = try! Realm()
        XCTAssertNotNil(realm)
        
        
        guard let pathString = Bundle(for: type(of: self)).path(forResource: "NewsSample", ofType: "json") else {
            fatalError("json not found")
        }
        
        guard let json = try? String(contentsOfFile: pathString, encoding: .utf8) else {
            fatalError("unable to convert json into string")
        }
        
        let jsonData = json.data(using: .utf8)!
        newsFeedModel = try! JSONDecoder().decode(NewsFeedModel.self, from: jsonData)
    }
    
    override func tearDown() {
        dataBase = nil
    }
    
    func test_NewsFeed_Initially_ShouldBeZero()
        {
            XCTAssertEqual(dataBase.fetchNews()?.count, 0, "count should be 0")
        }
    
    func test_NewsFeed_AfterAddingNews() {
        let feedDataModel = newsFeedModel.data![0]
        dataBase.saveNews(newsFeedModel: feedDataModel)
        let fetchData = dataBase.fetchNews()
        XCTAssertEqual(fetchData?.count, 1, "count should be 1")
        
        let model = fetchData!.first
        XCTAssertEqual(model, newsFeedModel.data![0])
    }
}
