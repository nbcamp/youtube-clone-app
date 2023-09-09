import UIKit

final class HomeView: UIView, RootView {
    weak var user: User? {
        didSet { observeUserChanged(user: user) }
    }
    
    private let refreshControl = UIRefreshControl()
    
    private lazy var videoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let videoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        videoCollectionView.backgroundColor = .systemBackground
        videoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        return videoCollectionView
    }()
    
    private func configureCollectionView() {
        videoCollectionView.register(HomeVideoCell.self, forCellWithReuseIdentifier: HomeVideoCell.identifier)
        videoCollectionView.delegate = self
        videoCollectionView.dataSource = self
        
        videoCollectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "잠시만요",
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray,
                                                                      NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)])
    }
    
    @objc func refreshCollectionView() {
        refreshControl.endRefreshing()
    }

    func initializeUI() {
        backgroundColor = .systemBackground
        addSubview(videoCollectionView)
        
        configureCollectionView()
        
        NSLayoutConstraint.activate([
            videoCollectionView.topAnchor.constraint(equalTo: topAnchor),
            videoCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            videoCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            videoCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        YoutubeService.shared.$videos.subscribe(by: self) { (subscriber, changes) in
            DispatchQueue.main.async {
                subscriber.videoCollectionView.reloadData()
            }
        }
        
        YoutubeService.shared.loadVideos { error in
            print("Error loading videos: \(error)")
        }
    }
    
    private func observeUserChanged(user: User?) {
        guard let user else { return }
        user.$name.subscribe(by: self, immediate: true) { (subscriber, changes) in
        }
    }
}

extension HomeView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return YoutubeService.shared.videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeVideoCell.identifier, for: indexPath) as! HomeVideoCell
        
        let video = YoutubeService.shared.videos[indexPath.item]
        cell.configure(video: video)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.bounds.width), height: 280)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        EventBus.shared.emit(PushToDetailViewEvent())
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let lastItem = YoutubeService.shared.videos.count - 1
        if indexPath.item == lastItem {
            YoutubeService.shared.loadMoreVideos { error in
                if error != nil {
                    print("Error loading more videos: \(error)")
                } else {
                    DispatchQueue.main.async {
                        collectionView.reloadData()
                    }
                }
            }
        }
    }
    
    
}
