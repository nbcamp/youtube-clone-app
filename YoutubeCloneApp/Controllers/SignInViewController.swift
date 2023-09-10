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
                        EventBus.shared.emit(
                            AlertErrorEvent(payload: .init(
                                viewController: self,
                                message: "Incorrect Email or Password"
                            ))
                        )
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
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        else { return }

        let keyboardHeight = keyboardFrame.cgRectValue.height
        if let activeTextField = findFirstResponder(inView: rootView) {
            let textFieldBottomPoint = activeTextField.convert(activeTextField.bounds, to: rootView).maxY
            let overlap = textFieldBottomPoint - (view.bounds.height - keyboardHeight) + 40

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

    deinit { NotificationCenter.default.removeObserver(self) }
}
