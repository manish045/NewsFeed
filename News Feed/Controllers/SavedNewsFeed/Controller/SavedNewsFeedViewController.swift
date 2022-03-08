//
//  SavedNewsFeedViewController.swift
//  News Feed
//
//  Created by Manish Tamta on 07/03/2022.
//

import UIKit
import Combine


// This controller only shows the data that is being saved in the database
class SavedNewsFeedViewController: BaseViewController {
    
    enum Section: Int, CaseIterable {
        case data = 0
        case loader
    }

    @IBOutlet weak var tableView: UITableView!
        
    var viewModel: SavedNewsFeedViewProtocol!
    var cancellables: Set<AnyCancellable> = []
    var activityIndicator = UIActivityIndicatorView()
    var emptyView: EmptyView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        registerTableView()
        addObservers()
        newsFeedPublisher()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.changeTabBar(hidden: false)
        // This will refresh the saved data
        viewModel.fetchSaveData()
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
    
    //// whenever data is fetched this publisher get called
    private func newsFeedPublisher() {
        viewModel.newsFeedPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
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
            emptyView?.setUpData(emptyScreenTitle: "No Save News Found", image: UIImage(systemName: "arrow.clockwise.circle"))
            emptyView?.hideRetryButton()
            self.view.addSubview(emptyView!)
        }else{
            self.view.addSubview(emptyView!)
        }
    }
    
    private func removeEmptyView() {
        self.emptyView?.removeFromSuperview()
    }
}

extension SavedNewsFeedViewController: UITableViewDelegate {
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

extension SavedNewsFeedViewController: UITableViewDataSource {
    
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
        if indexPath.section == Section.data.rawValue && indexPath.row == viewModel.newsFeedArray.count - 8 {
            viewModel.callNewsFeedAPI()
        }
    }
}
