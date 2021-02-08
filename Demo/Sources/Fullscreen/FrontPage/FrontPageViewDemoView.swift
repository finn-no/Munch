//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import FinniversKit

public class FrontpageViewDemoView: UIView {
    private let markets = Market.allMarkets
    private var didSetupView = false
    private var visibleItems = 20

    private let ads: [Ad] = {
        var ads = AdFactory.create(numberOfModels: 120)
        ads.insert(AdFactory.googleDemoAd, at: 4)
        return ads
    }()

    private lazy var frontPageView: FrontPageView = {
        let view = FrontPageView(delegate: self, adRecommendationsGridViewDataSource: self)
        view.model = FrontpageViewDefaultData()
        view.isRefreshEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // MARK: - Setup

    public override func layoutSubviews() {
        super.layoutSubviews()

        if didSetupView == false {
            setup()
            didSetupView = true
        }
    }

    private func setup() {
        addSubview(frontPageView)
        frontPageView.fillInSuperview()
        frontPageView.reloadData()
    }
}

// MARK: - AdsGridViewDelegate

extension FrontpageViewDemoView: FrontPageViewDelegate {
    public func frontPageViewDidSelectRetryButton(_ frontPageView: FrontPageView) {
        frontPageView.reloadData()
    }
}

extension FrontpageViewDemoView: AdsGridViewDelegate {
    public func adsGridView(_ adsGridView: AdRecommendationsGridView, willDisplayItemAtIndex index: Int) {
        if index >= visibleItems - 10 {
            visibleItems += 10

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
                self?.frontPageView.reloadAds()
            })
        }
    }

    public func adsGridView(_ adsGridView: AdRecommendationsGridView, didScrollInScrollView scrollView: UIScrollView) {}
    public func adsGridView(_ adsGridView: AdRecommendationsGridView, didSelectItemAtIndex index: Int) {}

    public func adsGridViewDidStartRefreshing(_ adsGridView: AdRecommendationsGridView) {
        frontPageView.reloadData()
    }

    public func adsGridView(_ adsGridView: AdRecommendationsGridView, didSelectFavoriteButton button: UIButton, on cell: AdRecommendationCell, at index: Int) {
        adsGridView.updateItem(at: index, isFavorite: !cell.isFavorite)
    }
}

// MARK: - AdsGridViewDataSource

extension FrontpageViewDemoView: AdsGridViewDataSource {
    public func numberOfColumns(inAdsGridView adsGridView: AdRecommendationsGridView) -> AdRecommendationsGridView.ColumnConfiguration? {
        return nil
    }

    public func numberOfItems(inAdsGridView adsGridView: AdRecommendationsGridView) -> Int {
        return min(ads.count, visibleItems)
    }

    public func adsGridView(_ adsGridView: AdRecommendationsGridView, cellClassesIn collectionView: UICollectionView) -> [UICollectionViewCell.Type] {
        return [
            StandardAdRecommendationCell.self,
            BannerAdDemoCell.self
        ]
    }

    public func adsGridView(_ adsGridView: AdRecommendationsGridView, heightForItemWithWidth width: CGFloat, at indexPath: IndexPath) -> CGFloat {
        let model = ads[indexPath.item]

        switch model.adType {
        case .google:
            return 300
        default:
            return StandardAdRecommendationCell.height(
                for: model,
                width: width
            )
        }
    }

    public func adsGridView(_ adsGridView: AdRecommendationsGridView, collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = ads[indexPath.item]

        switch model.adType {
        case .google:
            return collectionView.dequeue(BannerAdDemoCell.self, for: indexPath)

        default:
            let cell = collectionView.dequeue(StandardAdRecommendationCell.self, for: indexPath)
            cell.imageDataSource = adsGridView
            cell.delegate = adsGridView
            cell.configure(with: model, atIndex: indexPath.item)
            return cell
        }
    }

    public func adsGridView(_ adsGridView: AdRecommendationsGridView, loadImageWithPath imagePath: String, imageWidth: CGFloat, completion: @escaping ((UIImage?) -> Void)) {
        guard let url = URL(string: imagePath) else {
            completion(nil)
            return
        }

        // Demo code only.
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            usleep(50_000)
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

    public func adsGridView(_ adsGridView: AdRecommendationsGridView, cancelLoadingImageWithPath imagePath: String, imageWidth: CGFloat) {}
}

// MARK: - MarketsGridViewDelegate

extension FrontpageViewDemoView: MarketsGridViewDelegate {
    public func marketsGridView(_ marketsGridView: MarketsGridView, didSelectItemAtIndex index: Int) {}
}

// MARK: - MarketsGridViewDataSource

extension FrontpageViewDemoView: MarketsGridViewDataSource {
    public func numberOfItems(inMarketsGridView marketsGridView: MarketsGridView) -> Int {
        return markets.count
    }

    public func marketsGridView(_ marketsGridView: MarketsGridView, modelAtIndex index: Int) -> MarketsGridViewModel {
        return markets[index]
    }
}
