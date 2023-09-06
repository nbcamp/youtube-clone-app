struct YoutubeVideoListResponseModel: Codable {
    let prevPageToken: String?
    let nextPageToken: String?
    let pageInfo: YoutubePageInfoModel
    let items: [YoutubeVideoModel]
}
