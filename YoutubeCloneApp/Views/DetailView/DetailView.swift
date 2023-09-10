import UIKit
import WebKit

final class DetailView: UIView, RootView {
    weak var video: YoutubeVideo?

    var comments: [Comment] = []
    var comment: Comment?

    private lazy var containerView = {
        let containerView = UIStackView(arrangedSubviews: [
            webView,
            contentContainer,
        ])

        containerView.axis = .vertical
        containerView.spacing = 10
        containerView.alignment = .center

        webView.translatesAutoresizingMaskIntoConstraints = false
        contentContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            webView.heightAnchor.constraint(equalToConstant: 250),
            contentContainer.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -20),
        ])

        return containerView
    }()

    private lazy var webView = {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true // fullscreen
        let webView = WKWebView(frame: .zero, configuration: config)
        return webView
    }()

    private lazy var contentContainer = {
        let contentContainer = UIStackView(arrangedSubviews: [
            titleStackView,
            channelInfoStackView,
            descriptionScrollView,
        ])
        contentContainer.axis = .vertical
        contentContainer.spacing = 10

        descriptionScrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionScrollView.leadingAnchor.constraint(equalTo: contentContainer.leadingAnchor),
            descriptionScrollView.trailingAnchor.constraint(equalTo: contentContainer.trailingAnchor),
            descriptionScrollView.heightAnchor.constraint(equalToConstant: 100),
        ])
        return contentContainer
    }()

    private lazy var titleStackView = {
        let titleStackView = UIStackView(arrangedSubviews: [
            titleLabel,
            viewTimeLabel,
        ])
        titleStackView.axis = .vertical
        titleStackView.spacing = 10
        return titleStackView
    }()

    private lazy var titleLabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 24, weight: .bold)
        titleLabel.lineBreakMode = .byCharWrapping
        titleLabel.numberOfLines = 2
        return titleLabel
    }()

    private lazy var viewTimeLabel = {
        let viewTimeLabel = UILabel()
        viewTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        viewTimeLabel.text = "조회수 5.8만회 7시간 전"
        viewTimeLabel.font = .systemFont(ofSize: 12)
        viewTimeLabel.textColor = .systemGray
        return viewTimeLabel
    }()

    private lazy var channelInfoStackView = {
        let channelInfoStackView = UIStackView(arrangedSubviews: [
            channelImageView,
            channelNameLabel,
            subscriptionButton,
        ])
        channelInfoStackView.axis = .horizontal
        channelInfoStackView.spacing = 10
        channelInfoStackView.alignment = .center
        
        channelInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        channelInfoStackView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return channelInfoStackView
    }()

    private lazy var channelImageView = {
        let channelImageView = UIImageView()
        channelImageView.image = .init(systemName: "person.crop.circle")
        channelImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            channelImageView.widthAnchor.constraint(equalToConstant: 50),
            channelImageView.heightAnchor.constraint(equalToConstant: 50),
        ])
        channelImageView.layer.cornerRadius = 25
        channelImageView.layer.masksToBounds = true
        return channelImageView
    }()

    private lazy var channelNameLabel = {
        let channelNameLabel = UILabel()
        channelNameLabel.font = .systemFont(ofSize: 14, weight: .medium)
        return channelNameLabel
    }()

    private lazy var subscriptionButton: UIButton = {
        let subscriptionButton = UIButton()
        subscriptionButton.setTitle("Subscribe", for: .normal)
        subscriptionButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        subscriptionButton.backgroundColor = .primary
        subscriptionButton.layer.cornerRadius = 10.0
        subscriptionButton.layer.masksToBounds = true
        subscriptionButton.setTitleColor(.white, for: .normal)
        subscriptionButton.contentEdgeInsets = .init(top: 0, left: 10, bottom: 0, right: 10)
        subscriptionButton.sizeToFit()
        subscriptionButton.translatesAutoresizingMaskIntoConstraints = false
        subscriptionButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return subscriptionButton
    }()

    private lazy var descriptionScrollView = {
        let descriptionScrollView = UIScrollView()
        descriptionScrollView.backgroundColor = .secondary
        descriptionScrollView.addSubview(descriptionLabel)
        descriptionScrollView.layer.cornerRadius = 10.0
        descriptionScrollView.layer.masksToBounds = true
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: descriptionScrollView.topAnchor, constant: 10),
            descriptionLabel.bottomAnchor.constraint(equalTo: descriptionScrollView.bottomAnchor, constant: -10),
            descriptionLabel.widthAnchor.constraint(equalTo: descriptionScrollView.widthAnchor, constant: -20),
            descriptionLabel.centerXAnchor.constraint(equalTo: descriptionScrollView.centerXAnchor),
        ])
        return descriptionScrollView
    }()

    private lazy var descriptionLabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.font = .systemFont(ofSize: 14)
        descriptionLabel.numberOfLines = 3
        descriptionLabel.textColor = .white
        return descriptionLabel
    }()

