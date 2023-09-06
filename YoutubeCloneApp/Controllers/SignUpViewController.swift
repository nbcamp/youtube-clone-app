import UIKit

class SignUpViewController: TypedViewController<SignUpView>, UITextFieldDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)

        rootView.userNameTF.delegate = self
        rootView.emailTF.delegate = self
        rootView.passwordTF.delegate = self
        rootView.confirmPasswordTF.delegate = self
        rootView.signUpButton.addTarget(self, action: #selector(handleSignUpButtonTapped), for: .touchUpInside)
    }

    @objc private func handleSignUpButtonTapped() {
        guard let email = rootView.emailTF.text,
              let password = rootView.passwordTF.text,
              let confirmPassword = rootView.confirmPasswordTF.text,
              password == confirmPassword else {
            
            return
        }

        AuthService.shared.signUp(email: email, password: password) { (success) in
            if success {
                print("success")
            } else {
                print("fail")
            }
        }
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else {
            return
        }

        let keyboardHeight = keyboardFrame.cgRectValue.height

        if let activeTextField = findFirstResponder(inView: rootView) {
            let textFieldBottomPoint = activeTextField.convert(activeTextField.bounds, to: rootView).maxY
            let overlap = textFieldBottomPoint - (view.bounds.height - keyboardHeight)

            if overlap > 0 {
                view.frame.origin.y = -CGFloat(overlap)
            }
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        view.frame.origin.y = 0
    }

    private func findFirstResponder(inView view: UIView) -> UITextField? {
        if let textField = view as? UITextField, textField.isFirstResponder {
            return textField
        }

        for subView in view.subviews {
            if let activeTextField = findFirstResponder(inView: subView) {
                return activeTextField
            }
        }

        return nil
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
