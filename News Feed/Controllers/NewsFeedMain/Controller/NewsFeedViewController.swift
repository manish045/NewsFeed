//
//  ViewController.swift
//  News Feed
//
//  Created by Manish Tamta on 04/03/2022.
//

import UIKit
import Combine

class NewsFeedViewController: BaseViewController {
    
    enum Section: Int, CaseIterable {
        // Shows the number of rows equal to the data fetched from server
        case data
        
        // This section shows the activity indicator untill all the data is fetched from server
        case loader
    }

    @IBOutlet weak var tableView: UITableView!
        
    var viewModel: NewsFeedViewProtocol!
    var cancellables: Set<AnyCancellable> = []
    var loadMoreData = false /// Setting up condition to load more data from server
    var activityIndicator = UIActivityIndicatorView()
    
    var emptyView: EmptyView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        registerTableView()
        addObservers()
        newsFeedPublisher()
        viewModel.callNewsFeedAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.changeTabBar(hidden: false)
    }
    
    private func addObservers() {
        /// decides when to stop activity indicator
        viewModel.showLoader
            .receive(on: RunLoop.main)
            .sink { [weak self] show in
                show ? self?.activityIndicator.startAnimating() : self?.activityIndicator.stopAnimating()
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        /// error occured then show alert and stop activity indicator
        viewModel.didGetError
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                self?.activityIndicator.stopAnimating()
                self?.showAlert(message: error.asString)
            }
            .store(in: &cancellables)
        
        viewModel.noDataFound
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] noDataFound in
                print(noDataFound)
                self?.showEmptyScreen()
            })
            .store(in: &cancellables)
    }
    
    /// whenever there is a change in feed array this publisher get called
    private func newsFeedPublisher() {
        viewModel.newsFeedPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] data in
                /// when new data is loaded setting searching more data for pagination
                print(data)
                self?.loadMoreData = true
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func registerTableView() {
        tableView.registerNibCell(ofType: NewsFeedTableViewCell.self)
        tableView.registerNibCell(ofType: FooterLoaderTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    private func showEmptyScreen() {
        if viewModel.newsFeedArray.count > 0 {
            removeEmptyView()
            return
        }
        if emptyView == nil {
            emptyView = EmptyView(frame: self.view.bounds)
            self.view.addSubview(emptyView!)
            emptyView?.setUpData(emptyScreenTitle: StringConstant.NewsFeedViewController.noDataFound, image: UIImage(systemName: "arrow.clockwise.circle"))
            self.emptyView?.retryButtonTapped
                .receive(on: RunLoop.main)
                .sink(receiveValue: { [weak self] in
                    self?.removeEmptyView()
                    self?.viewModel.callNewsFeedAPI()
                })
                .store(in: &cancellables)
        }else{
            self.view.addSubview(emptyView!)
        }
    }
    
    private func removeEmptyView() {
        self.emptyView?.removeFromSuperview()
    }
}

extension NewsFeedViewController: UITableViewDelegate {
    ///Show selected news on detail page
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Section.data.rawValue == indexPath.section {
            let model = viewModel.newsFeedArray[indexPath.row]
            viewModel.showNewsDetail(feedData: model)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension NewsFeedViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .data:
            return viewModel.newsFeedArray.count
        default:
            return activityIndicator.isAnimating ? 1: 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch Section(rawValue: indexPath.section) {
        case .data:
            let cell = tableView.dequeueCell(ofType: NewsFeedTableViewCell.self)
            let model = viewModel.newsFeedArray[indexPath.row]
            cell.model = model
            return cell
        default:
            let cell = tableView.dequeueCell(ofType: FooterLoaderTableViewCell.self)
            activityIndicator = cell.viewWithTag(1)! as! UIActivityIndicatorView
            activityIndicator.startAnimating()
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        // once the the load more data called setting to loadMoreData to false inorder to reduce the unneccessary calls to server
        if indexPath.section == Section.data.rawValue && indexPath.row == viewModel.newsFeedArray.count - 8 && loadMoreData {
            loadMoreData = false
            viewModel.callNewsFeedAPI()
        }
    }
}
