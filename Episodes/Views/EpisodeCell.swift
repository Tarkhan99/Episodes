//
//  EpisodeCell.swift
//  Episodes
//
//  Created by Tarkhan Tahirov on 02.06.22.
//

import UIKit
import Kingfisher

class EpisodeCell: UITableViewCell {
    
    static let id = "EpisodeCellId"
    
    var episodeTitleLabel: UILabel!
    var episodeImageView: UIImageView!
    var startTimeLabel: UILabel!
    var endTimeLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        setupViews()
    }
    
    func configure(_ viewModel: EpisodeCellViewModeling) {
        episodeTitleLabel.text = viewModel.title
        startTimeLabel.text = viewModel.startTime
        endTimeLabel.text = viewModel.endTime
        let imageURL = URL(string: viewModel.imageURL)
        episodeImageView.kf.setImage(with: imageURL)
    }
    
    private func setupViews() {
        
        episodeTitleLabel = UILabel()
        episodeTitleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        episodeTitleLabel.textAlignment = .center
        episodeTitleLabel.text = "Movie name"
        
        episodeImageView = UIImageView()
        episodeImageView.backgroundColor = .lightGray
        episodeImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
        startTimeLabel = UILabel()
        startTimeLabel.font = .systemFont(ofSize: 14)
        startTimeLabel.textAlignment = .center
        startTimeLabel.text = "Start time"
        
        endTimeLabel = UILabel()
        endTimeLabel.font = .systemFont(ofSize: 14)
        endTimeLabel.textAlignment = .center
        endTimeLabel.text = "End time"
        
        let bottomStackView = UIStackView(arrangedSubviews: [startTimeLabel, endTimeLabel])
        bottomStackView.axis = .horizontal
        bottomStackView.distribution = .fillEqually
        bottomStackView.alignment = .fill
        bottomStackView.spacing = 10
                
        let stackView = UIStackView(arrangedSubviews: [episodeTitleLabel, episodeImageView, bottomStackView])
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        stackView.spacing = 20
        stackView.layer.cornerRadius = 10
        stackView.backgroundColor = .systemBackground
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.layoutMargins = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        contentView.addSubview(stackView)
        
        stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        stackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40).isActive = true
        stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        return nil
    }
    
}

