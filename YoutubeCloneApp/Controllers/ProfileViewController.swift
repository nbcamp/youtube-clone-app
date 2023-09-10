import PhotosUI
import UIKit

struct UpdateUserProfileEvent: EventProtocol {
    struct Payload {
        let avatar: UIImage?
        let name: String
        let email: String
    }

    let payload: Payload
}

final class ProfileViewController: TypedViewController<ProfileView> {
    private var user: User? { AuthService.shared.user }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.navigationBar.backgroundColor = .white
        navigationItem.titleView = {
            let titleView = UIImageView()
            titleView.image = .init(named: "Youtube Main")
            titleView.contentMode = .scaleAspectFit
            return titleView
        }()

        AuthService.shared.$user.subscribe(by: self, immediate: true) { subscriber, changes in
            subscriber.rootView.user = changes.new
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        EventBus.shared.on(UpdateUserProfileEvent.self, by: self) { listener, payload in
            guard let user = listener.user else { return }
            AuthService.shared.update(user: .init(
                avatar: payload.avatar?.base64,
                name: payload.name,
                email: payload.email,
                password: user.password
            ))
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        EventBus.shared.reset(self)
    }
}
