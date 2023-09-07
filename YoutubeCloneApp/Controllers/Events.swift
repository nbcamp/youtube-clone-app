struct SignInEvent: EventProtocol {
    struct Payload {
        let email: String
        let password: String
    }

    let payload: Payload
}
struct CloseDetailViewEvent: EventProtocol {
    let payload: Void = ()
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
