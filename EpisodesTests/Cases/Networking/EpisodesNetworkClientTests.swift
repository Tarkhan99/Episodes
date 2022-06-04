//
//  EpisodesNetworkClientTests.swift
//  EpisodesTests
//
//  Created by Tarkhan Tahirov on 02.06.22.
//

import XCTest
@testable import Episodes

class EpisodesNetworkClientTests: XCTestCase {
    
    var sut: EpisodesNetworkClient!
    
    override func setUp() {
        super.setUp()
        sut = EpisodesNetworkClient(responseTime: 0)
    }
    
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    func test_conformsTo_episodesNetworkClientProtocol() {
        XCTAssertTrue((sut as Any) is EpisodesNetworkClientProtocol)
    }
    
    func test_episodesNetworkClientProtocol_declaresGetEpisodes() {
        let clientProtocol = sut as EpisodesNetworkClientProtocol
        clientProtocol.getEpisodes() { _ in }
    }
    
    func test_fetch_episodes() throws {
        // given
        let data = try Data.fromJSON(fileName: "valid_response")
        let expectedEpisodes = try JSONDecoder().decode([Episode].self, from: data)
        let expectation = XCTestExpectation(description: "callback")

        sut.getEpisodes() { result in
            expectation.fulfill()
            switch result {
            case .success(let episodes):
                XCTAssertEqual(episodes.count, 5)
                XCTAssertEqual(episodes, expectedEpisodes)
            case .failure(let error):
                XCTAssertEqual(error, .dummyError)
            }
        }

        
        wait(for: [expectation], timeout: 0.5)
    }
    
}
