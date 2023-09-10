import UIKit

struct PushToDetailViewEvent: EventProtocol {
    let payload: Void = ()
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupEvents()
        rootView.initialize()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        EventBus.shared.reset(self)
    }

    private func setupEvents() {
        EventBus.shared.on(PushToDetailViewEvent.self, by: self) { listener, _ in
            listener.navigationController?.pushViewController(DetailViewController(), animated: true)
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
                message: "Fetch more videos failed."
            ))
        )
    }
}
