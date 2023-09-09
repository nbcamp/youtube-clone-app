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
    
    private lazy var thumbnailImage: UIImageView = {
        let thumbnailImage = UIImageView()
        thumbnailImage.contentMode = .scaleToFill
        thumbnailImage.backgroundColor = .systemBackground
        thumbnailImage.translatesAutoresizingMaskIntoConstraints = false
        return thumbnailImage
    }()
    
    private lazy var channelIconImage: UIImageView = {
        let channelIconImage = UIImageView()
        channelIconImage.contentMode = .scaleAspectFill
        channelIconImage.clipsToBounds = true
        channelIconImage.layer.cornerRadius = 20
        channelIconImage.backgroundColor = .white
        channelIconImage.translatesAutoresizingMaskIntoConstraints = false
        return channelIconImage
    }()
    
    private lazy var textBoxStackView = {
        let TextBoxStackView = UIStackView(arrangedSubviews: [titleLabel, labelStackView])
        TextBoxStackView.axis = .vertical
        TextBoxStackView.alignment = .leading
        TextBoxStackView.spacing = 1.0
        TextBoxStackView.translatesAutoresizingMaskIntoConstraints = false
        return TextBoxStackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 16, weight: .regular)
        title.numberOfLines = 2
        title.textColor = .black
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    private lazy var labelStackView = {
        let labelStackView = UIStackView(arrangedSubviews: [channelNameLabel, viewCountLabel, uploadDateLabel])
        labelStackView.axis = .horizontal
        labelStackView.alignment = .center
        labelStackView.spacing = 0
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        return labelStackView
    }()
    
    private lazy var channelNameLabel: UILabel = {
        let channelNameLabel = UILabel()
        channelNameLabel.font = .systemFont(ofSize: 13, weight: .regular)
        channelNameLabel.textColor = .darkGray
        channelNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return channelNameLabel
    }()
    
    private lazy var viewCountLabel: UILabel = {
        let viewCountLabel = UILabel()
        viewCountLabel.font = .systemFont(ofSize: 13, weight: .regular)
        viewCountLabel.textColor = .darkGray
        viewCountLabel.translatesAutoresizingMaskIntoConstraints = false
        return viewCountLabel
    }()
    
    private lazy var uploadDateLabel: UILabel = {
        let uploadDateLabel = UILabel()
        uploadDateLabel.font = .systemFont(ofSize: 13, weight: .regular)
        uploadDateLabel.textColor = .darkGray
        uploadDateLabel.translatesAutoresizingMaskIntoConstraints = false
        return uploadDateLabel
    }()
    
    private func setupCell() {
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
        
        let viewCountFormatter = NumberFormatter()
        let randomViewCount = Int.random(in: 1...999999999)
        let viewCountFormatted = viewCountFormatter.viewCount(views: randomViewCount)
        viewCountLabel.text = viewCountFormatted
        
        let uploadDate = DateFormatter()
        let uploadDateToago = uploadDate.uploadDate(uploadDateString: video.publishedAt)
        uploadDateLabel.text = uploadDateToago
    }
}
