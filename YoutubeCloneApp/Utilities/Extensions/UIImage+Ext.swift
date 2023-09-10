import UIKit

typealias Base64 = String

extension UIImage {
    var base64: Base64? { pngData()?.base64EncodedString() }

    convenience init?(base64: Base64) {
        guard let data = Data(base64Encoded: base64) else { return nil }
        self.init(data: data)
    }
}
