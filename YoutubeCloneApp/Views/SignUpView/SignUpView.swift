import UIKit

final class SignUpView: UIView, RootView {
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "photo.circle")
        imageView.tintColor = .gray
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        return label
    }()
    
    private lazy var emailLabel: UILabel = {
        let label = UILabel()
        label.text = "Email"
        return label
    }()
    
    private lazy var passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        return label
    }()
    
    private lazy var confirmPasswordLabel: UILabel = {
        let label = UILabel()
        label.text = "Confirm Password"
        return label
    }()
    
    private lazy var userNameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이름"
        textField.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.delegate = self
        return textField
    }()
    
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이메일"
        textField.keyboardType = .emailAddress
        textField.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.delegate = self
        return textField
    }()
    
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.isSecureTextEntry = true
        textField.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.delegate = self
        return textField
    }()
    
    private lazy var confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Confirm Password"
        textField.isSecureTextEntry = true
        textField.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.delegate = self
        return textField
    }()
    
    private let signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("SignUp", for: .normal)
        button.backgroundColor = .blue
        button.layer.cornerRadius = 10
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [profileImageView, fieldsStackView, signUpButton])
        stackView.axis = .vertical
        stackView.spacing = 20
        return stackView
    }()
    
    private lazy var fieldsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [userNameLabel, userNameTextField, emailLabel, emailTextField, passwordLabel, passwordTextField, confirmPasswordLabel, confirmPasswordTextField])
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initializeUI()
    }
    
    func initializeUI() {
        addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            mainStackView.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40)
        ])
    }
}

extension SignUpView: UITextFieldDelegate {}

// extension SignUpView {
//    var userEmail: String? {
//        return emailTextField.text
//    }
//
//    var userPassword: String? {
//        return passwordTextField.text
//    }
//
//    var userConfirmPassword: String? {
//        return confirmPasswordTextField.text
//    }
//
//    func configureUI(delegate: UITextFieldDelegate, actionTarget: Any, action: Selector) {
//        userNameTextField.delegate = delegate
//        emailTextField.delegate = delegate
//        passwordTextField.delegate = delegate
//        confirmPasswordTextField.delegate = delegate
//        signUpButton.addTarget(actionTarget, action: action, for: .touchUpInside)
//    }
//
//    func findFirstResponder() -> UITextField? {
//        return findFirstResponder(inView: self)
//    }
//
//    private func findFirstResponder(inView view: UIView) -> UITextField? {
//        if let textField = view as? UITextField, textField.isFirstResponder {
//            return textField
//        }
//
//        for subView in view.subviews {
//            if let activeTextField = findFirstResponder(inView: subView) {
//                return activeTextField
//            }
//        }
//
//        return nil
//    }
// }
