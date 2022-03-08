//
//  NewsFeedViewModel.swift
//  News Feed
//
//  Created by Manish Tamta on 04/03/2022.
//

import Foundation
import Combine

protocol NewsFeedViewProtocol: ViewModel {
    var newsFeedArray: [FeedData] {get set} 
    var newsFeedPublisher: Published<[FeedData]>.Publisher { get }
    func showNewsDetail(feedData: FeedData)
    var noDataFound:PassthroughSubject<Bool, Never> {get set}
    func callNewsFeedAPI()
}

extension NewsFeedViewProtocol {
    func callNewsFeedAPI() {}
}

final class NewsFeedViewModel: NewsFeedViewProtocol {
   
    @Published var newsFeedArray = [FeedData]()
    @Published var showLoaderBool = false
    
    var newsFeedPublisher: Published<[FeedData]>.Publisher { $newsFeedArray }
    var didGetError: PassthroughSubject<APIError, Never>
    var showLoader: PassthroughSubject<Bool, Never>
    var noDataFound: PassthroughSubject<Bool, Never>

    private var limit = AppConstant.pageLimit
    private var offset = 0
    private var totalNewsCount: Int?
    private var coordinator: FeedCoordinatorView
    
    init(coordinator: FeedCoordinatorView) {
        self.coordinator = coordinator
        didGetError = PassthroughSubject()
        showLoader = PassthroughSubject()
        noDataFound = PassthroughSubject()
        self.showLoader.send(true)
    }
    
    func callNewsFeedAPI() {
        if totalNewsCount != nil && self.newsFeedArray.count == totalNewsCount {return}
        
        let param = [
            "offset": offset,
            "limit": limit,
            "access_key": AppConstant.apikey
        ] as [String : Any]
        
        self.showLoader.send(true)
        APIService.shared.performRequest(endPoint: .newsFeed, parameters: param) { [weak self] (result: APIResult<NewsFeedModel, APIError>) in
            switch result {
            case .success(let model):
                guard let self = self else {return}
                if let feedData = model.data {
                    self.offset += 1
                    self.newsFeedArray.append(contentsOf: feedData)
                }

                self.totalNewsCount = model.pagination?.total ?? 0
                if self.newsFeedArray.count == self.totalNewsCount {
                    self.showLoader.send(false)
                }
                self.checkForData()
            case .error(let error):
                self?.checkForData()
                self?.didGetError.send(error)
            }
        }
    }
    
    func checkForData() {
        noDataFound.send(newsFeedArray.count == 0)
    }
    
    func showNewsDetail(feedData: FeedData) {
        coordinator.showDetailPage(feedData: feedData)
    }
}
