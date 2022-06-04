//
//  MockNetworkClient.swift
//  EpisodesTests
//
//  Created by Tarkhan Tahirov on 02.06.22.
//

import Foundation
@testable import Episodes

class MockNetworkClient: EpisodesNetworkClientProtocol {
    
    var isFetchEpisodesCalled = false
    
    var completionEpisodes: [Episode] = []
    var completionClosure: ((Result<[Episode], NetworkError>) -> ())?
    
    func getEpisodes(completion: @escaping (Result<[Episode], NetworkError>) -> ()) {
        isFetchEpisodesCalled = true
        completionClosure = completion
    }
    
    func fetchSuccess() {
        completionClosure?(.success(completionEpisodes))
    }
    
    func fetchFail(error: NetworkError) {
        completionClosure?(.failure(error))
    }
    
}
