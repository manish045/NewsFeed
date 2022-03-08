//
//  APIService+URL.swift
//  News Feed
//
//  Created by Manish Tamta on 04/03/2022.
//

import Foundation
import Alamofire

enum APIEnvironment {
    case staging
    case production
    
    var baseURL: String {
        switch self {
        case .staging:
            return "http://api.mediastack.com/v1/"
        case .production:
            return ""
        }
    }
}

enum EndPoints {
    case newsFeed
    
    var url: String {
        switch self {
        case .newsFeed:
            return "news"
        }
    }
    
    var httpMethod: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }
}

extension APIService {
    struct URLString {
        private static let environment = APIEnvironment.staging
        static var base: String { environment.baseURL }
        static var socketBaseURL: String { environment.baseURL }
    }
    
    static func URL(_ endPoint: EndPoints) -> String {
        return URLString.base + endPoint.url
    }
}

