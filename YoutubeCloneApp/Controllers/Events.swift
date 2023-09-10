struct PushToDetailViewEvent: EventProtocol {
    let payload: Void = ()
}

//새로고침 이벤트 등록
struct RefreshVideos: EventProtocol {
    let payload: Void = ()
}
