import UIKit

final class HomeView: UIView, RootView {
    var videos: [YoutubeVideo] = []

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
        EventBus.shared.emit(RefreshVideosEvent(payload: .init(completion: { [weak self] videos in
            guard let self else { return }
            DispatchQueue.main.async {
                self.videos = videos
                self.videoCollectionView.reloadData()
                self.refreshControl.endRefreshing()
            }
        })))
    }

    func initializeUI() {
        backgroundColor = .systemBackground
        addSubview(videoCollectionView)
        addSubview(loadingIndicator)

        let guide = safeAreaLayoutGuide
        videoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            videoCollectionView.topAnchor.constraint(equalTo: guide.topAnchor),
            videoCollectionView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            videoCollectionView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            videoCollectionView.bottomAnchor.constraint(equalTo: guide.bottomAnchor),

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
    }

    func initialize() {
        EventBus.shared.emit(LoadNewVideosEvent(payload: .init(completion: { [weak self] videos in
            guard let self else { return }
            self.videos = videos
            let indexPathsToInsert = (0 ..< videos.count).map { IndexPath(item: $0, section: 0) }
            DispatchQueue.main.async {
                self.videoCollectionView.performBatchUpdates {
                    self.videoCollectionView.insertItems(at: indexPathsToInsert)
                }
            }
        })))
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
        let video = videos[indexPath.item]
        EventBus.shared.emit(PushToDetailViewEvent(payload: .init(video: video)))
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let distanceFromBottom = contentHeight - offsetY

        if distanceFromBottom < scrollView.frame.size.height + 300 {
            EventBus.shared.emit(LoadMoreVideosEvent(payload: .init(completion: { [weak self] videos in
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
            })))
        }
    }
}

extension HomeView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        return CGSize(width: width, height: width * 9 / 16 + 80)
    }
}
