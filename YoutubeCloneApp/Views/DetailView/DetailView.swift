import UIKit

final class DetailView: UIView, RootView {
    private lazy var label = {
        let label = UILabel()
        label.text = "Detail View"
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
}