struct YoutubeChannelListResponseModel: Codable {
    let prevPageToken: String?
    let nextPageToken: String?
    let pageInfo: YoutubePageInfoModel
    let items: [YoutubeChannelModel]
}
