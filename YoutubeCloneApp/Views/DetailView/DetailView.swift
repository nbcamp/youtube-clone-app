import UIKit
import WebKit

final class DetailView: UIView, RootView {
    var comments: [Comment] = []
    var comment : Comment?
    
    private let titleStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis = .vertical
        return stackview
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "Harry Potter"
        label.lineBreakMode = .byCharWrapping
        label.numberOfLines = 2
        return label
    }()
    
    private let viewtimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "조회수 5.8만회 7시간 전"
        label.font = .systemFont(ofSize: 11)
        label.textColor = .darkGray
        return label
    }()
    
    private let profileImageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "person.crop.circle"), for: .normal)
        return button
    }()
    
    private let profileLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "해리포터"
        label.font = .systemFont(ofSize: 14, weight: .bold)
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Apple SD Gothic Neo", size: 14)
        label.numberOfLines = 3
        label.text = "This is the best movie ever to watch as a Kid! and sadjascljack dksfsjlvasdipvdsjkasdasdsdasdasdasdslsdvdvkasdvl fasdassdcassadasdasasdasdㅁㄴㅇㅁㄴㅇㅁㄴㅇㅁㄴㅇASdsadsadsadasDSADasdsadsadadASDAsdasDSAdsadsadasddasdasdsadasdsdcascsacsc"
        return label
    }()
    
    var commentTableView: UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.register(CommentTableViewCell.self, forCellReuseIdentifier: "CommentTableViewCell")
        return tableview
    }()
    
    let writeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "paperplane"), for: .normal)
        button.addTarget(DetailView.self, action: #selector(writeComment), for: .touchUpInside)
        return button
    }()
    
    let userProfileImage: UIImageView = {
        let profileImage = UIImageView()
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        profileImage.image = UIImage(systemName: "person.crop.circle")
        profileImage.sizeToFit()
        return profileImage
    }()
    
    var commentTextField: UITextField = {
        let textfield = UITextField()
        textfield.translatesAutoresizingMaskIntoConstraints = false
        textfield.placeholder = "댓글 추가..."
        
        textfield.layer.cornerRadius = 2
        textfield.layer.borderWidth = 2
        textfield.layer.borderColor = UIColor.gray.cgColor.copy(alpha: 0.8)
        return textfield
    }()
    
    var commentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.backgroundColor = .systemBackground
        return stackView
    }()

    let overviewStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .top
        return stackView
    }()
    
    private let likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("👍🏼", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.sizeToFit()
        return button
    }()
    
    private let webView: WKWebView = {
        let config = WKWebViewConfiguration()
        // fullscreen 막기
        config.allowsInlineMediaPlayback = true
        let webView = WKWebView(frame: .zero, configuration: config)
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    func configureConstraints() {
        let webViewContstraints = [
            webView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 15),
            webView.leadingAnchor.constraint(equalTo: leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 250)
        ]

        let profileImageButtonConstraints = [
            profileImageButton.topAnchor.constraint(equalTo: viewtimeLabel.bottomAnchor, constant: 18),
            profileImageButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            profileImageButton.heightAnchor.constraint(equalToConstant: 40),
            profileImageButton.widthAnchor.constraint(equalToConstant: 40)
        ]

        let profileLabelConstraints = [
            profileLabel.centerYAnchor.constraint(equalTo: profileImageButton.centerYAnchor),
            profileLabel.leadingAnchor.constraint(equalTo: profileImageButton.trailingAnchor, constant: 15)
        ]

        let overviewstackViewConstraints = [
            overviewStackView.topAnchor.constraint(equalTo: profileImageButton.bottomAnchor, constant: 15),
            overviewStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            overviewStackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ]
        let titleStackViewConstraints = [
            titleStackView.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 8),
            titleStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 20)
        ]

        let likeButtonConstraints = [
            likeButton.centerYAnchor.constraint(equalTo: profileLabel.centerYAnchor),
            likeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ]
        let viewtimeLabelConstraints = [
            viewtimeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            viewtimeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        ]
        let commentTableViewConstraints = [
            commentTableView.topAnchor.constraint(equalTo: overviewStackView.bottomAnchor),
            commentTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            commentTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            commentTableView.bottomAnchor.constraint(equalTo: commentStackView.topAnchor)
        ]
        let commentStackViewConstraints = [
            commentStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            commentStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
            commentStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            commentStackView.heightAnchor.constraint(equalToConstant: 40)
        ]
        let userProfileImageConstraints = [
            userProfileImage.widthAnchor.constraint(equalToConstant: 40)
        ]
        let writeButtonConstratins = [
            writeButton.widthAnchor.constraint(equalToConstant: 30)
        ]

        NSLayoutConstraint.activate(webViewContstraints)
        NSLayoutConstraint.activate(profileImageButtonConstraints)
        NSLayoutConstraint.activate(overviewstackViewConstraints)
        NSLayoutConstraint.activate(titleStackViewConstraints)
        NSLayoutConstraint.activate(profileLabelConstraints)
        NSLayoutConstraint.activate(likeButtonConstraints)
        NSLayoutConstraint.activate(viewtimeLabelConstraints)
        NSLayoutConstraint.activate(commentTableViewConstraints)
        NSLayoutConstraint.activate(commentStackViewConstraints)
        NSLayoutConstraint.activate(userProfileImageConstraints)
        NSLayoutConstraint.activate(writeButtonConstratins)
    }
    
    func configureVideo() {
        guard let url = URL(string: "https://www.youtube.com/embed/m6-A6SkJ0xw") else {
            return
        }
        webView.load(URLRequest(url: url))
    }
    
    func initializeUI() {
        backgroundColor = .systemBackground
        addSubview(webView)
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(viewtimeLabel)
        addSubview(titleStackView)
        addSubview(profileImageButton)
        addSubview(profileLabel)
        addSubview(likeButton)
        overviewStackView.addArrangedSubview(overviewLabel)
        addSubview(overviewStackView)
        addSubview(commentTableView)
        commentStackView.addArrangedSubview(userProfileImage)
        commentStackView.addArrangedSubview(commentTextField)
        commentStackView.addArrangedSubview(writeButton)
        addSubview(commentStackView)
        commentTableView.dataSource = self
        commentTableView.delegate = self
        commentTextField.delegate = self
        addKeyboardNotifications()
        configureConstraints()
        addTopBorderToTextField(with: UIColor.systemGray, andWidth: CGFloat(0.5))
        
        hideKeyboard()
        configureVideo()
        SwipeScreen()
        setupLabelTap()
    }
    
    @objc func overviewLabelTapped(_ sender: UITapGestureRecognizer) {
        overviewLabel.numberOfLines = 0
    }

    func setupLabelTap() {
        let labelTap = UITapGestureRecognizer(target: self, action: #selector(overviewLabelTapped(_:)))
        overviewLabel.isUserInteractionEnabled = true
        overviewLabel.addGestureRecognizer(labelTap)
    }
    
    func SwipeScreen() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        addGestureRecognizer(panGestureRecognizer)
    }
    
    func addTopBorderToTextField(with color: UIColor?, andWidth borderWidth: CGFloat) {
        let border = UIView()
        border.backgroundColor = color
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: commentStackView.frame.width, height: borderWidth)
        commentStackView.addSubview(border)
    }
    
    func addKeyboardNotifications() {
        // 키보드가 나타날 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        // 키보드가 사라질 때 앱에게 알리는 메서드 추가
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        // keyboardWillShow
        // 현재 동작하고 있는 이벤트에서 키보드의 frame을 받아옴
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.height

        if frame.origin.y == 0 {
            frame.origin.y -= keyboardHeight
        }
    }

    @objc func keyboardWillHide(_ sender: Notification) {
        if frame.origin.y != 0 {
            frame.origin.y = 0
        }
    }
    
    @objc func writeComment() {
        if commentTextField.text != "" {
            comment?.content = commentTextField.text ?? ""
            EventBus.shared.emit(AddComentEvent(payload: .init(content: comment?.content ?? "")))
        }
        commentTextField.text = ""
        commentTableView.reloadData()
    }
    
    @objc func handlePanGesture(_ panGesture: UIPanGestureRecognizer) {
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
                UIView.animate(withDuration: 0.2,
                               animations: {
                                   self.frame.origin = CGPoint(
                                       x: self.frame.origin.x,
                                       y: self.frame.size.height)
                               }, completion: { isCompleted in
                                   if isCompleted {
                                       EventBus.shared.emit(CloseDetailViewEvent())
                                   }
                               })
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
        writeButton.isEnabled = false
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (commentTextField.text! as NSString).replacingCharacters(in: range, with: string)
        if !text.isEmpty {
            writeButton.isEnabled = true
        } else {
            writeButton.isEnabled = false
        }
        return true
    }
}

extension DetailView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CommentTableViewCell", for: indexPath) as? CommentTableViewCell else { return UITableViewCell() }
        cell.comment = comments[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! CommentTableViewCell

        tableView.performBatchUpdates {
            cell.changeLine()
        }
    }
}

extension DetailView {
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(DetailView.dismissKeyboard))
        addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        endEditing(true)
    }
}
