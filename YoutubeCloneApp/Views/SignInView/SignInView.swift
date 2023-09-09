import UIKit

final class SignInView: UIView, RootView {
    
    private lazy var imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.image = UIImage(systemName: "photo.fill")
        return iv
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Email"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter your email"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Password"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Enter your password"
        textField.borderStyle = .roundedRect
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private lazy var signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign In", for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 5
        return button
    }()
    
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 5
        return button
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [imageView, fieldsStackView, buttonsStackView])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 125
        return stackView
    }()
    
    private lazy var fieldsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [emailLabel, emailTextField, passwordLabel, passwordTextField])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 18
        return stackView
    }()
    
    private lazy var buttonsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [signInButton, signUpButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    func initializeUI() {
        backgroundColor = .systemBackground
        
        addSubview(mainStackView)
        
        setupConstraints()
        
        emailTextField.delegate = self
        passwordTextField.delegate = self

        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 90),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            imageView.heightAnchor.constraint(equalToConstant: 90),
            signInButton.heightAnchor.constraint(equalToConstant: 40),
            signUpButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
    
    @objc private func signInButtonTapped() {
        let email = emailTextField.text ?? ""
        let password = passwordTextField.text ?? ""
        EventBus.shared.emit(SignInEvent(payload: .init(email: email, password: password)))
    }

    @objc private func signUpButtonTapped() {
        EventBus.shared.emit(PushToSignUpViewEvent())
    }
}

extension SignInView: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("textFieldShouldBeginEditing called for textField: \(textField)")
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
extension SignInView {
    var emailAddress: String? {
        return emailTextField.text
    }
    
    var password: String? {
        return passwordTextField.text
    }
    func setEmailTextFieldDelegate(_ delegate: UITextFieldDelegate?) {
        emailTextField.delegate = delegate
    }

    func setPasswordTextFieldDelegate(_ delegate: UITextFieldDelegate?) {
        passwordTextField.delegate = delegate
    }
}
