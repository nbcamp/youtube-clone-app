import UIKit

final class HomeVideoCell: UICollectionViewCell, Identifier {
    private lazy var thumbnailImage: UIImageView = {
        let thumbnailImage = UIImageView()
        
        thumbnailImage.backgroundColor = .clear
        thumbnailImage.contentMode = .scaleAspectFill
        thumbnailImage.clipsToBounds = true
        return thumbnailImage
    }()
    
    private lazy var channelIconImage: UIImageView = {
        let channelIconImage = UIImageView()
        channelIconImage.contentMode = .scaleAspectFill
        channelIconImage.clipsToBounds = true
        channelIconImage.layer.cornerRadius = 20
        channelIconImage.backgroundColor = .white
        
        return channelIconImage
    }()
    
    private lazy var textBoxStackView = {
        let TextBoxStackView = UIStackView(arrangedSubviews: [
            titleLabel,
            labelStackView,
        ])
        TextBoxStackView.axis = .vertical
        TextBoxStackView.alignment = .leading
        TextBoxStackView.spacing = 1.0
        return TextBoxStackView
    }()
    
    private lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.font = .systemFont(ofSize: 14, weight: .regular)
        title.numberOfLines = 2
        title.textColor = .secondary
        return title
    }()
    
    private lazy var labelStackView = {
        let labelStackView = UIStackView(arrangedSubviews: [
            channelNameLabel,
            viewCountLabel,
            uploadDateLabel
        ])
        labelStackView.axis = .horizontal
        labelStackView.alignment = .center
        labelStackView.spacing = 0
        return labelStackView
    }()
    
    private lazy var channelNameLabel: UILabel = {
        let channelNameLabel = UILabel()
        channelNameLabel.font = .systemFont(ofSize: 12, weight: .regular)
        channelNameLabel.textColor = .systemGray
        channelNameLabel.translatesAutoresizingMaskIntoConstraints = false
        return channelNameLabel
    }()
    
    private lazy var viewCountLabel: UILabel = {
        let viewCountLabel = UILabel()
        viewCountLabel.font = .systemFont(ofSize: 12, weight: .regular)
        viewCountLabel.textColor = .systemGray
        viewCountLabel.translatesAutoresizingMaskIntoConstraints = false
        return viewCountLabel
    }()
    
    private lazy var uploadDateLabel: UILabel = {
        let uploadDateLabel = UILabel()
        uploadDateLabel.font = .systemFont(ofSize: 12, weight: .regular)
        uploadDateLabel.textColor = .systemGray
        uploadDateLabel.translatesAutoresizingMaskIntoConstraints = false
        return uploadDateLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCell()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("Not implemented required init?(coder: NSCoder)")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = bounds
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImage.image = nil
    }

    private func setupCell() {
        contentView.addSubview(thumbnailImage)
        contentView.addSubview(channelIconImage)
        contentView.addSubview(textBoxStackView)
        
        thumbnailImage.translatesAutoresizingMaskIntoConstraints = false
        channelIconImage.translatesAutoresizingMaskIntoConstraints = false
        textBoxStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            thumbnailImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            thumbnailImage.leadingAnchor.constraint(equalTo: leadingAnchor),
            thumbnailImage.trailingAnchor.constraint(equalTo: trailingAnchor),
            thumbnailImage.heightAnchor.constraint(equalTo: thumbnailImage.widthAnchor, multiplier: 9 / 16),

            channelIconImage.widthAnchor.constraint(equalToConstant: 40),
            channelIconImage.heightAnchor.constraint(equalToConstant: 40),
            channelIconImage.topAnchor.constraint(equalTo: thumbnailImage.bottomAnchor, constant: 16),
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
                    debugPrint("error")
                }
            }
        }
        
        if let channelIconUrl = URL(string: video.channel.thumbnail.url) {
            channelIconImage.load(url: channelIconUrl) { [weak self] loadedImage in
                if let image = loadedImage {
                    self?.channelIconImage.image = image
                } else {
                    debugPrint("error")
                }
            }
        }
        
        titleLabel.text = video.title
        channelNameLabel.text = "\(video.channel.name)﹒"
        
        let viewCountFormatter = NumberFormatter()
        let randomViewCount = Int.random(in: 1 ... 999999999)
        let viewCountFormatted = viewCountFormatter.viewCount(views: randomViewCount)
        viewCountLabel.text = viewCountFormatted
        
        let uploadDate = DateFormatter()
        let uploadDateToago = uploadDate.uploadDate(uploadDateString: video.publishedAt)
        uploadDateLabel.text = uploadDateToago
    }
}
