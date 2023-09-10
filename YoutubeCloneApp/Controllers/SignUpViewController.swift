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
    private var keyboardHandler: KeyboardHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardHandler = .init(view: rootView)
        setupNavigation()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardHandler?.register(view: rootView)

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
        keyboardHandler?.unregister()
        EventBus.shared.reset(self)
    }

    private func setupNavigation() {
        navigationItem.leftBarButtonItem = .init(image: .init(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem?.tintColor = .primary
    }

    @objc private func backButtonTapped() {
        navigationController?.popViewController(animated: true)
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
