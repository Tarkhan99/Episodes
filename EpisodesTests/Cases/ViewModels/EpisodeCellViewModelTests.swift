//
//  EpisodeCellViewModel.swift
//  EpisodesTests
//
//  Created by Tarkhan Tahirov on 02.06.22.
//

import XCTest
@testable import Episodes

class EpisodeCellViewModelTests: XCTestCase {
    
    var sut: EpisodeCellViewModel!
    var episode: Episode!
    
    override func setUp() {
        super.setUp()
        whenCellViewModelFromEpisode()
    }
    
    override func tearDown() {
        episode = nil
        sut = nil
        super.tearDown()
    }
    
    func whenCellViewModelFromEpisode(
        id: String = "id",
        imageUrl: String = "imageUrl",
        startTime: Int64 = 1654644900,
        endTime: Int64 = 1654646100,
        episodeTitle: String = "episodeTitle",
        title: String = "title"
    ) {
        
        episode = Episode(
            id: id,
            imageUrl: imageUrl,
            startTime: startTime,
            endTime: endTime,
            episodeTitle: episodeTitle,
            title: title
        )
        
        sut = EpisodeCellViewModel(episode)
    }
    
    func  test_conformsTo_episodeCellViewModeling() {
        XCTAssertTrue((sut as Any) is EpisodeCellViewModeling)
    }
    
    func test_init_setsEpisode() {
        XCTAssertEqual(sut.episode, episode)
    }

    func test_initEpisode_setsImageURL() {
        XCTAssertEqual(sut.imageURL, episode.imageUrl)
    }

    func test_initEpisode_setsTitle() {
        XCTAssertEqual(sut.title, episode.title)
    }

    func test_initEpisode_setsStartTime() {
        // given
        whenCellViewModelFromEpisode(startTime: 1654644900)

        // then
        XCTAssertEqual(sut.startTime, "07.06.2022 23:35")
    }


    func test_initEpisode_setsEndTime() {
        // given
        whenCellViewModelFromEpisode(startTime: 1654646100)

        // then
        XCTAssertEqual(sut.endTime, "07.06.2022 23:55")
    }
    
}

