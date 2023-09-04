import UIKit

final class RootViewController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTabBarController()
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
}
