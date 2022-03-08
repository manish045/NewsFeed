//
//  NewsDBHandler.swift
//  News Feed
//
//  Created by Manish Tamta on 07/03/2022.
//

import Foundation
import RealmSwift

final class NewsDBHandler {
        
    typealias CompletionHandler = (Result<FeedData, APIError>) -> Void

    private(set) var feedDataModel: Results<FeedData>?
    
    static let shared = NewsDBHandler()
    private init() {}
    
    func fetchNews() -> Results<FeedData>? {
        let realm = try! Realm()
        self.feedDataModel = realm.objects(FeedData.self)
        return self.feedDataModel
    }
    
    func saveNews(newsFeedModel: FeedData) {
        do {
            try Database.saveObject(object: newsFeedModel, queue: nil)
        }
        catch {
            print(error.localizedDescription)
        }
        self.feedDataModel = self.fetchNews()
    }
}
