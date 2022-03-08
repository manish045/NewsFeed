//
//  NewsDetailTest.swift
//  News FeedTests
//
//  Created by Manish Tamta on 08/03/2022.
//

import XCTest
import Combine

@testable import News_Feed

class NewsDetailTest: XCTestCase {
    
    private var controller: NewsDetailViewController!
    private var viewModel: DummyNewsDetailViewModel!
    private var feedModel: FeedData!
    private var cancellables: Set<AnyCancellable>!

    override func setUp() {
        
        guard let pathString = Bundle(for: type(of: self)).path(forResource: "NewsSample", ofType: "json") else {
            fatalError("json not found")
        }
        
        guard let json = try? String(contentsOfFile: pathString, encoding: .utf8) else {
            fatalError("unable to convert json into string")
        }
        
        let jsonData = json.data(using: .utf8)!
        let newsFeedModel = try! JSONDecoder().decode(NewsFeedModel.self, from: jsonData)
        
        feedModel = newsFeedModel.data![0]
        viewModel = DummyNewsDetailViewModel(feedModel: feedModel)
        controller = NewsDetailViewController()
        cancellables = []        
    }
    
    override func tearDown() {
        feedModel = nil
        viewModel = nil
        controller = nil
        cancellables = nil
    }
    
    func test_NewsSentToDetail() {
        let feedModelData = viewModel.feedModelData
        XCTAssertNotNil(feedModelData)

        XCTAssertEqual(feedModelData.title!, "Ceuta : Cinq mineurs marocains portés disparus après avoir tenté de se rendre en Espagne")
        XCTAssertEqual(feedModelData.datumDescription!, "En Espagne et à Ceuta, les autorités locales et les ONG sont mobilisées depuis mardi 30 novembre, après la disparition de cinq mineurs marocains isolés arrivés dans la ville en mai, qui auraient entrepris la traversée de la ville autonome en direction de la péninsule. Selon l’agence espagnole EFE et le média local El Faro de Ceuta, Ahmed El Mehdi, Alae Akka, Tarik Rbati, Brahim Abughar et Yahya Laroussi se seraient rencontrés, la nuit du mardi 30 novembre, pour «monter à bord d’un bateau gris» et partir pour l’Espagne.")
        XCTAssertEqual(feedModelData.imageURL!, URL(string: "https://static.yabiladi.com/files/articles/ed7288c2211a776093a110c84dc3ee8f20211207154320150.jpg"))
    }
    
    func test_NewsDetailProtocol() {
        
        let expectation = XCTestExpectation(description: "feedRecieved")
        viewModel.feedModelPublisher
            .sink (receiveValue: { [weak self] value in
                XCTAssertEqual(value, self?.viewModel.feedModelData)
                expectation.fulfill()
            })
            .store(in: &cancellables)
    }
}

final class DummyNewsDetailViewModel: NewsDetailViewProtocol {

    @Published var feedModelData: FeedData
    var feedModelPublisher: Published<FeedData>.Publisher {$feedModelData}
    
    init(feedModel: FeedData) {
        self.feedModelData = feedModel
    }
}
