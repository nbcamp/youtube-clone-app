import UIKit

final class ProfileView: UIView, RootView {
    private lazy var containerView = {
        let containerView = UIStackView(arrangedSubviews: [
            avatarView,
            nameLabel,
            dividerView,
            emailLabel,
        ])
        containerView.axis = .vertical
        containerView.alignment = .center
        containerView.spacing = 15.0
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        dividerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.4),
            avatarView.heightAnchor.constraint(equalTo: avatarView.widthAnchor, multiplier: 0.95),

            dividerView.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.3),
            dividerView.heightAnchor.constraint(equalToConstant: 1),
        ])
        return containerView
    }()

    private lazy var avatarView = {
        let avatarView = UIImageView()
        avatarView.image = .init(systemName: "person.circle")
        return avatarView
    }()

    private lazy var nameLabel = {
        let nameLabel = UILabel()
        return nameLabel
    }()

    private lazy var dividerView = {
        let dividerView = UIView()
        dividerView.backgroundColor = .systemGray
        return dividerView
    }()

    private lazy var emailLabel = {
        let emailLabel = UILabel()

        return emailLabel
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { fatalError() }

    func initializeUI() {
        backgroundColor = .systemBackground
        addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        let guide = safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 40),
            containerView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
        ])
    }

    func configure(user: User) {
        if let avatar = user.uiAvatar {
            avatarView.image = avatar
        }
        nameLabel.text = user.name
        emailLabel.text = user.email
    }
}
