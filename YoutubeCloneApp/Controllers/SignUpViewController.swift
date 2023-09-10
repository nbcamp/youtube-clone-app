import UIKit

struct SignUpEvent: EventProtocol {
    struct Payload {
        let name: String
        let avatar: Base64
        let email: String
        let password: String
        let confirmPassword: String
    }

    let payload: Payload
}

final class SignUpViewController: TypedViewController<SignUpView> {
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigation()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        EventBus.shared.on(SignUpEvent.self, by: self) { listener, payload in
            guard payload.password == payload.confirmPassword else {
                listener.alertError(message: "Passwords do not match.")
                return
            }
            AuthService.shared.signUp(
                avatar: payload.avatar,
                name: payload.name,
                email: payload.email,
                password: payload.password
            ) { [weak listener] error in
                DispatchQueue.main.async {
                    switch error {
                    case .invalidEmail:
                        listener?.alertError(message: "Invalid email format.")
                    case .invalidPassword:
                        listener?.alertError(message: "Invalid password format:\nmore than 6 chars\nwith at least one letter and number.")
                    default:
                        listener?.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        EventBus.shared.reset(self)
    }

    private func setupNavigation() {
        navigationItem.leftBarButtonItem = .init(image: .init(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = .primary
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
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

    private func alertError(message: String) {
        EventBus.shared.emit(
            AlertErrorEvent(payload: .init(
                viewController: self,
                message: message
            ))
        )
    }

    deinit { NotificationCenter.default.removeObserver(self) }
}
