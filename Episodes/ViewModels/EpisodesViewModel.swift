//
//  EpisodesViewModel.swift
//  Episodes
//
//  Created by Tarkhan Tahirov on 02.06.22.
//

import Foundation

enum SortStatus {
    case ascending, descending
}

protocol EpisodesViewModeling {
    
    var episodes: [Episode] { get set }
    var cellVieModels: [EpisodeCellViewModeling] { get }
    var errorMessage: String? { get }
    var isLoading: Bool { get }
    
    var sortStatus: SortStatus { get set }
    
    var reloadTableClosure: (() -> ())? { get set }
    var showAlertClosure: (() -> ())? { get set }
    var loadingClosure: (() -> ())? { get set }
    
    func fetchEpisodes()
    func sortEpisodes()
    func changeSortingStatus()
}

class EpisodesViewModel: EpisodesViewModeling {
    
    var episodes: [Episode] = []
    
    var cellVieModels: [EpisodeCellViewModeling] = [] {
        didSet {
            reloadTableClosure?()
        }
    }
    
    var errorMessage: String? {
        didSet {
            showAlertClosure?()
        }
    }
    
    var isLoading: Bool = false {
        didSet {
            loadingClosure?()
        }
    }
    
    var sortStatus: SortStatus = .descending
        
    var reloadTableClosure: (() -> ())?
    var showAlertClosure: (() -> ())?
    var loadingClosure: (() -> ())?
    
    var networkClient: EpisodesNetworkClientProtocol
    
    init(networkClient: EpisodesNetworkClientProtocol) {
        self.networkClient = networkClient
    }
    
    func fetchEpisodes() {
        isLoading = true
        networkClient.getEpisodes { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let totalEpisodes):
                let uniqueEpisodes = totalEpisodes.removeDuplicates()
                self?.episodes = uniqueEpisodes
                self?.sortEpisodes()
            case .failure(let error):
                self?.errorMessage = error.rawValue
            }
        }
    }
    
    func sortEpisodes() {
        episodes = episodes.sorted(by: { first, second in
            switch sortStatus {
            case .ascending:
                return first.startTime < second.startTime
            case .descending:
                return first.startTime > second.startTime
            }
        })
        cellVieModels = episodes.map { EpisodeCellViewModel($0) }
        reloadTableClosure?()
    }
    
    func changeSortingStatus() {
        if sortStatus == .descending {
            sortStatus = .ascending
        } else {
            sortStatus = .descending
        }
    }
    
}

extension Array where Element: Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        self.forEach { element in
            if !result.contains(element) {
                result.append(element)
            }
        }
        return result
    }
}
