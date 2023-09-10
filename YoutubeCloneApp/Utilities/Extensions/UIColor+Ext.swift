import UIKit

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

extension UIColor {
    static let primary = UIColor(named: "YoutubeRed")
    static let secondary = UIColor(named: "AlmostBlack")
}
