import UIKit

struct SignInEvent: EventProtocol {
    struct Payload {
        let email: String
        let password: String
    }

    let payload: Payload
}

struct PushToSignUpViewEvent: EventProtocol {
    let payload: Void = ()
}

final class SignInViewController: TypedViewController<SignInView> {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        EventBus.shared.on(PushToSignUpViewEvent.self, by: self) { listener, _ in
            let signUpVC = SignUpViewController()
            listener.navigationController?.pushViewController(signUpVC, animated: true)
        }

        EventBus.shared.on(SignInEvent.self, by: self) { listener, payload in
            AuthService.shared.signIn(email: payload.email, password: payload.password) { success in
                DispatchQueue.main.async {
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
}
