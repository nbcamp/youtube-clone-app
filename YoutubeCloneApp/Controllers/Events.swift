struct SignInEvent: EventProtocol {
    struct Payload {
        var email: String
        var password: String
    }

    var payload: Payload
}
