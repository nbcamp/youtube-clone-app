import UIKit

final class SignInViewController: TypedViewController<SignInView>, UITextFieldDelegate {

    override func loadView() {
        let signInView = SignInView()
        view = signInView
        signInView.initializeUI()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let signInView = view as? SignInView else { fatalError("View is not of type SignInView") }

        signInView.emailTextField.delegate = self
        signInView.passwordTextField.delegate = self

        signInView.signUpButton.addTarget(self, action: #selector(handleSignUpButtonDirectly), for: .touchUpInside)
        
        signInView.signInButton.addTarget(self, action: #selector(handleSigninButtonTapped), for: .touchUpInside)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        EventBus.shared.on(SignInEvent.self, by: self, handleSignIn)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        guard let activeTextField = UIResponder.currentFirstResponder as? UITextField else { return }
        
        let convertedTextFieldRect = activeTextField.convert(activeTextField.bounds, to: self.view)
        let textFieldBottomPoint = convertedTextFieldRect.origin.y + convertedTextFieldRect.size.height
        let keyboardTopPoint = self.view.frame.size.height - keyboardSize.height
        
        if textFieldBottomPoint > keyboardTopPoint {
            let overlap = textFieldBottomPoint - keyboardTopPoint
            self.view.transform = CGAffineTransform(translationX: 0, y: -overlap - 10)
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        self.view.transform = .identity
    }

    @objc private func handleSigninButtonTapped() {
        guard let signInView = view as? SignInView,
              let email = signInView.emailTextField.text,
              let password = signInView.passwordTextField.text else {
            return
        }

        AuthService.shared.signIn(email: email, password: password) { (success) in
            if success {
                print("signin success")
            } else {
                print("signin fail")
            }
        }
    }


    @objc private func handleSignUpButtonDirectly() {
        print("tap")
        let signUpVC = SignUpViewController()
        navigationController?.pushViewController(signUpVC, animated: true)
    }
    
    private func handleSignUpButtonTapped(listener: SignInViewController, _: Void) {
        let signUpVC = SignUpViewController()
        listener.navigationController?.pushViewController(signUpVC, animated: true)
    }
    struct SignInEvent: EventProtocol {
        typealias Payload = (email: String, password: String)
        var payload: Payload
    }

    
    private func handleSignIn(listener: SignInViewController, payload: SignInEvent.Payload) {
        AuthService.shared.signIn(email: payload.email, password: payload.password) { (success) in
            if success {
                print("signin success")

                let homeVC = HomeViewController()
                listener.navigationController?.pushViewController(homeVC, animated: true)
                
            } else {
                print("signin fail")

            }
        }
    }


 
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        print("textFieldShouldBeginEditing called for textField: \(textField)")
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        EventBus.shared.on(SignUpButtonTappedEvent.self, by: self, handleSignUpButtonTapped)
        EventBus.shared.on(SignInEvent.self, by: self, handleSignIn)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        EventBus.shared.reset(self)
    }
}


extension UIResponder {
    private static weak var _currentFirstResponder: UIResponder?
    
    static var currentFirstResponder: UIResponder? {
        _currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(findFirstResponder(sender:)), to: nil, from: nil, for: nil)
        return _currentFirstResponder
    }
    
    @objc private func findFirstResponder(sender: Any) {
        UIResponder._currentFirstResponder = self
    }
}
