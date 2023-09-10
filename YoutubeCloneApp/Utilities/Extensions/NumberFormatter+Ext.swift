import UIKit

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
