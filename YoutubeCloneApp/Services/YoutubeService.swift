import Foundation

final class YoutubeService {
    static let shared: YoutubeService = .init()
    private init() {}

    @Publishable private(set) var videos: [YoutubeVideo] = []
    @Publishable private(set) var loading = false
    @Publishable private(set) var refreshing = false
    @Publishable private(set) var completed = true
    @Publishable private(set) var loadingMore = false

    private var initialized = false
    private var nextPageToken: String? {
        didSet { completed = nextPageToken == nil && !videos.isEmpty }
    }

    private var BASE_URL = "https://www.googleapis.com/youtube/v3"
    private var API_KEY: String = Env.YoutubeApiKey

    func loadVideos(
        completionHandler: (([YoutubeVideo]) -> Void)? = nil,
        errorHandler: ((APIError) -> Void)? = nil
    ) {
        Task {
            loading = true
            await _loadVideos(
                completionHandler: completionHandler,
                errorHandler: errorHandler
            )
            loading = false
            initialized = true
        }
    }

    func refreshVideos(
        completionHandler: (([YoutubeVideo]) -> Void)? = nil,
        errorHandler: ((APIError) -> Void)? = nil
    ) {
        guard initialized, !refreshing else { return }
        Task {
            refreshing = true
            await _loadVideos(
                completionHandler: completionHandler,
                errorHandler: errorHandler
            )
            refreshing = false
        }
    }

    func loadMoreVideos(
        completionHandler: (([YoutubeVideo]) -> Void)? = nil,
        errorHandler: ((APIError) -> Void)? = nil
    ) {
        guard initialized, !loadingMore, !completed else { return }
        Task {
            loadingMore = true
            await _loadVideos(
                next: true,
                completionHandler: completionHandler,
                errorHandler: errorHandler
            )
            loadingMore = false
        }
    }

    private func _loadVideos(
        next: Bool = false,
        completionHandler: (([YoutubeVideo]) -> Void)? = nil,
        errorHandler: ((APIError) -> Void)? = nil
    ) async {
        var queryItems: [URLQueryItem] = [
            .init(name: "key", value: API_KEY),
            .init(name: "part", value: "snippet"),
            .init(name: "chart", value: "mostPopular"),
        ]

        if next, let nextPageToken {
            queryItems.append(.init(name: "pageToken", value: nextPageToken))
        }

        let videoListResult = await APIService.shared.fetch(
            url: "\(BASE_URL)/videos",
            model: YoutubeVideoListResponseModel.self,
            queryItems: queryItems
        )

        if case let .failure(error) = videoListResult { errorHandler?(error); return }
        guard case let .success(videoList) = videoListResult else { return }

        let channelListResult = await APIService.shared.fetch(
            url: "\(BASE_URL)/channels",
            model: YoutubeChannelListResponseModel.self,
            queryItems: [
                .init(name: "key", value: API_KEY),
                .init(name: "part", value: "snippet"),
                .init(
                    name: "id",
                    value: videoList.items
                        .map { $0.snippet.channelId }
                        .joined(separator: ",")
                ),
            ]
        )

        if case let .failure(error) = channelListResult { errorHandler?(error); return }
        guard case let .success(channelList) = channelListResult else { return }

        let channelMap = channelList.items.reduce(into: [:]) {
            $0.updateValue($1.snippet, forKey: $1.id)
        }

        let videos: [YoutubeVideo] = videoList.items.map {
            let channel = channelMap[$0.snippet.channelId]

            let thumbnail = $0.snippet.thumbnails
            let videoThumbnail = YoutubeVideo.Thumbnail(
                url: thumbnail.maxres?.url ?? thumbnail.standard?.url ?? "",
                width: thumbnail.maxres?.width ?? thumbnail.standard?.width ?? 0,
                height: thumbnail.maxres?.height ?? thumbnail.standard?.height ?? 0
            )

            let channelThumbnail = YoutubeVideo.Thumbnail(
                url: channel?.thumbnails.medium?.url ?? "",
                width: channel?.thumbnails.medium?.width ?? 0,
                height: channel?.thumbnails.medium?.height ?? 0
            )

            return .init(
                id: $0.id,
                title: $0.snippet.title,
                description: $0.snippet.description,
                publishedAt: $0.snippet.publishedAt,
                thumbnail: videoThumbnail,
                channel: .init(
                    name: channel?.title ?? "Untitled",
                    description: channel?.description ?? "",
                    thumbnail: channelThumbnail
                )
            )
        }

        try? await Task.sleep(nanoseconds: .init(Int.random(in: 100 ... 500) * 1_000_000))

        if next {
            self.videos.append(contentsOf: videos)
        } else {
            self.videos = videos
        }

        completionHandler?(videos)

        nextPageToken = videoList.nextPageToken
    }
}