//    private lazy var commentTableView: UITableView = {
//        let commentTableview = UITableView()
//        commentTableView.dataSource = self
//        commentTableView.delegate = self
//        commentTableview.translatesAutoresizingMaskIntoConstraints = false
//        commentTableview.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
//        return commentTableview
//    }()
//
//    private lazy var writeButton = {
//        let button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setBackgroundImage(UIImage(systemName: "paperplane"), for: .normal)
//        button.addTarget(self, action: #selector(writeComment), for: .touchUpInside)
//        return button
//    }()
//
//    private lazy var userProfileImage: UIImageView = {
//        let profileImage = UIImageView()
//        profileImage.translatesAutoresizingMaskIntoConstraints = false
//        profileImage.image = UIImage(systemName: "person.crop.circle")
//        profileImage.sizeToFit()
//        return profileImage
//    }()
//
//    private lazy var commentTextField: UITextField = {
//        let commentTextField = UITextField()
//        commentTextField.translatesAutoresizingMaskIntoConstraints = false
//        commentTextField.placeholder = "Write comment here"
//        commentTextField.borderStyle = .roundedRect
//        commentTextField.delegate = self
//        commentTextField.layer.cornerRadius = 2
//        commentTextField.layer.borderWidth = 2
//        commentTextField.layer.borderColor = UIColor.gray.cgColor.copy(alpha: 0.8)
//        return commentTextField
//    }()
//
//    private lazy var commentStackView: UIStackView = {
//        let stackView = UIStackView(arrangedSubviews: [
//            userProfileImage,
//            commentTextField,
//            writeButton,
//        ])
//        stackView.translatesAutoresizingMaskIntoConstraints = false
//        stackView.axis = .horizontal
//        stackView.spacing = 10
//        stackView.backgroundColor = .systemBackground
//        return stackView
//    }()

    func initializeUI() {
        backgroundColor = .systemBackground
        addSubview(containerView)

        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),
        ])

//        addSubview(profileImageButton)
//        addSubview(profileLabel)
//        addSubview(likeButton)
//        addSubview(commentTableView)
//        addSubview(commentStackView)

        configureConstraints()
//        addTopBorderToTextField(with: UIColor.systemGray, andWidth: CGFloat(0.5))

        enableSwipeClosing()
        enableMoreDescription()
    }

    func configure(video: YoutubeVideo?) {
        self.video = video

        titleLabel.text = video?.title
        if let thumbnailUrl = video?.channel.thumbnail.url,
           let url = URL(string: thumbnailUrl)
        { channelImageView.load(url: url) }
        channelNameLabel.text = video?.channel.name
        descriptionLabel.text = video?.description

        if let url = URL(string: video?.url ?? "") {
            webView.load(.init(url: url))
        }
    }

    private func configureConstraints() {
        let guide = safeAreaLayoutGuide

//        let channelInfoStackViewConstraints = [
//            channelInfoStackView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 10),
//            channelInfoStackView.topAnchor.constraint(equalTo: titleStackView.bottomAnchor, constant: 10)
//        ]

//        let profileImageButtonConstraints = [
//            profileImageButton.topAnchor.constraint(equalTo: viewTimeLabel.bottomAnchor, constant: 20),
//            profileImageButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
//            profileImageButton.heightAnchor.constraint(equalToConstant: 40),
//            profileImageButton.widthAnchor.constraint(equalToConstant: 40)
//        ]
//
//        let profileLabelConstraints = [
//            profileLabel.centerYAnchor.constraint(equalTo: profileImageButton.centerYAnchor),
//            profileLabel.leadingAnchor.constraint(equalTo: profileImageButton.trailingAnchor, constant: 15)
//        ]
//

//        let likeButtonConstraints = [
//            likeButton.centerYAnchor.constraint(equalTo: profileLabel.centerYAnchor),
//            likeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
//        ]
//        let viewTimeLabelConstraints = [
//            viewTimeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
//            viewTimeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
//        ]
//        let commentTableViewConstraints = [
//            commentTableView.topAnchor.constraint(equalTo: overviewStackView.bottomAnchor),
//            commentTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            commentTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
//            commentTableView.bottomAnchor.constraint(equalTo: commentStackView.topAnchor)
//        ]
//        let commentStackViewConstraints = [
//            commentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
//            commentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
//            commentStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
//            commentStackView.heightAnchor.constraint(equalToConstant: 40)
//        ]
//        let userProfileImageConstraints = [
//            userProfileImage.widthAnchor.constraint(equalToConstant: 40)
//        ]
//        let writeButtonConstraints = [
//            writeButton.widthAnchor.constraint(equalToConstant: 30)
//        ]

//        NSLayoutConstraint.activate(webViewConstraints)
//        NSLayoutConstraint.activate(contentContainerConstraints)
//        NSLayoutConstraint.activate(profileImageButtonConstraints)
//        NSLayoutConstraint.activate(overviewStackViewConstraints)
//        NSLayoutConstraint.activate(profileLabelConstraints)
//        NSLayoutConstraint.activate(likeButtonConstraints)
//        NSLayoutConstraint.activate(viewTimeLabelConstraints)
//        NSLayoutConstraint.activate(commentTableViewConstraints)
//        NSLayoutConstraint.activate(commentStackViewConstraints)
//        NSLayoutConstraint.activate(userProfileImageConstraints)
//        NSLayoutConstraint.activate(writeButtonConstraints)
    }

    private func enableMoreDescription() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(descriptionTapped(_:)))
        descriptionScrollView.isUserInteractionEnabled = true
        descriptionScrollView.addGestureRecognizer(tapGesture)
    }

    @objc private func descriptionTapped(_ sender: UITapGestureRecognizer) {
        descriptionLabel.numberOfLines = 0
    }

