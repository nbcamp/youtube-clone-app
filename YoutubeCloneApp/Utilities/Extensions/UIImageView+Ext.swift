import UIKit

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

