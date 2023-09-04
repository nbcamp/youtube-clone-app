import UIKit

final class SignInView: UIView, RootView {
    private lazy var button = {
        let button = UIButton(type: .custom)
        button.setTitle("SIGN IN (Tap Here)", for: .normal)
        button.setTitleColor(.label, for: .normal)
        return button
    }()

    func initializeUI() {
        addSubview(button)

        backgroundColor = .systemBackground
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: centerXAnchor),
            button.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])

        button.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
    }

    @objc private func signInButtonTapped() {
        EventBus.shared.emit(SignInEvent(payload: .init(email: "email", password: "password")))
    }
}
