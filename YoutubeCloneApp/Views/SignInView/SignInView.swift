import UIKit

final class SignInView: UIView, RootView {
    let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(systemName: "photo.fill")
        return iv
    }()

    let emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Email"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()

    let emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter your email"
        textField.borderStyle = .roundedRect
        return textField
    }()

    let passwordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Password"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()

    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter your password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()

    let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign In", for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 5
        return button
    }()

    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 5
        return button
    }()

    var onSignUpButtonTapped: (() -> Void)?

    func initializeUI() {
        backgroundColor = .white

        addSubview(imageView)
        addSubview(emailLabel)
        addSubview(emailTextField)
        addSubview(passwordLabel)
        addSubview(passwordTextField)
        addSubview(signInButton)
        addSubview(signUpButton)

        setupConstraints()

        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)

        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 90),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.2),

            emailLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 65),
            emailLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),

            emailTextField.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 5),
            emailTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            emailTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),

            passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20),
            passwordLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),

            passwordTextField.topAnchor.constraint(equalTo: passwordLabel.bottomAnchor, constant: 5),
            passwordTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            passwordTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),

            signInButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 40),
            signInButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            signInButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            signInButton.heightAnchor.constraint(equalToConstant: 44),

            signUpButton.topAnchor.constraint(equalTo: signInButton.bottomAnchor, constant: 10),
            signUpButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            signUpButton.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            signUpButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }

    @objc private func signInButtonTapped() {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        EventBus.shared.emit(SignInEvent(payload: .init(email: email, password: password)))
    }

    @objc private func signUpButtonTapped() {
        onSignUpButtonTapped?()
    }
}
