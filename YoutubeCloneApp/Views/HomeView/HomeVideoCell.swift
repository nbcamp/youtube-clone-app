//
//  HomeVideoCell.swift
//  YoutubeCloneApp
//
//  Created by 김지훈 on 2023/09/06.
//

import UIKit

class HomeVideoCell: UICollectionViewCell {
    static let identifier = "HomeVideoCell"
    
    //cell 스타일 지정?
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        cellPrint()
    }
    required init?(coder: NSCoder) {
        fatalError("Not implemented required init?(coder: NSCoder)")
    }
    
    //
    let thumbnailImage: UIImageView = {
        let thumbnailImage = UIImageView()
        thumbnailImage.contentMode = .scaleToFill
//        thumbnailImage.contentMode = .scaleAspectFit
//        thumbnailImage.contentMode = .scaleAspectFill
        thumbnailImage.backgroundColor = .white
        thumbnailImage.translatesAutoresizingMaskIntoConstraints = false
        return thumbnailImage
    }()
    
    //
    let channelIconImage: UIImageView = {
        let channelIconImage = UIImageView()
        channelIconImage.contentMode = .scaleToFill
//        channelIconImage.contentMode = .scaleAspectFit
//        channelIconImage.contentMode = .scaleAspectFill
        channelIconImage.backgroundColor = .white
        channelIconImage.translatesAutoresizingMaskIntoConstraints = false
        return channelIconImage
    }()
    
    //
    lazy var textBoxStackView = {
        let TextBoxStackView = UIStackView(arrangedSubviews: [titleLabel, labelStackView])
        TextBoxStackView.axis = .vertical
        TextBoxStackView.alignment = .leading
        TextBoxStackView.spacing = 1.0
        TextBoxStackView.translatesAutoresizingMaskIntoConstraints = false
        return TextBoxStackView
    }()
    
    //
    lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 16, weight: .regular)
        title.numberOfLines = 2
        title.textColor = .black
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    //
    lazy var labelStackView = {
        let labelStackView = UIStackView(arrangedSubviews: [channelNameLabel, viewCountLabel, uploadDateLabel])
        labelStackView.axis = .horizontal
        labelStackView.alignment = .center
        labelStackView.spacing = 10.0
        labelStackView.translatesAutoresizingMaskIntoConstraints = false
        return labelStackView
    }()
    
    //
    lazy var channelNameLabel: UILabel = {
        let channelNameLabel = UILabel()
        channelNameLabel.font = .systemFont(ofSize: 13, weight: .regular)
        channelNameLabel.textColor = .darkGray
        channelNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return channelNameLabel
    }()
    
    //
    lazy var viewCountLabel: UILabel = {
        let viewCountLabel = UILabel()
        viewCountLabel.font = .systemFont(ofSize: 13, weight: .regular)
        viewCountLabel.textColor = .darkGray
        viewCountLabel.translatesAutoresizingMaskIntoConstraints = false
        return viewCountLabel
    }()
    
    //
    lazy var uploadDateLabel: UILabel = {
        let uploadDateLabel = UILabel()
        uploadDateLabel.font = .systemFont(ofSize: 13, weight: .regular)
        uploadDateLabel.textColor = .darkGray
        uploadDateLabel.translatesAutoresizingMaskIntoConstraints = false
        return uploadDateLabel
    }()
    
    
    //
    func cellPrint() {
        contentView.addSubview(thumbnailImage)
        contentView.addSubview(channelIconImage)
        contentView.addSubview(textBoxStackView)
        
        thumbnailImage.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        thumbnailImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        thumbnailImage.widthAnchor.constraint(equalToConstant: contentView.bounds.width).isActive = true
        thumbnailImage.heightAnchor.constraint(equalToConstant: 208).isActive = true
        
        channelIconImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        channelIconImage.heightAnchor.constraint(equalToConstant: 40).isActive = true
        channelIconImage.topAnchor.constraint(equalTo: thumbnailImage.bottomAnchor, constant: 5).isActive = true
        channelIconImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
        
        textBoxStackView.topAnchor.constraint(equalTo: channelIconImage.topAnchor).isActive = true
        textBoxStackView.leadingAnchor.constraint(equalTo: channelIconImage.trailingAnchor, constant: 10).isActive = true
        textBoxStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
    }
}

