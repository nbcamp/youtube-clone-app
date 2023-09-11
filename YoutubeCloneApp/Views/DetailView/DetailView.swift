import UIKit
import WebKit

final class DetailView: UIView, RootView {
    weak var video: YoutubeVideo?

    var comments: [Comment] = [] {
        didSet { commentTableView.backgroundView?.isHidden = !comments.isEmpty }
    }

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

    private lazy var commentContainer = {
        let commentContainer = UIStackView(arrangedSubviews: [
            commentTextFieldGroup,
            commentTableView,
        ])

        commentContainer.backgroundColor = .secondary
        commentContainer.layer.cornerRadius = 10.0
        commentContainer.axis = .vertical
        commentContainer.spacing = 10

        commentContainer.isLayoutMarginsRelativeArrangement = true
        commentContainer.layoutMargins = .init(top: 10, left: 10, bottom: 10, right: 10)

        commentTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
        ])

        return commentContainer
    }()

    private lazy var commentTextFieldGroup: UIStackView = {
        userProfileImageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        commentTextField.setContentHuggingPriority(.defaultLow, for: .horizontal)
        submitCommentButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)

        let commentTextFieldGroup = UIStackView(arrangedSubviews: [
            userProfileImageView,
            commentTextField,
            submitCommentButton,
        ])

        commentTextFieldGroup.axis = .horizontal
        commentTextFieldGroup.distribution = .fill
        commentTextFieldGroup.spacing = 10

        return commentTextFieldGroup
    }()

    private lazy var userProfileImageView = {
        let userProfileImage = UIImageView()
        userProfileImage.image = UIImage(systemName: "person.crop.circle")
        userProfileImage.tintColor = .lightGray
        userProfileImage.translatesAutoresizingMaskIntoConstraints = false
        userProfileImage.widthAnchor.constraint(equalToConstant: 30).isActive = true
        userProfileImage.heightAnchor.constraint(equalToConstant: 30).isActive = true
        userProfileImage.layer.cornerRadius = 15
        userProfileImage.layer.masksToBounds = true
        return userProfileImage
    }()

    private lazy var commentTextField = {
        let commentTextField = UITextField()
        commentTextField.borderStyle = .roundedRect
        commentTextField.delegate = self
        commentTextField.layer.cornerRadius = 2
        commentTextField.layer.borderWidth = 2
        commentTextField.layer.borderColor = UIColor.systemGray.cgColor.copy(alpha: 0.8)
        commentTextField.font = .systemFont(ofSize: 14)
        commentTextField.backgroundColor = .secondary
        commentTextField.textColor = .white
        commentTextField.attributedPlaceholder = .init(
            string: "Add a comment...",
            attributes: [
                .foregroundColor: UIColor.lightGray,
                .font: UIFont.systemFont(ofSize: 14),
            ]
        )
        return commentTextField
    }()

    private lazy var submitCommentButton = {
        let submitCommentButton = UIButton()
        submitCommentButton.translatesAutoresizingMaskIntoConstraints = false
        submitCommentButton.setBackgroundImage(UIImage(systemName: "arrow.up.square.fill"), for: .normal)
        submitCommentButton.tintColor = .white
        submitCommentButton.isEnabled = false
        submitCommentButton.translatesAutoresizingMaskIntoConstraints = false
        submitCommentButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        submitCommentButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        submitCommentButton.addTarget(self, action: #selector(submitComment), for: .touchUpInside)
        return submitCommentButton
    }()

    private lazy var commentTableView: UITableView = {
        let commentTableView = UITableView()
        commentTableView.backgroundColor = .clear
        commentTableView.layer.borderColor = UIColor.lightGray.cgColor
        commentTableView.layer.borderWidth = 1.0
        commentTableView.layer.cornerRadius = 10.0
        commentTableView.dataSource = self
        commentTableView.delegate = self
        commentTableView.rowHeight = UITableView.automaticDimension
        commentTableView.estimatedRowHeight = 100
        commentTableView.backgroundView = createTablePlaceholderView()
        commentTableView.backgroundView?.isHidden = true
        commentTableView.register(CommentTableViewCell.self, forCellReuseIdentifier: CommentTableViewCell.identifier)
        return commentTableView
    }()

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        endEditing(true)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
        endEditing(true)
    }

    func initializeUI() {
        backgroundColor = .systemBackground
        addSubview(containerView)
        addSubview(commentContainer)

        containerView.translatesAutoresizingMaskIntoConstraints = false
        commentContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor),

            commentContainer.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 10),
            commentContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
            commentContainer.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            commentContainer.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])

        enableSwipeClosing()
        enableMoreDescription()
    }

    func configure(
        user: User?,
        video: YoutubeVideo?
    ) {
        self.video = video
        titleLabel.text = video?.title
        channelNameLabel.text = video?.channel.name
        descriptionLabel.text = video?.description
        userProfileImageView.image = user?.uiAvatar
        if let thumbnailUrl = video?.channel.thumbnail.url,
           let url = URL(string: thumbnailUrl)
        { channelImageView.load(url: url) }

        if let url = URL(string: video?.url ?? "") {
            webView.load(.init(url: url))
        }
    }

    private func enableSwipeClosing() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        addGestureRecognizer(panGestureRecognizer)
    }

    private func enableMoreDescription() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(descriptionTapped(_:)))
        descriptionScrollView.isUserInteractionEnabled = true
        descriptionScrollView.addGestureRecognizer(tapGesture)
    }

    private func createTablePlaceholderView() -> UIView {
        let placeholderView = UILabel()

        placeholderView.text = "Leave your first comment here!"
        placeholderView.font = .systemFont(ofSize: 14, weight: .medium)
        placeholderView.textColor = .lightGray
        placeholderView.textAlignment = .center

        return placeholderView
    }

    @objc private func descriptionTapped(_ sender: UITapGestureRecognizer) {
        descriptionLabel.numberOfLines = 0
    }

    @objc private func submitComment() {
        guard let comment = commentTextField.text, !comment.isEmpty else { endEditing(true); return }
        EventBus.shared.emit(AddCommentEvent(
            payload: .init(content: comment) { [weak self] _ in
                guard let self else { return }
                DispatchQueue.main.async {
                    self.commentTableView.performBatchUpdates {
                        let indexPath = IndexPath(row: 0, section: 0)
                        self.commentTableView.insertRows(at: [indexPath], with: .automatic)
                    }
                    self.commentTextField.text = ""
                    self.submitCommentButton.isEnabled = false
                    self.endEditing(true)
                }
            }
        ))
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

extension DetailView: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        submitCommentButton.isEnabled = false
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        let newText = (currentText as NSString).replacingCharacters(in: range, with: string)
        let trimmedText = newText.trimmingCharacters(in: .whitespacesAndNewlines)
        submitCommentButton.isEnabled = !trimmedText.isEmpty
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension DetailView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CommentTableViewCell.identifier, for: indexPath) as! CommentTableViewCell
        cell.comment = comments.reversed()[indexPath.row]
        return cell
    }
}

extension DetailView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CommentTableViewCell

        tableView.performBatchUpdates {
            cell.changeLine()
        }
    }
}
