//
//  EpisodesViewController.swift
//  Episodes
//
//  Created by Tarkhan Tahirov on 02.06.22.
//

import UIKit

class EpisodesViewController: UIViewController {
    
    var tableview = UITableView()
    var viewModel: EpisodesViewModeling
    
    init(viewModel: EpisodesViewModeling) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        setupViewModel()
    }
    
    private func setupTableView() {
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.backgroundColor = .clear
        tableview.dataSource = self
        tableview.separatorStyle = .none
        tableview.register(EpisodeCell.self, forCellReuseIdentifier: EpisodeCell.id)
        
        let refreshControl = UIRefreshControl()
        tableview.refreshControl = refreshControl
        
        refreshControl.addTarget(self, action: #selector(fetchEpisodes), for: .valueChanged)
        
        view.addSubview(tableview)
        
        let guide = view.safeAreaLayoutGuide
        tableview.leadingAnchor.constraint(equalTo: guide.leadingAnchor).isActive = true
        tableview.topAnchor.constraint(equalTo: guide.topAnchor).isActive = true
        tableview.bottomAnchor.constraint(equalTo: guide.bottomAnchor).isActive = true
        tableview.trailingAnchor.constraint(equalTo: guide.trailingAnchor).isActive = true
    }
    
    private func setupNavigationBar() {
        let sortButton = UIBarButtonItem(title: "Sort   ", style: .plain, target: self, action: #selector(sortEpisodes))
        navigationItem.rightBarButtonItem = sortButton
    }
    
    private func setupViewModel() {
        
        viewModel.reloadTableClosure = { [weak self] in
            self?.tableview.reloadData()
        }
        
        viewModel.loadingClosure = { [unowned self] in
            if self.viewModel.isLoading {
                self.tableview.refreshControl?.beginRefreshing()
            } else {
                self.tableview.refreshControl?.endRefreshing()
            }
        }
        
        viewModel.fetchEpisodes()
    }
    
    @objc func fetchEpisodes() {
        viewModel.fetchEpisodes()
    }
    
    @objc func sortEpisodes() {
        viewModel.changeSortingStatus()
        viewModel.sortEpisodes()
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
}

extension EpisodesViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellVieModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EpisodeCell.id) as! EpisodeCell
        cell.configure(viewModel.cellVieModels[indexPath.row])
        return cell
    }
    
}
