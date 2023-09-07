import UIKit
import WebKit
final class DetailView: UIView, RootView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "Harry potter"
        return label
    }()

    private let profileImageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setBackgroundImage(UIImage(systemName: "person.crop.circle"), for: .normal)
        return button
    }()

    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Apple SD Gothic Neo", size: 14)
        label.numberOfLines = 3
        label.text = "This is the best movie ever to watch as a Kid! and sadjascljack dksfsjlvasdipvdsjkasdasdsdasdasdasdslsdvdvkasdvl fasdassdcassadasdasasdasdㅁㄴㅇㅁㄴㅇㅁㄴㅇㅁㄴㅇASdsadsadsadasDSADasdsadsadadASDAsdasDSAdsadsadasddasdasdsadasdsdcascsacsc"
        return label
    }()


    private let likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("👍🏼", for: .normal)
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
            profileImageButton.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 18),
            profileImageButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            profileImageButton.heightAnchor.constraint(equalToConstant: 40),
            profileImageButton.widthAnchor.constraint(equalToConstant: 40)
        ]
        let titleLabelConstraints = [
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 24),
            titleLabel.leadingAnchor.constraint(equalTo: profileImageButton.trailingAnchor, constant: 10)
        ]

        let overviewLabelConstraints = [
            overviewLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            overviewLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            overviewLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -50),
            overviewLabel.heightAnchor.constraint(equalToConstant: 50)
        ]
        let likeButtonConstraints = [
            likeButton.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 24),
            likeButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ]

        NSLayoutConstraint.activate(webViewContstraints)
        NSLayoutConstraint.activate(profileImageButtonConstraints)
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(overviewLabelConstraints)
        NSLayoutConstraint.activate(likeButtonConstraints)
    }

    func configure() {
        guard let url = URL(string: "https://www.youtube.com/embed/m6-A6SkJ0xw") else {
            return
        }
        webView.load(URLRequest(url: url))
    }


    func initializeUI() {
        backgroundColor = .systemBackground
        addSubview(webView)
        addSubview(titleLabel)
        addSubview(profileImageButton)
        addSubview(overviewLabel)
        addSubview(likeButton)
        configureConstraints()
        configure()
        isSwipable()
    }
    func isSwipable() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        self.addGestureRecognizer(panGestureRecognizer)
    }
    @objc func handlePanGesture(_ panGesture: UIPanGestureRecognizer) {
        let translation = panGesture.translation(in: self)
        let minY = frame.height * 0.15
        var originalPosition = CGPoint.zero

        if panGesture.state == .began {
            originalPosition = center
        } else if panGesture.state == .changed {
            frame.origin = CGPoint(x: 0.0, y: translation.y)

            if panGesture.location(in: self).y > minY {
                frame.origin = originalPosition
            }

            if frame.origin.y <= 0.0 {
                frame.origin.y = 0.0
            }
        } else if panGesture.state == .ended {
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
        }
    }
}
