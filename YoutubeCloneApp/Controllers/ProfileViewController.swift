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
        rootView.user = user
        navigationController?.navigationBar.backgroundColor = .white
        navigationItem.titleView = {
            let titleView = UIImageView()
            titleView.image = .init(named: "Youtube Main")
            titleView.contentMode = .scaleAspectFit
            return titleView
        }()
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

extension ProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)

        guard let itemProvider = results.first?.itemProvider,
              itemProvider.canLoadObject(ofClass: UIImage.self)
        else { return }

        itemProvider.loadObject(ofClass: UIImage.self) { [weak self] image, _ in
            guard let self, let selectedImage = image as? UIImage else { return }
            self.user?.uiAvatar = selectedImage
        }
    }
}
