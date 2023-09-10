import UIKit

final class SignInView: UIView, RootView {
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "Youtube Logo")
        return imageView
    }()

    private lazy var emailGroup = {
        let emailGroup = TextFieldGroup()
        emailGroup.delegate = self
        emailGroup.labelText = "Email"
        emailGroup.placeholder = "Enter your email"
        return emailGroup
    }()

    private lazy var passwordGroup = {
        let passwordGroup = TextFieldGroup()
        passwordGroup.delegate = self
        passwordGroup.labelText = "Password"
        passwordGroup.placeholder = "Enter your password"
        passwordGroup.isSecureTextEntry = true
        return passwordGroup
    }()

    private lazy var signInButton: UIButton = {
        let signInButton = Button(variant: .primary)
        signInButton.setTitle("Sign In", for: .normal)
        return signInButton
    }()

    private lazy var signUpButton: UIButton = {
        let signUpButton = Button(variant: .secondary)
        signUpButton.setTitle("Sign Up", for: .normal)
        return signUpButton
    }()

    private lazy var fieldsStackView: UIStackView = {
        let fieldsStackView = UIStackView(arrangedSubviews: [
            emailGroup,
            passwordGroup
        ])
        fieldsStackView.translatesAutoresizingMaskIntoConstraints = false
        fieldsStackView.axis = .vertical
        fieldsStackView.spacing = 10
        return fieldsStackView
    }()

    private lazy var buttonsStackView: UIStackView = {
        let buttonsStackView = UIStackView(arrangedSubviews: [signInButton, signUpButton])
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.axis = .vertical
        buttonsStackView.spacing = 10
        return buttonsStackView
    }()

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        endEditing(true)
    }

    func initializeUI() {
        backgroundColor = .systemBackground
        addSubview(imageView)
        addSubview(fieldsStackView)
        addSubview(buttonsStackView)

        let guide = safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 20),
            imageView.widthAnchor.constraint(equalTo: guide.widthAnchor, multiplier: 0.5),
            imageView.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            
            fieldsStackView.topAnchor.constraint(equalTo: imageView.bottomAnchor),
            fieldsStackView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20),
            fieldsStackView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -20),
            

            buttonsStackView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20),
            buttonsStackView.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -20),
            buttonsStackView.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -40)
        ])

        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }

    @objc private func signInButtonTapped() {
        let email = emailGroup.text ?? ""
        let password = passwordGroup.text ?? ""
        EventBus.shared.emit(SignInEvent(payload: .init(email: email, password: password)))
    }

    @objc private func signUpButtonTapped() {
        EventBus.shared.emit(PushToSignUpViewEvent())
    }
}

extension SignInView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
