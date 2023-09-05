final class YoutubeService {
    static let shared: YoutubeService = .init()
    private init() {}

    private(set) var videos: [YoutubeVideo] = []
    private(set) var loading = false

    private var nextPageToken: String?

    func loadVideos(errorHandler: @escaping (Error) -> Void) {
        Task {
            loading = true
            let videoListResult = await APIService.shared.fetch(
                url: "/videos",
                model: YoutubeVideoListResponseModel.self,
                queryItems: [
                    .init(name: "part", value: "snippet"),
                    .init(name: "chart", value: "mostPopular")
                ]
            )

            guard case let .success(videoList) = videoListResult else {
                errorHandler(videoListResult.mapError { $0 } as! Error)
                loading = false
                return
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
                errorHandler(videoListResult.mapError { $0 } as! Error)
                loading = false
                return
            }

            let channelMap: [String: YoutubeChannelSnippetModel] = channelList.items.reduce([:]) { partialResult, channel in
                var copied = partialResult
                copied.updateValue(channel.snippet, forKey: channel.id)
                return copied
            }

            videos = videoList.items.map {
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
            print(videos)

            nextPageToken = videoList.nextPageToken
            loading = false
        }
    }
}
