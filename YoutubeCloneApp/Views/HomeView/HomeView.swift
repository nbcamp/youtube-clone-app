import UIKit

final class HomeView: UIView, RootView {
    private var videos: [YoutubeVideo] = []

    private lazy var videoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let videoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        videoCollectionView.backgroundColor = .systemBackground
        videoCollectionView.register(HomeVideoCell.self, forCellWithReuseIdentifier: HomeVideoCell.identifier)
        videoCollectionView.delegate = self
        videoCollectionView.dataSource = self
        videoCollectionView.refreshControl = refreshControl
        return videoCollectionView
    }()

    private lazy var refreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
        return refreshControl
    }()

    private lazy var loadingIndicator = {
        let loadingIndicator = UIActivityIndicatorView()
        loadingIndicator.style = .large
        loadingIndicator.hidesWhenStopped = true
        return loadingIndicator
    }()

    @objc private func refreshCollectionView() {
        refreshControl.endRefreshing()
//        YoutubeService.shared.refreshVideos { _ in
//            EventBus.shared.emit(
//                AlertErrorEvent(payload: .init(
//                    message: "Refresh videos failed."
//                ))
//            )
//        }
    }

    func initializeUI() {
        backgroundColor = .systemBackground
        addSubview(videoCollectionView)
        addSubview(loadingIndicator)

        let guide = safeAreaLayoutGuide
        videoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            videoCollectionView.topAnchor.constraint(equalTo: topAnchor),
            videoCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            videoCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            videoCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor),

            loadingIndicator.topAnchor.constraint(equalTo: guide.topAnchor),
            loadingIndicator.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            loadingIndicator.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            loadingIndicator.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
        ])

        YoutubeService.shared.$loading.subscribe(by: self, immediate: true) { subscriber, changes in
            DispatchQueue.main.async {
                if changes.new {
                    subscriber.loadingIndicator.startAnimating()
                } else {
                    subscriber.loadingIndicator.stopAnimating()
                }
            }
        }

        YoutubeService.shared.loadVideos { [weak self] videos in
            guard let self else { return }
            self.videos = videos
            let indexPathsToInsert = (0 ..< videos.count).map { IndexPath(item: $0, section: 0) }
            DispatchQueue.main.async {
                self.videoCollectionView.performBatchUpdates {
                    self.videoCollectionView.insertItems(at: indexPathsToInsert)
                }
            }
        } errorHandler: { _ in
            EventBus.shared.emit(
                AlertErrorEvent(payload: .init(
                    message: "Load videos failed."
                ))
            )
        }
    }
}

extension HomeView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return videos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeVideoCell.identifier, for: indexPath) as! HomeVideoCell
        cell.configure(video: videos[indexPath.item])
        return cell
    }
}

extension HomeView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        EventBus.shared.emit(PushToDetailViewEvent())
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let distanceFromBottom = contentHeight - offsetY

        if distanceFromBottom < scrollView.frame.size.height + 300 {
            YoutubeService.shared.loadMoreVideos { [weak self] videos in
                guard let self else { return }
                
                let startIndex = self.videos.count
                let endIndex = startIndex + videos.count
                let indexPathsToInsert = (self.videos.count ..< endIndex).map { IndexPath(item: $0, section: 0) }
                self.videos.append(contentsOf: videos)

                DispatchQueue.main.async {
                    self.videoCollectionView.performBatchUpdates {
                        self.videoCollectionView.insertItems(at: indexPathsToInsert)
                    }
                }

            } errorHandler: { error in
                debugPrint(error)
                EventBus.shared.emit(
                    AlertErrorEvent(payload: .init(
                        message: "Fetch more videos failed."
                    ))
                )
            }
        }
    }
}

extension HomeView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        return CGSize(width: width, height: width * 9 / 16 + 100)
    }
}
