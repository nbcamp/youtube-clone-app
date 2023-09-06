import UIKit

final class SignUpView: UIView, RootView {
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo.circle")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let userNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이름"
        textField.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        return textField
    }()

    
    private let emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이메일"
        textField.keyboardType = .emailAddress
        textField.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        return textField
    }()

    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        return textField
    }()

    private let confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Confirm Password"
        textField.isSecureTextEntry = true
        textField.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        return textField
    }()

    let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SignUp", for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        return label
    }()

    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        return label
    }()

    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        return label
    }()

    private let confirmPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Confirm Password"
        return label
    }()

    func initializeUI() {
        addSubview(profileImageView)
        addSubview(userNameLabel)
        addSubview(userNameTextField)
        addSubview(emailLabel)
        addSubview(emailTextField)
        addSubview(passwordLabel)
        addSubview(passwordTextField)
        addSubview(confirmPasswordLabel)
        addSubview(confirmPasswordTextField)
        addSubview(signUpButton)

        backgroundColor = .systemBackground

        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userNameTextField.translatesAutoresizingMaskIntoConstraints = false
        emailLabel.translatesAutoresizingMaskIntoConstraints = false
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordLabel.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordLabel.translatesAutoresizingMaskIntoConstraints = false
        confirmPasswordTextField.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 150),
            profileImageView.widthAnchor.constraint(equalToConstant: 100),
            profileImageView.heightAnchor.constraint(equalToConstant: 100),

            userNameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 50),
            userNameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            userNameLabel.bottomAnchor.constraint(equalTo: userNameTextField.topAnchor, constant: -5),
            userNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            userNameTextField.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 80),
            userNameTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            userNameTextField.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.8),
            userNameTextField.heightAnchor.constraint(equalToConstant: 40),

            emailLabel.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 10),
            emailLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            emailLabel.bottomAnchor.constraint(equalTo: emailTextField.topAnchor, constant: -5),
            emailLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            emailTextField.topAnchor.constraint(equalTo: userNameTextField.bottomAnchor, constant: 40),
            emailTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            emailTextField.widthAnchor.constraint(equalTo: userNameTextField.widthAnchor),
            emailTextField.heightAnchor.constraint(equalToConstant: 40),

            passwordLabel.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 10),
            passwordLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            passwordLabel.bottomAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -5),
            passwordLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 40),
            passwordTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            passwordTextField.widthAnchor.constraint(equalTo: userNameTextField.widthAnchor),
            passwordTextField.heightAnchor.constraint(equalToConstant: 40),

            confirmPasswordLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 10),
            confirmPasswordLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            confirmPasswordLabel.bottomAnchor.constraint(equalTo: confirmPasswordTextField.topAnchor, constant: -5),
            confirmPasswordLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

            confirmPasswordTextField.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 40),
            confirmPasswordTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            confirmPasswordTextField.widthAnchor.constraint(equalTo: userNameTextField.widthAnchor),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 40),

            signUpButton.topAnchor.constraint(equalTo: confirmPasswordTextField.bottomAnchor, constant: 40),
            signUpButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            signUpButton.widthAnchor.constraint(equalTo: userNameTextField.widthAnchor),
            signUpButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializeUI()
    }

    var userNameTF: UITextField {
        return userNameTextField
    }

    var emailTF: UITextField {
        return emailTextField
    }

    var passwordTF: UITextField {
        return passwordTextField
    }

    var confirmPasswordTF: UITextField {
        return confirmPasswordTextField
    }
}
