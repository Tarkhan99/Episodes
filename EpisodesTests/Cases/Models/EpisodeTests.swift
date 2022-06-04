//
//  EpisodeTests.swift
//  EpisodesTests
//
//  Created by Tarkhan Tahirov on 02.06.22.
//

import XCTest
@testable import Episodes

class EpisodeTests: XCTestCase {
    
    var sut: Episode!
    var dictionary: NSDictionary!
    
    override func setUpWithError() throws {
        let data = try Data.fromJSON(fileName: "episode")
        sut = try JSONDecoder().decode(Episode.self, from: data)
        dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSDictionary
    }
    
    override func tearDown() {
        sut = nil
        dictionary = nil
        super.tearDown()
    }
    
    func test_conformsTo_decodable() {
        XCTAssertTrue((sut as Any) is Decodable)
    }
    
    func test_conformsTo_equatable() {
        XCTAssertEqual(sut, sut)
    }
    
    func test_initFromDecoder_setsId() {
        let expectedId = dictionary["id"] as? String
        
        XCTAssertEqual(sut.id, expectedId)
    }
    
    func test_initFromDecoder_setsImageURL() {
        let expectedURL = dictionary["imageUrl"] as? String
        
        XCTAssertEqual(sut.imageUrl, expectedURL)
    }
    
    func test_initFromDecoder_setsStartTime() {
        let expected = dictionary["startTime"] as? Int64
        
        XCTAssertEqual(sut.startTime, expected)
    }
    
    func test_initFromDecoder_setsEndTime() {
        let expected = dictionary["endTime"] as? Int64
        
        XCTAssertEqual(sut.endTime, expected)
    }
    
    func test_initFromDecoder_setsTitle() {
        let expected = dictionary["title"] as? String
        
        XCTAssertEqual(sut.title, expected)
    }
    
    func test_initFromDecoder_setsEpisodeTitle() {
        let expected = dictionary["episodeTitle"] as? String
        
        XCTAssertEqual(sut.episodeTitle, expected)
    }
    
}
