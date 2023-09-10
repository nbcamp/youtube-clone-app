import PhotosUI
import UIKit

struct PickImagesEvent: EventProtocol {
    struct Payload {
        weak var viewController: UIViewController?
        let selectionLimit: Int?
        let filter: PHPickerFilter?
        let completion: ([UIImage]) -> Void
    }

    let payload: Payload
}

final class RootViewController: UITabBarController {
    var photoPicker: PhotoPicker?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupEvents()
        initializeTabBarController()

        DispatchQueue.main.async {
            if !AuthService.shared.isAuthenticated {
                let navigationController = UINavigationController()
                navigationController.modalPresentationStyle = .fullScreen
                navigationController.setViewControllers([SignInViewController()], animated: true)
                self.present(navigationController, animated: false)
            }
        }
    }

    private func initializeTabBarController() {
        let tabs: [(UIViewController.Type, String)] = [
            (HomeViewController.self, "house"),
            (ProfileViewController.self, "person"),
        ]

        setViewControllers(tabs.map { viewController, icon in
            let navigationController = UINavigationController(rootViewController: viewController.init())
            navigationController.tabBarItem = .init(title: nil, image: .init(systemName: icon), tag: 0)
            return navigationController
        }, animated: false)
    }

    private func setupEvents() {
        EventBus.shared.on(PickImagesEvent.self, by: self) { listener, payload in
            var config = PHPickerConfiguration()
            config.selectionLimit = payload.selectionLimit ?? 0
            config.filter = payload.filter
            let picker = PHPickerViewController(configuration: config)
            listener.photoPicker = PhotoPicker { [weak self] images in
                payload.completion(images)
                self?.photoPicker = nil
            }
            picker.delegate = listener.photoPicker
            payload.viewController?.present(picker, animated: true)
        }
    }

    deinit { EventBus.shared.reset(self) }
}
