import UIKit
import WebKit
final class DetailView: UIView, RootView {
    private let titleStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.translatesAutoresizingMaskIntoConstraints = false
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

        NSLayoutConstraint.activate(webViewContstraints)
        NSLayoutConstraint.activate(profileImageButtonConstraints)
        NSLayoutConstraint.activate(overviewstackViewConstraints)
        NSLayoutConstraint.activate(titleStackViewConstraints)
        NSLayoutConstraint.activate(profileLabelConstraints)
        NSLayoutConstraint.activate(likeButtonConstraints)
        NSLayoutConstraint.activate(viewtimeLabelConstraints)
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
        titleStackView.addSubview(viewtimeLabel)
        addSubview(titleStackView)
        addSubview(profileImageButton)
        addSubview(profileLabel)
        addSubview(likeButton)
        overviewStackView.addArrangedSubview(overviewLabel)
        addSubview(overviewStackView)
        configureConstraints()
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
