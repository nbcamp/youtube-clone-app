import UIKit

final class CommentTableViewCell: UITableViewCell, Identifier {
    weak var comment: Comment? {
        didSet {
            profileImageView.image = comment?.uiAvatar ?? .init(systemName: "person.crop.circle")
            profileUsernameLabel.text = comment?.name
            commentLabel.text = comment?.content
        }
    }

    private lazy var containerView = {
        let containerView = UIStackView(arrangedSubviews: [
            profileImageView,
            contentStackView,
        ])
        containerView.axis = .horizontal
        containerView.spacing = 10.0
        containerView.alignment = .top
        containerView.isLayoutMarginsRelativeArrangement = true
        containerView.layoutMargins = .init(top: 10, left: 10, bottom: 10, right: 10)
        return containerView
    }()

    private lazy var contentStackView = {
        let contentStackView = UIStackView(arrangedSubviews: [
            profileUsernameLabel,
            commentLabel,
        ])
        contentStackView.axis = .vertical
        contentStackView.spacing = 4.0
        return contentStackView
    }()

    private lazy var profileImageView = {
        let profileImageView = UIImageView()
        profileImageView.image = .init(systemName: "person.crop.circle")
        profileImageView.tintColor = .lightGray
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        profileImageView.layer.cornerRadius = 15
        profileImageView.layer.masksToBounds = true
        return profileImageView
    }()

    private lazy var profileUsernameLabel = {
        let profileUsernameLabel = UILabel()
        profileUsernameLabel.translatesAutoresizingMaskIntoConstraints = false
        profileUsernameLabel.font = .systemFont(ofSize: 12)
        profileUsernameLabel.textColor = .lightGray
        profileUsernameLabel.text = "Anonymous"
        return profileUsernameLabel
    }()

    private lazy var commentLabel: UILabel = {
        let commentLabel = UILabel()
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.font = .systemFont(ofSize: 14)
        commentLabel.text = "Comment"
        commentLabel.textColor = .white
        commentLabel.numberOfLines = 4
        return commentLabel
    }()

    func changeLine() {
        commentLabel.numberOfLines = commentLabel.numberOfLines > 0 ? 0 : 2
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureUI() {
        backgroundColor = .clear

        selectionStyle = .none
        addSubview(containerView)

        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: topAnchor),
            containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])
    }
}
