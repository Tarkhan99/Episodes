//
//  MockEpisodesViewModel.swift
//  EpisodesTests
//
//  Created by Tarkhan Tahirov on 03.06.22.
//

import Foundation
@testable import Episodes

class MockEpisodesViewModel: EpisodesViewModeling {
    
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
    
    var calledFetchEpisodes = false
    func fetchEpisodes() {
        calledFetchEpisodes = true
    }
    
    var isSortEpisodeCalled = false
    func sortEpisodes() {
        isSortEpisodeCalled = true
    }
    
    func changeSortingStatus() {
        if sortStatus == .descending {
            sortStatus = .ascending
        } else {
            sortStatus = .descending
        }
    }
    
}
