import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = .init(windowScene: windowScene)
        window?.makeKeyAndVisible()

        let apiKey = (Bundle.main.object(forInfoDictionaryKey: "Secrets") as? [String: String])?["YOUTUBE_API_KEY"] ?? ""
        APIService.config.baseUrl = "https://www.googleapis.com/youtube/v3"
        APIService.config.queryItems = [.init(name: "key", value: apiKey)]

        AuthService.shared.storage = UserDefaultsStorage.shared
        window?.rootViewController = RootViewController()
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}
}
