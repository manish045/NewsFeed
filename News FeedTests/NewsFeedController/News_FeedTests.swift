//
//  News_FeedTests.swiftx
//  News FeedTests
//
//  Created by Manish Tamta on 04/03/2022.
//

import XCTest
import Combine
@testable import News_Feed

class News_FeedTests: XCTestCase {
    
    private var newsFeedModel: NewsFeedModel!
    private var controller: NewsFeedViewController!

    private var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        guard let pathString = Bundle(for: type(of: self)).path(forResource: "NewsSample", ofType: "json") else {
            fatalError("json not found")
        }
        
        guard let json = try? String(contentsOfFile: pathString, encoding: .utf8) else {
            fatalError("unable to convert json into string")
        }
        
        let jsonData = json.data(using: .utf8)!
        newsFeedModel = try! JSONDecoder().decode(NewsFeedModel.self, from: jsonData)
        cancellables = []
        controller = NewsFeedViewController()
    }

    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {

        XCTAssertNotNil(newsFeedModel)
        let pagination = newsFeedModel.pagination
        XCTAssertEqual(pagination?.limit, 20)
        XCTAssertEqual(pagination?.offset, 1)
        XCTAssertEqual(pagination?.count, 20)
        XCTAssertEqual(pagination?.total, 10000)

        let feedDataArray = newsFeedModel.data!
        XCTAssertEqual(feedDataArray.count, 4)

        let feedData = feedDataArray[0]

        XCTAssertEqual(feedData.title!, "Ceuta : Cinq mineurs marocains portés disparus après avoir tenté de se rendre en Espagne")
        XCTAssertEqual(feedData.datumDescription!, "En Espagne et à Ceuta, les autorités locales et les ONG sont mobilisées depuis mardi 30 novembre, après la disparition de cinq mineurs marocains isolés arrivés dans la ville en mai, qui auraient entrepris la traversée de la ville autonome en direction de la péninsule. Selon l’agence espagnole EFE et le média local El Faro de Ceuta, Ahmed El Mehdi, Alae Akka, Tarik Rbati, Brahim Abughar et Yahya Laroussi se seraient rencontrés, la nuit du mardi 30 novembre, pour «monter à bord d’un bateau gris» et partir pour l’Espagne.")
        XCTAssertEqual(feedData.imageURL!, URL(string: "https://static.yabiladi.com/files/articles/ed7288c2211a776093a110c84dc3ee8f20211207154320150.jpg"))
    }
    
    func testFeedViewController() {
        controller.viewModel = DummyFeedViewModel()

        let viewModel = controller.viewModel!
        XCTAssertTrue(viewModel.newsFeedArray.count == 0)
        
        let expectation = XCTestExpectation(description: "feedRecieved")
        let loaderExpectation = XCTestExpectation(description: "showLoader")
        let errorExpectation = XCTestExpectation(description: "Error Occured")
        let noDataFoundExpectation = XCTestExpectation(description: "No Data Found")
        
        viewModel.newsFeedPublisher
            .sink (receiveValue: { value in
                XCTAssertEqual(value, viewModel.newsFeedArray)
                expectation.fulfill()
            })
            .store(in: &cancellables)
        
        viewModel.showLoader
            .sink { _ in
                loaderExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.didGetError
            .sink { _ in
                errorExpectation.fulfill()
            }
            .store(in: &cancellables)
        
        
        viewModel.noDataFound
            .sink { _ in
                noDataFoundExpectation.fulfill()
            }
            .store(in: &cancellables)
    }
    
    override func tearDown() {
        newsFeedModel = nil
        cancellables = nil
        controller = nil
    }
}

class DummyFeedViewModel: NewsFeedViewProtocol {
    var noDataFound: PassthroughSubject<Bool, Never>
    
    @Published var newsFeedArray: [FeedData]
    var newsFeedPublisher: Published<[FeedData]>.Publisher { $newsFeedArray }
    
    var didGetError: PassthroughSubject<APIError, Never>
    
    var showLoader: PassthroughSubject<Bool, Never>
    
    init() {
        newsFeedArray = []
        didGetError = PassthroughSubject()
        showLoader = PassthroughSubject()
        noDataFound = PassthroughSubject()
    }
    
    func showNewsDetail(feedData: FeedData) {
        self.showLoader.send(true)
        self.didGetError.send(.noNetwork)
    }
}
