import UIKit

final class AvatarView: UIView {
    var size: CGFloat {
        didSet { configureUI() }
    }
    
    var image: UIImage? {
        get { imageView.image }
        set {
            imageView.image = newValue
            imageView.transform = .init(scaleX: 1.5, y: 1.5)
        }
    }
    
    private lazy var imageView = {
       let imageView = UIImageView()
        imageView.transform = .init(scaleX: 0.4, y: 0.4)
        imageView.contentMode = .scaleAspectFit
        imageView.image = .init(systemName: "photo")
        imageView.tintColor = .primary
        return imageView
    }()

    init(size: CGFloat) {
        self.size = size
        super.init(frame: .zero)
        layer.masksToBounds = true
        layer.borderWidth = 2.0
        layer.borderColor = UIColor.primary?.cgColor
        translatesAutoresizingMaskIntoConstraints = false
        configureUI()

        addSubview(imageView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.widthAnchor.constraint(equalTo: widthAnchor),
            imageView.heightAnchor.constraint(equalTo: heightAnchor),
        ])
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI() {
        bounds.size = .init(width: size, height: size)
        layer.cornerRadius = size / 2
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: size),
            widthAnchor.constraint(equalTo: heightAnchor),
        ])
    }
}
