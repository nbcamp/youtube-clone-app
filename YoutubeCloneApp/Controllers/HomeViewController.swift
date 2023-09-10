import UIKit

struct PushToDetailViewEvent: EventProtocol {
    struct Payload {
        let video: YoutubeVideo
    }

    let payload: Payload
}

struct LoadNewVideosEvent: EventProtocol {
    struct Payload {
        let completion: ([YoutubeVideo]) -> Void
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
        rootView.initialize()
        navigationController?.navigationBar.backgroundColor = .white
        navigationItem.titleView = {
            let titleView = UIImageView()
            titleView.image = .init(named: "Youtube Main")
            titleView.contentMode = .scaleAspectFit
            return titleView
        }()
    }

    private func setupEvents() {
        EventBus.shared.on(PushToDetailViewEvent.self, by: self) { listener, payload in
            let detailVC = DetailViewController()
            detailVC.video = payload.video
            listener.navigationController?.pushViewController(detailVC, animated: true)
        }

        EventBus.shared.on(LoadNewVideosEvent.self, by: self) { _, payload in
            YoutubeService.shared.loadVideos(
                completionHandler: payload.completion,
                errorHandler: { [weak self] error in
                    debugPrint(error)
                    self?.alertError(message: "Failed to load new videos.")
                }
            )
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
                message: "Fetch more videos failed."
            ))
        )
    }

    deinit { EventBus.shared.reset(self) }
}
