import UIKit

struct PushToDetailViewEvent: EventProtocol {
    struct Payload {
        let video: YoutubeVideo
    }

    let payload: Payload
}

struct RefreshVideosEvent: EventProtocol {
    struct Payload {
        let completion: ([YoutubeVideo]) -> Void
    }

    let payload: Payload
}

struct LoadMoreVideosEvent: EventProtocol {
    struct Payload {
        let completion: ([YoutubeVideo]) -> Void
    }

    let payload: Payload
}

final class HomeViewController: TypedViewController<HomeView> {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupEvents()

        navigationItem.titleView = {
            let titleView = UIImageView()
            titleView.image = .init(named: "Youtube Logo")
            titleView.contentMode = .scaleAspectFit
            return titleView
        }()

        AuthService.shared.$user.subscribe(by: self, immediate: true) { subscriber, changes in
            guard changes.new != nil else { return }
            AuthService.shared.$user.unsubscribe(by: subscriber)
            YoutubeService.shared.loadVideos(
                completionHandler: { [weak subscriber] videos in
                    DispatchQueue.main.async { subscriber?.rootView.configure(videos: videos) }
                },
                errorHandler: { [weak subscriber] error in
                    debugPrint(error)
                    subscriber?.alertError(message: "Failed to load new videos.")
                }
            )
        }
    }

    private func setupEvents() {
        EventBus.shared.on(PushToDetailViewEvent.self, by: self) { listener, payload in
            let detailVC = DetailViewController()
            detailVC.video = payload.video
            detailVC.modalPresentationStyle = .custom
            detailVC.isModalInPresentation = false
            listener.present(detailVC, animated: true)
        }

        EventBus.shared.on(RefreshVideosEvent.self, by: self) { _, payload in
            YoutubeService.shared.refreshVideos(
                completionHandler: payload.completion,
                errorHandler: { [weak self] error in
                    debugPrint(error)
                    self?.alertError(message: "Failed to refresh videos.")
                }
            )
        }

        EventBus.shared.on(LoadMoreVideosEvent.self, by: self) { _, payload in
            YoutubeService.shared.loadMoreVideos(
                completionHandler: payload.completion,
                errorHandler: { [weak self] error in
                    debugPrint(error)
                    self?.alertError(message: "Failed to fetch more videos.")
                }
            )
        }
    }

    private func alertError(message: String) {
        EventBus.shared.emit(
            AlertErrorEvent(payload: .init(
                viewController: self,
                message: message
            ))
        )
    }

    deinit { EventBus.shared.reset(self) }
}
