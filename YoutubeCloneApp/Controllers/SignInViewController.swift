import UIKit

final class SignInViewController: TypedViewController<SignInView> {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        EventBus.shared.on(SignInEvent.self, by: self) { listener, payload in
            print(payload.email, payload.password)
            AuthService.shared.login(
                email: payload.email,
                password: payload.password
            )
            listener.dismiss(animated: true)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        EventBus.shared.reset(self)
    }
}
