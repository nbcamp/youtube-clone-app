struct SignInEvent: EventProtocol {
    struct Payload {
        let email: String
        let password: String
    }

    let payload: Payload
}

struct SignUpEvent: EventProtocol {
    struct Payload {
        let name: String
        let avatar: Base64
        let email: String
        let password: String
    }

    let payload: Payload
}

struct SignUpEvent: EventProtocol {
    struct Payload {
        let name: String
        let avatar: Base64
        let email: String
        let password: String
    }

    let payload: Payload
}

struct PushToDetailViewEvent: EventProtocol {
    let payload: Void = ()
}

//새로고침 이벤트 등록
struct CollectionViewRefresh: EventProtocol {
    let payload: Void = ()
}
