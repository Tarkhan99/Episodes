//
//  Episode.swift
//  Episodes
//
//  Created by Tarkhan Tahirov on 02.06.22.
//

import Foundation

struct Episode: Decodable, Equatable {
    var id: String
    var imageUrl: String
    var startTime: Int64
    var endTime: Int64
    var episodeTitle: String
    var title: String
    
    static func == (lhs: Episode, rhs: Episode) -> Bool {
        return lhs.id == rhs.id && lhs.title == rhs.title
    }
    
}
