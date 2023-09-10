import Foundation

enum RegexPattern: String {
    case email = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

    /// 영문자 최소 하나 이상
    /// 숫자 최소 하나 이상
    /// 최소 6글자 이상
    case password = "(?=.*[A-Za-z])(?=.*[0-9]).{6,}" 
}

extension String {
    func test(pattern: String) -> Bool {
        let test = NSPredicate(format: "SELF MATCHES %@", pattern)
        return test.evaluate(with: self)
    }

    func test(pattern: RegexPattern) -> Bool {
        return test(pattern: pattern.rawValue)
    }
}
