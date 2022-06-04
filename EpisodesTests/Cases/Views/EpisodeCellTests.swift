//
//  EpisodeCellTests.swift
//  EpisodesTests
//
//  Created by Tarkhan Tahirov on 02.06.22.
//

import XCTest
@testable import Episodes

class EpisodeCellTests: XCTestCase {
    
    var sut: EpisodeCell!
    var mockCellViewModel: MockEpisodeCellViewModel!
    
    override func setUp() {
        super.setUp()
        sut = EpisodeCell()
    }
    
    override func tearDown() {
        mockCellViewModel = nil
        sut = nil
        super.tearDown()
    }
    
    func whenConfigureCell() {
        mockCellViewModel = MockEpisodeCellViewModel()
        sut.configure(mockCellViewModel)
    }
    
    func test_required_init() {
        sut = EpisodeCell(coder: NSCoder())
        XCTAssertNil(sut)
    }
    
    func test_configure_setsTitleLabel() {
        // when
        whenConfigureCell()
        
        // then
        XCTAssertEqual(sut.episodeTitleLabel.text, mockCellViewModel.title)
    }
    
    func test_configure_setsStartTimeLabel() {
        // when
        whenConfigureCell()
        
        // then
        XCTAssertEqual(sut.startTimeLabel.text, mockCellViewModel.startTime)
    }
    
    func test_configure_setsEndTimeLabel() {
        // when
        whenConfigureCell()
        
        // then
        XCTAssertEqual(sut.endTimeLabel.text, mockCellViewModel.endTime)
    }
    
    func test_configure_callsSetImage() {
        //
    }
    
}


class MockEpisodeCellViewModel: EpisodeCellViewModeling {
    
    var imageURL: String = "imageURL"
    var title: String = "title"
    var startTime: String = "20.02.2022"
    var endTime: String = "20.03.2022"
    
}
