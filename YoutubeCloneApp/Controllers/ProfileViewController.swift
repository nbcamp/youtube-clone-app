import PhotosUI
import UIKit

struct UpdateUserAvatarEvent: EventProtocol {
    let payload: Void = ()
}

struct UpdateUserProfileEvent: EventProtocol {
    struct Payload {
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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        EventBus.shared.on(UpdateUserAvatarEvent.self, by: self) { listener, _ in
            var configuration = PHPickerConfiguration()
            configuration.selectionLimit = 1
            configuration.filter = .images
            let pickerVC = PHPickerViewController(configuration: configuration)
            pickerVC.delegate = listener
            pickerVC.modalPresentationStyle = .popover
            listener.present(pickerVC, animated: true)
        }

        EventBus.shared.on(UpdateUserProfileEvent.self, by: self) { listener, payload in
            listener.user?.name = payload.name
            listener.user?.email = payload.email
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

        itemProvider.loadObject(ofClass: UIImage.self) {  [weak self] image, error in
            guard let self, let selectedImage = image as? UIImage else { return }
            self.user?.uiAvatar = selectedImage
        }
    }
}
