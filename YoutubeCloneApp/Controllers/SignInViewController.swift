import UIKit

final class SignInViewController: TypedViewController<SignInView> {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupEvents()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        EventBus.shared.reset(self)
    }
}

extension SignInViewController {
    func setupEvents() {
        EventBus.shared.on(SignInEvent.self, by: self) { (listener, payload) in
            print(payload.email, payload.password)
            listener.dismiss(animated: true)
        }
    }
}
