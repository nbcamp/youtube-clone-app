import UIKit

final class SignUpView: UIView, RootView {
    private lazy var avatarView = {
        let avatarView = AvatarView(size: 150)
        return avatarView
    }()

    private lazy var fieldContainer: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            nameGroup,
            emailGroup,
            passwordGroup,
            confirmPasswordGroup,
        ])
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()

    private lazy var nameGroup = {
        let nameGroup = TextFieldGroup()
        nameGroup.delegate = self
        nameGroup.labelText = "Name"
        nameGroup.placeholder = "Enter your name"
        return nameGroup
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

    private lazy var confirmPasswordGroup = {
        let passwordGroup = TextFieldGroup()
        passwordGroup.delegate = self
        passwordGroup.labelText = "Confirm Password"
        passwordGroup.placeholder = "Re-enter your password for confirm"
        passwordGroup.isSecureTextEntry = true
        return passwordGroup
    }()

    private lazy var buttonContainer: UIStackView = {
        let buttonsStackView = UIStackView(arrangedSubviews: [
            signUpButton,
        ])
        buttonsStackView.axis = .vertical
        buttonsStackView.spacing = 12
        return buttonsStackView
    }()

    private lazy var signUpButton: UIButton = {
        let signUpButton = Button(variant: .primary)
        signUpButton.setTitle("Sign Up", for: .normal)
        return signUpButton
    }()

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        endEditing(true)
    }

    func initializeUI() {
        backgroundColor = .systemBackground
        addSubview(avatarView)
        addSubview(fieldContainer)
        addSubview(buttonContainer)

        let guide = safeAreaLayoutGuide
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        fieldContainer.translatesAutoresizingMaskIntoConstraints = false
        buttonContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarView.topAnchor.constraint(equalTo: guide.topAnchor, constant: 40),
            avatarView.centerXAnchor.constraint(equalTo: guide.centerXAnchor),

            fieldContainer.topAnchor.constraint(equalTo: avatarView.bottomAnchor, constant: 20),
            fieldContainer.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20),
            fieldContainer.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -20),

            buttonContainer.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20),
            buttonContainer.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -20),
            buttonContainer.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -40),
        ])

        avatarView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(avatarViewTapped)))
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }

    @objc private func avatarViewTapped() {
        EventBus.shared.emit(
            PickImagesEvent(
                payload: .init(
                    viewController: viewController,
                    selectionLimit: 1,
                    filter: .images
                ) { [weak self] images in
                    self?.avatarView.image = images.first
                }
            )
        )
    }

    @objc private func signUpButtonTapped() {
        EventBus.shared.emit(
            SignUpEvent(
                payload: .init(
                    name: nameGroup.text ?? "",
                    avatar: avatarView.image?.base64 ?? "",
                    email: emailGroup.text ?? "",
                    password: passwordGroup.text ?? "",
                    confirmPassword: confirmPasswordGroup.text ?? ""
                )
            )
        )
    }
}

extension SignUpView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
