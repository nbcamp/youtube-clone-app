import UIKit

final class HomeView: UIView, RootView {
    weak var user: User? {
        didSet { observeUserChanged(user: user) }
    }

    private lazy var label = {
        let label = UILabel()
        label.sizeToFit()
        return label
    }()

    func initializeUI() {
        addSubview(label)

        backgroundColor = .systemBackground
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }

    private func observeUserChanged(user: User?) {
        guard let user else { return }
        user.$name.subscribe(by: self, immediate: true) { (subscriber, changes) in
            subscriber.label.text = changes.new
        }
    }
}
