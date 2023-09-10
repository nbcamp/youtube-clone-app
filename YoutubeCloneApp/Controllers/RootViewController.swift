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

struct AlertErrorEvent: EventProtocol {
    struct Payload {
        weak var viewController: UIViewController?
        let message: String
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

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        let paddingTop: CGFloat = 10.0
        tabBar.frame = .init(
            x: tabBar.frame.origin.x,
            y: tabBar.frame.origin.y - paddingTop,
            width: tabBar.frame.width,
            height: tabBar.frame.height + paddingTop
        )
    }

    private func initializeTabBarController() {
        let tabs: [(UIViewController.Type, String)] = [
            (HomeViewController.self, "house"),
            (ProfileViewController.self, "person"),
        ]
        tabBar.tintColor = .primary
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
            listener.photoPicker = PhotoPicker { [weak listener] images in
                payload.completion(images)
                listener?.photoPicker = nil
            }
            picker.delegate = listener.photoPicker
            payload.viewController?.present(picker, animated: true)
        }

        EventBus.shared.on(AlertErrorEvent.self, by: self) { _, payload in
            let alert = UIAlertController(title: "Error", message: payload.message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            payload.viewController?.present(alert, animated: true)
        }
    }

    deinit { EventBus.shared.reset(self) }
}
