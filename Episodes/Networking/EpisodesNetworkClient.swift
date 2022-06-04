//
//  EpisodesNetworkClient.swift
//  Episodes
//
//  Created by Tarkhan Tahirov on 02.06.22.
//

import Foundation

enum NetworkError: String, Error {
    case dummyError = "Error that simulates network error"
}

protocol EpisodesNetworkClientProtocol {
    func getEpisodes(completion: @escaping (Result<[Episode], NetworkError>) -> ())
}

class EpisodesNetworkClient: EpisodesNetworkClientProtocol {
    
    private var responseTime: UInt32
    
    init(responseTime: UInt32 = 2) {
        self.responseTime = responseTime
    }
    
    func getEpisodes(completion: @escaping (Result<[Episode], NetworkError>) -> ()) {
        DispatchQueue.global().async {
            sleep(self.responseTime)
            DispatchQueue.main.async {
                let path = Bundle.main.path(forResource: "episodes", ofType: "json")!
                let data = try! Data(contentsOf: URL(fileURLWithPath: path))
                let episodes = try! JSONDecoder().decode([Episode].self, from: data)
                completion(.success(episodes))
            }
        }
    }
    
}
