//
//  HomeVideoCell.swift
//  YoutubeCloneApp
//
//  Created by 김지훈 on 2023/09/06.
//

import UIKit

class HomeVideoCell: UICollectionViewCell, Identifier {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCell()
    }
    required init?(coder: NSCoder) {
        fatalError("Not implemented required init?(coder: NSCoder)")
    }
    
    lazy var thumbnailImage: UIImageView = {
        let thumbnailImage = UIImageView()
        thumbnailImage.contentMode = .scaleToFill
        thumbnailImage.backgroundColor = .white
        thumbnailImage.translatesAutoresizingMaskIntoConstraints = false
        return thumbnailImage
    }()
    
    lazy var channelIconImage: UIImageView = {
        let channelIconImage = UIImageView()
        channelIconImage.contentMode = .scaleToFill
        channelIconImage.backgroundColor = .white
        channelIconImage.translatesAutoresizingMaskIntoConstraints = false
        return channelIconImage
    }()
    
    lazy var textBoxStackView = {
        let TextBoxStackView = UIStackView(arrangedSubviews: [titleLabel, labelStackView])
        TextBoxStackView.axis = .vertical
        TextBoxStackView.alignment = .leading
        TextBoxStackView.spacing = 1.0
        TextBoxStackView.translatesAutoresizingMaskIntoConstraints = false
        return TextBoxStackView
    }()
    
    lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 16, weight: .regular)
        title.numberOfLines = 2
        title.textColor = .black
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    lazy var labelStackView = {
        let labelStackView = UIStackView(arrangedSubviews: [channelNameLabel, viewCountLabel, uploadDateLabel])
        labelStackView.axis = .horizontal
        labelStackView.alignment = .center
        labelStackView.spacing = 0
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        return labelStackView
    }()
    
    lazy var channelNameLabel: UILabel = {
        let channelNameLabel = UILabel()
        channelNameLabel.font = .systemFont(ofSize: 13, weight: .regular)
        channelNameLabel.textColor = .darkGray
        channelNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return channelNameLabel
    }()
    
    lazy var viewCountLabel: UILabel = {
        let viewCountLabel = UILabel()
        viewCountLabel.font = .systemFont(ofSize: 13, weight: .regular)
        viewCountLabel.textColor = .darkGray
        viewCountLabel.translatesAutoresizingMaskIntoConstraints = false
        return viewCountLabel
    }()
    
    lazy var uploadDateLabel: UILabel = {
        let uploadDateLabel = UILabel()
        uploadDateLabel.font = .systemFont(ofSize: 13, weight: .regular)
        uploadDateLabel.textColor = .darkGray
        uploadDateLabel.translatesAutoresizingMaskIntoConstraints = false
        return uploadDateLabel
    }()
    
    func setupCell() {
        contentView.addSubview(thumbnailImage)
        contentView.addSubview(channelIconImage)
        contentView.addSubview(textBoxStackView)
        
        NSLayoutConstraint.activate([
            thumbnailImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            thumbnailImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            thumbnailImage.widthAnchor.constraint(equalToConstant: contentView.bounds.width),
            thumbnailImage.heightAnchor.constraint(equalToConstant: 208),
            
            channelIconImage.widthAnchor.constraint(equalToConstant: 40),
            channelIconImage.heightAnchor.constraint(equalToConstant: 40),
            channelIconImage.topAnchor.constraint(equalTo: thumbnailImage.bottomAnchor, constant: 5),
            channelIconImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            
            textBoxStackView.topAnchor.constraint(equalTo: channelIconImage.topAnchor),
            textBoxStackView.leadingAnchor.constraint(equalTo: channelIconImage.trailingAnchor, constant: 10),
            textBoxStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
        ])
    }
    
    func configure(video: YoutubeVideo) {
        
        if let thumbnailImageUrl = URL(string: video.thumbnail.url) {
            thumbnailImage.load(url: thumbnailImageUrl) { [weak self] loadedImage in
                if let image = loadedImage {
                    self?.thumbnailImage.image = image
                } else {
                    print("error")
                }
            }
        }
        
        if let channelIconUrl = URL(string: video.channel.thumbnail.url) {
            channelIconImage.load(url: channelIconUrl) { [weak self] loadedImage in
                if let image = loadedImage {
                    self?.channelIconImage.image = image
                } else {
                    print("error")
                }
            }
        }
        
        titleLabel.text = video.title
        channelNameLabel.text = "\(video.channel.name)﹒"
        
        let formatter = NumberFormatter()
        let randomViewCount = Int.random(in: 1...999999999)
        let formatted = formatter.viewCount(views: randomViewCount)
        viewCountLabel.text = formatted
//        uploadDateLabel.text = video.uploadDate
    }
}
