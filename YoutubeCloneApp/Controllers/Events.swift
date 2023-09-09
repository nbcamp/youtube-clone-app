struct SignInEvent: EventProtocol {
    struct Payload {
        let email: String
        let password: String
    }

    let payload: Payload
}

struct SignUpEvent: EventProtocol {
    let payload: Void = ()
}
