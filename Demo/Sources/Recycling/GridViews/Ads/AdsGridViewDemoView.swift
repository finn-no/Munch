//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

/// For use with AdsGridView.
public class AdDataSource: NSObject {
    var models: [Ad] = {
        var ads = AdFactory.create(numberOfModels: 9)
        ads.insert(AdFactory.googleDemoAd, at: 4)
        ads.insert(AdFactory.nativeDemoAd, at: 8)
        return ads
    }()
}

public class AdsGridViewDemoView: UIView, Tweakable {

    lazy var tweakingOptions: [TweakingOption] = [
        TweakingOption(title: "Full width", action: { self.numberOfColumns = .fullWidth }),
        TweakingOption(title: "Two columns", action: { self.numberOfColumns = .columns(2) }),
        TweakingOption(title: "Three columns", action: { self.numberOfColumns = .columns(3) })
    ]

    private var numberOfColumns: AdsGridView.ColumnConfiguration = .columns(2) {
        didSet {
            adsGridView.collectionView.collectionViewLayout.invalidateLayout()
        }
    }

    private lazy var dataSource: AdDataSource = AdDataSource()

    private lazy var adsGridView: AdsGridView = {
        let view = AdsGridView(delegate: self, dataSource: self)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    private func setup() {
        addSubview(adsGridView)
        adsGridView.fillInSuperview()
    }
}

extension AdsGridViewDemoView: AdsGridViewDelegate {
    public func adsGridViewDidStartRefreshing(_ adsGridView: AdsGridView) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) { [weak adsGridView] in
            adsGridView?.reloadData()
        }
    }

    public func adsGridView(_ adsGridView: AdsGridView, didSelectItemAtIndex index: Int) {}

    public func adsGridView(_ adsGridView: AdsGridView, willDisplayItemAtIndex index: Int) {}

    public func adsGridView(_ adsGridView: AdsGridView, didScrollInScrollView scrollView: UIScrollView) {}

    public func adsGridView(_ adsGridView: AdsGridView, didSelectFavoriteButton button: UIButton, on cell: AdRecommendationCell, at index: Int) {
        dataSource.models[index].isFavorite.toggle()

        DispatchQueue.main.async {
            adsGridView.updateItem(at: index, isFavorite: self.dataSource.models[index].isFavorite)
        }
    }
}

extension AdsGridViewDemoView: AdsGridViewDataSource {
    public func numberOfColumns(inAdsGridView adsGridView: AdsGridView) -> AdsGridView.ColumnConfiguration {
        numberOfColumns
    }

    public func numberOfItems(inAdsGridView adsGridView: AdsGridView) -> Int {
        return dataSource.models.count
    }

    public func adsGridView(_ adsGridView: AdsGridView, cellClassesIn collectionView: UICollectionView) -> [UICollectionViewCell.Type] {
        return [
            AdsGridViewCell.self,
            BannerAdDemoCell.self,
            NativeAdvertRecommendationDemoCell.self,
        ]
    }

    public func adsGridView(_ adsGridView: AdsGridView, heightForItemWithWidth width: CGFloat, at indexPath: IndexPath) -> CGFloat {
        let model = dataSource.models[indexPath.item]

        switch model.adType {
        case .native:
            return NativeAdvertRecommendationDemoCell.height(for: width)
        case .google:
            return 300
        default:
            return AdsGridViewCell.height(
                for: model,
                width: width
            )
        }
    }

    public func adsGridView(_ adsGridView: AdsGridView, collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = dataSource.models[indexPath.item]

        switch model.adType {
        case .native:
            return collectionView.dequeue(NativeAdvertRecommendationDemoCell.self, for: indexPath)
        case .google:
            return collectionView.dequeue(BannerAdDemoCell.self, for: indexPath)

        default:
            let cell = collectionView.dequeue(AdsGridViewCell.self, for: indexPath)
            cell.imageDataSource = adsGridView
            cell.delegate = adsGridView
            cell.configure(with: model, atIndex: indexPath.item)
            cell.showImageDescriptionView = model.scaleImageToFillView
            return cell
        }
    }

    public func adsGridView(_ adsGridView: AdsGridView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        guard let url = URL(string: imagePath) else {
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            DispatchQueue.main.async {
                if let data = data, let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            }
        }

        task.resume()
    }

    public func adsGridView(_ adsGridView: AdsGridView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {}
}
