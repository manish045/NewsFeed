//
//  AppConstant.swift
//  News Feed
//
//  Created by Manish Tamta on 04/03/2022.
//

import Foundation


struct AppConstant {
    static let apikey = "e2ff9718dbe04551f0ea3c04fda38526"
    static let pageLimit = 30
}

struct StringConstant {
    enum TabBarCoordinator {
        static let news = "News"
        static let saveNews = "No News Found"
    }
    
    enum NewsFeedViewController {
        static let noDataFound = "No News Found"
    }
    
    enum SavedNewsFeedViewController {
        static let noSaveDataFound = "No Save News Found"
    }
}

enum CommonErrors {
    static let noNetwork = "No network available"
    static let somethingWentWrong = "Something went wrong, Please try again!"
}