//
//    func addTopBorderToTextField(with color: UIColor?, andWidth borderWidth: CGFloat) {
//        let border = UIView()
//        border.backgroundColor = color
//        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
//        border.frame = CGRect(x: 0, y: 0, width: commentStackView.frame.width, height: borderWidth)
//        commentStackView.addSubview(border)
//    }
//
//    @objc private func writeComment() {
//        if commentTextField.text != "" {
//            comment?.content = commentTextField.text ?? ""
//            EventBus.shared.emit(AddCommentEvent(payload: .init(content: comment?.content ?? "")))
//        }
//        commentTextField.text = ""
//        commentTableView.reloadData()
//    }

    private func enableSwipeClosing() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        addGestureRecognizer(panGestureRecognizer)
    }

    @objc private func handlePanGesture(_ panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: self)
        let minY = frame.height * 0.15
        var originalPosition = CGPoint.zero
        switch panGesture.state {
        case .began:
            originalPosition = center
        case .changed:
            frame.origin = CGPoint(x: 0.0, y: translation.y)

            if panGesture.location(in: self).y > minY {
                frame.origin = originalPosition
            }

            if frame.origin.y <= 0.0 {
                frame.origin.y = 0.0
            }
        case .ended:
            if frame.origin.y >= frame.height * 0.5 {
                UIView.animate(
                    withDuration: 0.2,
                    animations: {
                        self.frame.origin = CGPoint(
                            x: self.frame.origin.x,
                            y: self.frame.size.height
                        )
                    }, completion: { isCompleted in
                        if isCompleted {
                            EventBus.shared.emit(CloseDetailViewEvent())
                        }
                    }
                )
            } else {
                UIView.animate(withDuration: 0.2, animations: {
                    self.frame.origin = originalPosition
                })
            }
        default:
            break
        }
    }
}

// extension DetailView: UITextFieldDelegate {
//    func textFieldShouldClear(_ textField: UITextField) -> Bool {
//        writeButton.isEnabled = false
//        return true
//    }
//
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        let text = (commentTextField.text! as NSString).replacingCharacters(in: range, with: string)
//        if !text.isEmpty {
//            writeButton.isEnabled = true
//        } else {
//            writeButton.isEnabled = false
//        }
//        return true
//    }
// }
//
// extension DetailView: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return comments.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as! CommentTableViewCell
//        cell.comment = comments[indexPath.row]
//        return cell
//    }
// }
//
// extension DetailView: UITableViewDelegate {
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.cellForRow(at: indexPath) as! CommentTableViewCell
//
//        tableView.performBatchUpdates {
//            cell.changeLine()
//        }
//    }
// }
