struct YoutubeVideoModel: Codable {
    let id: String
    let snippet: YoutubeVideoSnippetModel
}

struct YoutubeVideoSnippetModel: Codable {
    let title: String
    let description: String
    let channelId: String
    let publishedAt: String
    var thumbnails: YoutubeVideoThumbnailListModel
}

struct YoutubeVideoThumbnailListModel: Codable {
    let medium: YoutubeVideoThumbnailModel?
    let high: YoutubeVideoThumbnailModel?
    let standard: YoutubeVideoThumbnailModel?
    let maxres: YoutubeVideoThumbnailModel?
}
