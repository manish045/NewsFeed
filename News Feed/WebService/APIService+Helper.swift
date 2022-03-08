//
//  APIService+Helper.swift
//  News Feed
//
//  Created by Manish Tamta on 04/03/2022.
//

import Foundation
import Alamofire

enum APIError: Error, Equatable {
    
    case parsingFailed
    case somethingWrong
    case noNetwork
    case serverError(String)
    case generalError(String)
    
    var asString: String {
        switch self {
        case .parsingFailed, .somethingWrong:
            return CommonErrors.somethingWentWrong
        case .noNetwork:
            return CommonErrors.noNetwork
        case .serverError(let str):
            return str
        case .generalError(let str):
            return str
        }
    }
}

extension APIService {
    //MARK: WeSservice parsing helper
        
    func isNetwork() -> Bool {
        if Network().isConnectedToInternet != nil {
            return false
        }
        return true
    }
}

class Network {
    
    public enum ReachabilityStatus {
        case unknown
        case notReachable
        case reachable
    }
    
    let reachabilityManager: NetworkReachabilityManager?

    init() {
        reachabilityManager = NetworkReachabilityManager()
        reachabilityManager?.startListening()
    }
    
    var isConnectedToInternet: String? {
        guard NetworkReachabilityManager()?.isReachable ?? false else {
            return CommonErrors.noNetwork
        }
        return nil
    }
    
    var isNetworkAvailable: Bool {
        NetworkReachabilityManager()?.isReachable ?? false
    }
    
    func subscribeIsReachable(status: ((ReachabilityStatus) -> Void)?) {
        reachabilityManager?.listener = { localStatus in
            print("Network Status: \(localStatus)")
                switch localStatus {
                case .notReachable:
                    status?(ReachabilityStatus.notReachable)
                case .reachable(_), .unknown:
                    status?(ReachabilityStatus.reachable)
            }
        }
    }
}


extension DataRequest {
    //MARK: Base DataRequest
    
    fileprivate func decodableResponseSerializer<T: Decodable>() -> DataResponseSerializer<T> {
        return DataResponseSerializer { _, response, data, error in
            print("URL: \(response?.url?.absoluteString ?? "-")")
            guard error == nil else { return .failure(error!) }

            guard let data = data else {
                return .failure(AFError.responseSerializationFailed(reason: .inputDataNil))
            }

            return Result { try newJSONDecoder().decode(T.self, from: data) }
        }
    }

    @discardableResult
    func responseDecodable<T: Decodable>(queue: DispatchQueue? = nil, completionHandler: @escaping (DataResponse<T>) -> Void) -> Self {
        return response(queue: queue, responseSerializer: decodableResponseSerializer(), completionHandler: completionHandler)
    }
}

