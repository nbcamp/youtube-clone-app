import UIKit

final class HomeView: UIView, RootView {
    weak var user: User? {
        didSet { observeUserChanged(user: user) }
    }
    
    //새로고침
    let refreshControl = UIRefreshControl()
    
    //더미데이터 - 삭제예정
    let imageList = [UIImage(systemName: "photo"), UIImage(systemName: "photo.fill"), UIImage(named: "one"), UIImage(named: "one"), UIImage(named: "one"), UIImage(named: "one")]
    let iconList = [UIImage(systemName: "sun.max.circle"), UIImage(systemName: "globe.europe.africa.fill"), UIImage(named: "icon"), UIImage(named: "icon"), UIImage(named: "icon"), UIImage(named: "icon")]
    let titleList = ["Header Laber 1Header Laber 1Header Laber 1Header Laber 1Header Laber 1Header Laber 1Header Laber 1", "Header Laber 2", "Header Laber 3", "Header Laber 4", "Header Laber 5", "Header Laber 6"]
    let channelList = ["무한도전", "오분순삭", "무비띵크_Movie Think", "개발하는 정대리", "김종국 GYM JONG KOOK", "ITSub잇섭"]
    let countList = ["조회수 2000만회", "조회수 70만회", "조회수 1만회", "조회수 4000회", "조회수 999회", "조회수 300만회",]
    let dateList = ["1일 전", "10년 전", "7시간 전", "8개월 전", "1일 전", "10시간 전", ]
    
    //home화면에 노출될 비디오 리스트 CollectionView
    private lazy var videoCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let videoCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        videoCollectionView.backgroundColor = .systemBackground
        videoCollectionView.translatesAutoresizingMaskIntoConstraints = false
        return videoCollectionView
    }()
    
    //collectionView 속성
    func configureCollectionView() {
        videoCollectionView.register(HomeVideoCell.self, forCellWithReuseIdentifier: HomeVideoCell.identifier)
        videoCollectionView.delegate = self
        videoCollectionView.dataSource = self
        
        videoCollectionView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
        refreshControl.attributedTitle = NSAttributedString(string: "잠시만요",
                                                         attributes: [NSAttributedString.Key.foregroundColor: UIColor.systemGray, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)])
        videoCollectionView.reloadData()
    }
    
    //새로고침 동작
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
            videoCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func observeUserChanged(user: User?) {
        guard let user else { return }
        user.$name.subscribe(by: self, immediate: true) { (subscriber, changes) in
//            subscriber.label.text = changes.new
        }
    }
}

//collectionView extension
extension HomeView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeVideoCell", for: indexPath) as? HomeVideoCell else {
            return UICollectionViewCell()
        }
        
        cell.thumbnailImage.image = imageList[indexPath.row]
        cell.channelIconImage.image = iconList[indexPath.row]
        cell.titleLabel.text = titleList[indexPath.row]
        cell.channelNameLabel.text = channelList[indexPath.row]
        cell.viewCountLabel.text = countList[indexPath.row]
        cell.uploadDateLabel.text = dateList[indexPath.row]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        print(collectionView.bounds.width)
        return CGSize(width: (collectionView.bounds.width), height: 280)
    }
    
    //셀 간격
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    //이벤트 사용
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        EventBus.shared.emit(PushToDetailViewEvent())
    }
}
