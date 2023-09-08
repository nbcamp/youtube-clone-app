import UIKit

extension UIViewController {
    var name: String { String(describing: type(of: self)) }
}

typealias Base64 = String

extension UIImage {
    var base64: Base64? { pngData()?.base64EncodedString() }

    convenience init?(base64: Base64) {
        guard let data = Data(base64Encoded: base64) else { return nil }
        self.init(data: data)
    }
}

struct RGBA: Codable {
    var red: CGFloat
    var green: CGFloat
    var blue: CGFloat
    var alpha: CGFloat
}

struct HSBA: Codable {
    var hue: CGFloat
    var saturation: CGFloat
    var brightness: CGFloat
    var alpha: CGFloat
}

extension UIColor {
    var rgba: RGBA? {
        var color: RGBA = .init(red: 0, green: 0, blue: 0, alpha: 0)
        return getRed(&color.red, green: &color.green, blue: &color.blue, alpha: &color.alpha) ? color : nil
    }

    convenience init(rgba: RGBA) {
        self.init(red: rgba.red, green: rgba.green, blue: rgba.blue, alpha: rgba.alpha)
    }

    var hsba: HSBA? {
        var color: HSBA = .init(hue: 0, saturation: 0, brightness: 0, alpha: 0)
        return getHue(&color.hue, saturation: &color.saturation, brightness: &color.brightness, alpha: &color.alpha) ? color : nil
    }

    convenience init(hsba: HSBA) {
        self.init(hue: hsba.hue, saturation: hsba.saturation, brightness: hsba.brightness, alpha: hsba.alpha)
    }
}

extension UIResponder {
    private weak static var _currentFirstResponder: UIResponder?

    static var currentFirstResponder: UIResponder? {
        _currentFirstResponder = nil
        UIApplication.shared.sendAction(#selector(findFirstResponder(sender:)), to: nil, from: nil, for: nil)
        return _currentFirstResponder
    }

    @objc private func findFirstResponder(sender: Any) {
        UIResponder._currentFirstResponder = self
    }
}

extension UIImageView {
    func load(url: URL, completion: ((UIImage?) -> Void)? = nil) {
        DispatchQueue.global().async { [weak self] in
            guard let data = try? Data(contentsOf: url) else { completion?(nil); return }
            guard let image = UIImage(data: data) else { completion?(nil); return }
            DispatchQueue.main.async {
                self?.image = image
                completion?(image)
            }
        }
    }
}

extension NumberFormatter {
    func viewCount(views: Int) -> String {
        let viewCountFormatter = NumberFormatter()
        
        switch views {
        case 1..<1000:
            viewCountFormatter.maximumFractionDigits = 0
            return "조회수 \(viewCountFormatter.string(from: NSNumber(value: Double(views)))!)회﹒"
        case 1000..<10000:
            viewCountFormatter.maximumFractionDigits = 1
            return "조회수 \(viewCountFormatter.string(from: NSNumber(value: Double(views) / 1000))!)천회﹒"
        case 10000..<100000000:
            viewCountFormatter.maximumFractionDigits = 0
            return "조회수 \(viewCountFormatter.string(from: NSNumber(value: Double(views) / 10000))!)만회﹒"
        default:
            viewCountFormatter.maximumFractionDigits = 1
            return "조회수 \(viewCountFormatter.string(from: NSNumber(value: Double(views) / 100000000))!)억회﹒"
        }
    }
}

extension DateFormatter {
    func uploadDate(uploadDateString: String) -> String {
        let uploadDateFormatter = ISO8601DateFormatter()
        
        guard let uploadDate = uploadDateFormatter.date(from: uploadDateString) else {
            return "error"
        }
        
        let calendar = Calendar.current
        let currentDate = Date()
        
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: uploadDate, to: currentDate)
        
        if let years = components.year, years > 0 {
            return "\(years)년 전"
        } else if let months = components.month, months > 0 {
            return "\(months)달 전"
        } else if let days = components.day, days > 0 {
            return "\(days)일 전"
        } else if let hours = components.hour, hours > 0 {
            return "\(hours)시간 전"
        } else if let minutes = components.minute, minutes > 0 {
            return "\(minutes)분 전"
        } else {
            return "방금 전"
        }
    }
}
