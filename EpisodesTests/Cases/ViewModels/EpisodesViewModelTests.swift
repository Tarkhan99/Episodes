//
//  EpisodesViewModelTests.swift
//  EpisodesTests
//
//  Created by Tarkhan Tahirov on 02.06.22.
//

import XCTest
@testable import Episodes

class EpisodesViewModelTests: XCTestCase {
    
    var sut: EpisodesViewModel!
    var mockNetworkClient: MockNetworkClient!
    
    override func setUp() {
        super.setUp()
        mockNetworkClient = MockNetworkClient()
        sut = EpisodesViewModel(networkClient: mockNetworkClient)
    }
    
    override func tearDown() {
        mockNetworkClient = nil
        sut = nil
        super.tearDown()
    }
    
    func givenEpisodes() throws {
        let data = try Data.fromJSON(fileName: "valid_response")
        mockNetworkClient.completionEpisodes = try JSONDecoder().decode([Episode].self, from: data)
    }
    
    func givenEpisode(with startTime: Int64) -> Episode {
        return Episode(
            id: "id",
            imageUrl: "imageUrl",
            startTime: startTime,
            endTime: 1234,
            episodeTitle: "episodeTitle",
            title: "title"
        )
    }
    
    func test_init_setsNetworkClient() throws {
        let actual = try XCTUnwrap(sut.networkClient as? MockNetworkClient)
        XCTAssertTrue(actual === mockNetworkClient)
    }
    
    func test_conformsTo_EpisodesViewModeling() {
        XCTAssertTrue((sut as Any) is EpisodesViewModeling)
    }
    
    func test_episodesViewModeling_declaresFetchEpisodes() {
        let viewModeling = sut as EpisodesViewModeling
        
        // then
        viewModeling.fetchEpisodes()
    }
    
    func test_fetchEpisodes_sendsRequest() {
        // when
        sut.fetchEpisodes()
        
        // then
        XCTAssertTrue(mockNetworkClient.isFetchEpisodesCalled)
    }
    
    func test_fetchEpisodes_whenReturnsError_setsErrorMessage() {
        // given
        let expectedError = NetworkError.dummyError
        
        // when
        sut.fetchEpisodes()
        
        mockNetworkClient.fetchFail(error: .dummyError)
        
        // then
        XCTAssertEqual(sut.errorMessage, expectedError.rawValue)
    }
    
    func test_removeDuplicates() {
        // given
        let givenArray = [1,3,3,5]
        let expectedResult = [1,3,5]
        
        // when
        let result = givenArray.removeDuplicates()
        
        // then
        XCTAssertEqual(result, expectedResult)
    }
    
    func test_fetchEpisodes_whenReturnsEpisodes_setsCellViewModels() throws {
        // given
        try givenEpisodes()
        let expectedEpisodes = mockNetworkClient.completionEpisodes.removeDuplicates()
        
        // when
        sut.fetchEpisodes()
        mockNetworkClient.fetchSuccess()
        
        // then
        XCTAssertEqual(sut.episodes, expectedEpisodes)
        XCTAssertEqual(sut.cellVieModels.count, expectedEpisodes.count)
    }
    
    func test_fetchEpisodes_updatesLoadingStatus() {
        // given
        var loadingStatus = false
        let expectation = XCTestExpectation(description: "Loading status updated")
        sut.loadingClosure = { [weak self] in
            loadingStatus = self!.sut.isLoading
            expectation.fulfill()
        }
        
        // when
        sut.fetchEpisodes()
        
        XCTAssertTrue(loadingStatus)
        
        mockNetworkClient.fetchSuccess()
        XCTAssertFalse(loadingStatus)
        
        wait(for: [expectation], timeout: 0.05)
    }
    
    func test_fetchEpisodes_didSetCellVMs_reloadClosureTrigers() throws {
        // given
        try givenEpisodes()
        let expectation = XCTestExpectation(description: "reload closure trigered")
        sut.reloadTableClosure = {
            expectation.fulfill()
        }
        
        // when
        sut.fetchEpisodes()
        mockNetworkClient.fetchSuccess()
        
        // then
        wait(for: [expectation], timeout: 0.05)
    }
    
    func test_fetchEpisodes_didSetErrorMessage_alertClosureTrigers() throws {
        // given
        try givenEpisodes()
        let expectation = XCTestExpectation(description: "alert closure trigered")
        sut.showAlertClosure = {
            expectation.fulfill()
        }
        
        // when
        sut.fetchEpisodes()
        mockNetworkClient.fetchFail(error: .dummyError)
        
        // then
        wait(for: [expectation], timeout: 0.05)
    }
    
    func test_changeSortingStatus_givenDescending_setsSortStatusToAscending() {
        // given
        sut.sortStatus = .descending
        
        // when
        sut.changeSortingStatus()
        
        // then
        XCTAssertEqual(sut.sortStatus, .ascending)
    }
    
    func test_changeSortingStatus_givenAscending_setsSortStatusToDescending() {
        // given
        sut.sortStatus = .ascending
        
        // when
        sut.changeSortingStatus()
        
        // then
        XCTAssertEqual(sut.sortStatus, .descending)
    }
    
    func test_sortEpisodes_whenDescending() {
        // given
        let episode1 = givenEpisode(with: 123)
        let episode2 = givenEpisode(with: 176)
        let episode3 = givenEpisode(with: 145)
        
        let givenEpisodes = [episode1, episode2, episode3]
        sut.episodes = givenEpisodes
        
        let expectedEpisodes = [episode2, episode3, episode1]
        
        // when
        sut.sortStatus = .descending
        sut.sortEpisodes()
        
        // then
        XCTAssertEqual(sut.episodes, expectedEpisodes)
    }
    
    func test_sortEpisodes_whenAscending() {
        // given
        let episode1 = givenEpisode(with: 123)
        let episode2 = givenEpisode(with: 176)
        let episode3 = givenEpisode(with: 145)
        
        let givenEpisodes = [episode1, episode2, episode3]
        sut.episodes = givenEpisodes
        
        let expectedEpisodes = [episode1, episode3, episode2]
        
        // when
        sut.sortStatus = .ascending
        sut.sortEpisodes()
        
        // then
        XCTAssertEqual(sut.episodes, expectedEpisodes)
    }
    
}
