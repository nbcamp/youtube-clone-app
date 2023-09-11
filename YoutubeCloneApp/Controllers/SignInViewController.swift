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
    private var keyboardHandler: KeyboardHandler?

    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardHandler = .init(view: rootView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardHandler?.register(view: rootView)

        EventBus.shared.on(PushToSignUpViewEvent.self, by: self) { listener, _ in
            let signUpVC = SignUpViewController()
            listener.navigationController?.pushViewController(signUpVC, animated: true)
        }

        EventBus.shared.on(SignInEvent.self, by: self) { listener, payload in
            AuthService.shared.signIn(
                email: payload.email,
                password: payload.password
            ) { [weak listener] error in
                DispatchQueue.main.async {
                    switch error {
                    case .userNotFound:
                        listener?.alertError(message: "User not found. Please sign Up.")
                    case .incorrectInput:
                        listener?.alertError(message: "Incorrect email address or password.")
                    default:
                        listener?.dismiss(animated: true, completion: nil)
                    }
                }
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        keyboardHandler?.unregister()
        EventBus.shared.reset(self)
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

    private func alertError(message: String) {
        EventBus.shared.emit(
            AlertErrorEvent(payload: .init(
                viewController: self,
                message: message
            ))
        )
    }
}
