import UIKit

final class SignInViewController: TypedViewController<SignInView> {
    override func viewDidLoad() {
        super.viewDidLoad()

        rootView.setEmailTextFieldDelegate(self)

        EventBus.shared.on(SignUpButtonTappedEvent.self, by: self) { listener, payload in
            self.handleSignUpButtonTapped(listener: listener, payload: payload)
        }
        EventBus.shared.on(SignInEvent.self, by: self) { listener, event in
            self.handleSignIn(listener: listener, payload: event)
        }

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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

    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        guard let activeTextField = UIResponder.currentFirstResponder as? UITextField else { return }

        let convertedTextFieldRect = activeTextField.convert(activeTextField.bounds, to: view)
        let textFieldBottomPoint = convertedTextFieldRect.origin.y + convertedTextFieldRect.size.height
        let keyboardTopPoint = view.frame.size.height - keyboardSize.height

        if textFieldBottomPoint > keyboardTopPoint {
            let overlap = textFieldBottomPoint - keyboardTopPoint
            view.transform = CGAffineTransform(translationX: 0, y: -overlap - 10)
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        view.transform = .identity
    }

    @objc private func handleSigninButtonTapped() {
        guard let email = rootView.emailAddress,
              let password = rootView.password
        else {
            return
        }

        AuthService.shared.signIn(email: email, password: password) { success in
            if success {
                print("signin success")
            } else {
                print("signin fail")
            }
        }
    }

    @objc private func handleSignUpButtonDirectly() {
        let signUpVC = SignUpViewController()
        navigationController?.pushViewController(signUpVC, animated: true)
    }

    private func handleSignUpButtonTapped(listener: SignInViewController, payload: SignUpButtonTappedEvent.Payload) {
        let signUpVC = SignUpViewController()
        listener.navigationController?.pushViewController(signUpVC, animated: true)
    }

    private func handleSignIn(listener: SignInViewController, payload: SignInEvent.Payload) {
        AuthService.shared.signIn(email: payload.email, password: payload.password) { success in
            if success {
                listener.dismiss(animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Error", message: "Email or password is incorrect.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                listener.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension SignInViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension UIResponder {
    private weak static var _currentFirstResponder: UIResponder?

    static var currentFirstResponder: UIResponder? {
        _currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(findFirstResponder(sender:)), to: nil, from: nil, for: nil)
        return _currentFirstResponder
    }

    @objc private func findFirstResponder(sender: Any) {
        UIResponder._currentFirstResponder = self
    }
}
