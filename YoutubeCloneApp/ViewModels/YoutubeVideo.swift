final class YoutubeVideo {
    struct Thumbnail {
        let url: String
        let width: Int
        let height: Int
    }
    
    struct Channel {
        let name: String
        let description: String
        let thumbnail: Thumbnail
    }

    var id: String
    var title: String
    var description: String
    var publishedAt: String
    var thumbnail: Thumbnail
    var channel: Channel

    var url: String { "https://www.youtube.com/watch?v=\(id)" }

    init(
        id: String,
        title: String,
        description: String,
        publishedAt: String,
        thumbnail: Thumbnail,
        channel: Channel
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.publishedAt = publishedAt
        self.thumbnail = thumbnail
        self.channel = channel
    }
}
