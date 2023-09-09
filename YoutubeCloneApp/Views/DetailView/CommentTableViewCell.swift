import UIKit

class CommentTableViewCell: UITableViewCell {
    private lazy var overviewStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var profileImage: UIImageView = {
        let profileImage = UIImageView()
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.image = UIImage(systemName: "person.crop.circle")
        profileImage.sizeToFit()
        return profileImage
    }()

    private lazy var profileLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 12)
        label.textColor = .darkGray
        label.text = "@user-dsfnasdlf"
        return label
    }()

    private lazy var overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Apple SD Gothic Neo", size: 14)
        label.numberOfLines = 4
        label.text = ""
        return label
    }()

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func changeLine() {
        overviewLabel.numberOfLines = 0
    }

    private func setConstraint() {
        contentView.addSubview(overviewStackView)
        contentView.addSubview(profileImage)
        overviewStackView.addArrangedSubview(profileLabel)
        overviewStackView.addArrangedSubview(overviewLabel)
        overviewStackView.axis = .vertical
        overviewStackView.alignment = .top
        overviewStackView.spacing = 5
        NSLayoutConstraint.activate([
            profileImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            profileImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            profileImage.widthAnchor.constraint(equalToConstant: 35),
            profileImage.heightAnchor.constraint(equalToConstant: 35),
            overviewStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            overviewStackView.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 10),
            overviewStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            overviewStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -15)

        ])
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setConstraint()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(_ data: String) {
        
    }
}
