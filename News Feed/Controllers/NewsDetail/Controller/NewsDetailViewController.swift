//
//  NewsDetailViewController.swift
//  News Feed
//
//  Created by Manish Tamta on 06/03/2022.
//

import UIKit
import Combine
import RealmSwift

class NewsDetailViewController: BaseViewController {
    
    enum Section:Int, CaseIterable {
        case title = 0
        case image
        case description
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    private var cancellables: Set<AnyCancellable> = []
    
    var viewModel: NewsDetailViewProtocol!
    var showSaveBarButton = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObservers()
        registerTableView()
        self.navigationController?.navigationBar.isHidden = false
        self.setTitleToBar(text: "", rightBarButtonNeeded: showSaveBarButton, rightButtonTitle: "Save")
        self.changeTabBar(hidden: true)
        // Do any additional setup after loading the view.
    }
    
    private func registerTableView() {
        tableView.registerNibCell(ofType: TitleDescriptionTableViewCell.self)
        tableView.registerNibCell(ofType: NewsImageTableViewCell.self)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func addObservers() {
        viewModel.feedModelPublisher
            .receive(on: RunLoop.main)
            .sink { [weak self] feedData in
                guard let self = self else {return}
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    override func rightBarButtonAction() {
        let model = viewModel.feedModelData
        let randomRoll = Int(arc4random_uniform(500000) + 1)
        model.uuid = "\(randomRoll)"
        NewsDBHandler.shared.saveNews(newsFeedModel: model)
        self.showAlert(message: "Your news has been saved")
    }
}

extension NewsDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension NewsDetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = Section(rawValue: indexPath.section)
        switch section {
        case .title, .description:
            let cell = tableView.dequeueCell(ofType: TitleDescriptionTableViewCell.self)
            (section == .title) ? (cell.setDataFor(title: viewModel.feedModelData.title)) : (cell.setDataFor(description: viewModel.feedModelData.datumDescription ))
            return cell
        default:
            let cell = tableView.dequeueCell(ofType: NewsImageTableViewCell.self)
            cell.imageURL = viewModel.feedModelData.imageURL
            return cell
        }
    }
}
