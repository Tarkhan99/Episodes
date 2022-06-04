//
//  EpisodeCellViewModel.swift
//  Episodes
//
//  Created by Tarkhan Tahirov on 02.06.22.
//

import Foundation
import UIKit

protocol EpisodeCellViewModeling {
    
    var imageURL: String { get }
    var title: String { get }
    var startTime: String { get }
    var endTime: String { get }

}

class EpisodeCellViewModel: EpisodeCellViewModeling {
    
    var episode: Episode
    
    var imageURL: String
    var title: String
    var startTime: String
    var endTime: String
    
    init(_ episode: Episode) {
        self.episode = episode
        self.imageURL = episode.imageUrl
        self.title = episode.title
        self.startTime = EpisodeCellViewModel.convertDate(dateValue: episode.startTime)
        self.endTime = EpisodeCellViewModel.convertDate(dateValue: episode.endTime)
    }
    
    private static func convertDate(dateValue: Int64) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(dateValue))
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "dd.MM.YYYY HH:mm"
        return formatter.string(from: date)
    }
    
}
