import Foundation

final class YoutubeService {
    static let shared: YoutubeService = .init()
    private init() {}

    @Publishable private(set) var videos: [YoutubeVideo] = []
    @Publishable private(set) var loading = false
    @Publishable private(set) var refreshing = false
    @Publishable private(set) var completed = false

    private var initialized = false
    private var nextPageToken: String? {
        didSet { completed = nextPageToken == nil && !videos.isEmpty }
    }

    func loadVideos(errorHandler: @escaping (Error) -> Void) {
        Task {
            loading = true
            await _loadVideos(errorHandler: errorHandler)
            loading = false
            initialized = true
        }
    }

    func refreshVideos(errorHandler: @escaping (Error) -> Void) {
        guard initialized else { return }
        Task {
            refreshing = true
            await _loadVideos(errorHandler: errorHandler)
            refreshing = false
        }
    }

    func loadMoreVideos(errorHandler: @escaping (Error) -> Void) {
        Task {
            await _loadVideos(next: true, errorHandler: errorHandler)
        }
    }

    private func _loadVideos(
        next: Bool = false,
        errorHandler: @escaping (Error) -> Void
    ) async {
        Task {
            var queryItems: [URLQueryItem] = [
                .init(name: "part", value: "snippet"),
                .init(name: "chart", value: "mostPopular")
            ]

            if next, let nextPageToken {
                queryItems.append(.init(name: "pageToken", value: nextPageToken))
            }

            let videoListResult = await APIService.shared.fetch(
                url: "/videos",
                model: YoutubeVideoListResponseModel.self,
                queryItems: queryItems
            )

            guard case let .success(videoList) = videoListResult else {
                return errorHandler(videoListResult.mapError { $0 } as! Error)
            }

            let channelListResult = await APIService.shared.fetch(
                url: "/channels",
                model: YoutubeChannelListResponseModel.self,
                queryItems: [
                    .init(name: "part", value: "snippet"),
                    .init(
                        name: "id",
                        value: videoList.items
                            .map { $0.snippet.channelId }
                            .joined(separator: ",")
                    )
                ]
            )

            guard case let .success(channelList) = channelListResult else {
                return errorHandler(videoListResult.mapError { $0 } as! Error)
            }

            let channelMap: [String: YoutubeChannelSnippetModel] = channelList.items.reduce([:]) { partialResult, channel in
                var copied = partialResult
                copied.updateValue(channel.snippet, forKey: channel.id)
                return copied
            }

            let videos: [YoutubeVideo] = videoList.items.map {
                let channel = channelMap[$0.snippet.channelId]

                let videoThumbnail = YoutubeVideo.Thumbnail(
                    url: $0.snippet.thumbnails.standard?.url ?? "",
                    width: $0.snippet.thumbnails.standard?.width ?? 0,
                    height: $0.snippet.thumbnails.standard?.height ?? 0
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

            if next {
                self.videos.append(contentsOf: videos)
            } else {
                self.videos = videos
            }

            nextPageToken = videoList.nextPageToken
        }
    }
}
