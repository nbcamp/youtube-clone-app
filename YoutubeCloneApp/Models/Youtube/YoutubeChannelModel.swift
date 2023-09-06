struct YoutubeChannelModel: Codable {
    let id: String
    let snippet: YoutubeChannelSnippetModel
}

struct YoutubeChannelSnippetModel: Codable {
    let title: String
    let description: String
    var thumbnails: YoutubeThumbnailListModel
}
