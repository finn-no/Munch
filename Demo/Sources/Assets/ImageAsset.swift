//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

// Generated by generate_image_assets_symbols as a "Run Script" Build Phase
// WARNING: This file is autogenerated, do not modify by hand

import UIKit

private class BundleHelper {
}

extension UIImage {
    convenience init(named imageAsset: ImageAsset) {
        #if SWIFT_PACKAGE
        let bundle = Bundle.module
        #else
        let bundle = Bundle(for: BundleHelper.self)
        #endif
        self.init(named: imageAsset.rawValue, in: bundle, compatibleWith: nil)!
    }

    @objc class func assetNamed(_ assetName: String) -> UIImage {
        #if SWIFT_PACKAGE
        let bundle = Bundle.module
        #else
        let bundle = Bundle(for: BundleHelper.self)
        #endif
        return UIImage(named: assetName, in: bundle, compatibleWith: nil)!
    }
}

//swiftlint:disable superfluous_disable_command
//swiftlint:disable type_body_length
enum ImageAsset: String {
    case adsenseDemo
    case arrowCounterClockwise
    case betaImageSearch
    case boat
    case car
    case checkCircleFilled
    case classifieds
    case consentTransparencyImage
    case displayTypeGrid
    case displayTypeList
    case dissatisfiedFace
    case emptyMoon
    case emptyStateSaveSearch
    case favorites
    case filledMoon
    case filter
    case gift
    case home
    case iconRealestateApartments
    case iconRealestateBedrooms
    case iconRealestateOwner
    case iconRealestatePrice
    case illustrasjonMedFarge
    case illustrasjonUtenFarge
    case jobs
    case magnifyingGlass
    case mc
    case messages
    case mittanbud
    case moteplassen
    case notifications
    case notificationsBell
    case npCompare
    case npDrive
    case npHouseWeather
    case npPublicTransport
    case npRecommended
    case npSafeNeighborhood
    case npSchool
    case npStopwatch
    case npStore
    case npWalk
    case nyhetsbrevFraFinn
    case okonomi
    case pin
    case playVideo
    case primingFavoritesComments
    case primingFavoritesSearch
    case primingFavoritesSharing
    case profile
    case ratings
    case realestate
    case remove
    case removeFilterTag
    case savedSearches
    case service
    case shopping
    case sold
    case travel
    case vehicles
    case virtualViewing
    case warranty
    case yourads

    static var imageNames: [ImageAsset] {
        return [
            .adsenseDemo,
            .arrowCounterClockwise,
            .betaImageSearch,
            .boat,
            .car,
            .checkCircleFilled,
            .classifieds,
            .consentTransparencyImage,
            .displayTypeGrid,
            .displayTypeList,
            .dissatisfiedFace,
            .emptyMoon,
            .emptyStateSaveSearch,
            .favorites,
            .filledMoon,
            .filter,
            .gift,
            .home,
            .iconRealestateApartments,
            .iconRealestateBedrooms,
            .iconRealestateOwner,
            .iconRealestatePrice,
            .illustrasjonMedFarge,
            .illustrasjonUtenFarge,
            .jobs,
            .magnifyingGlass,
            .mc,
            .messages,
            .mittanbud,
            .moteplassen,
            .notifications,
            .notificationsBell,
            .npCompare,
            .npDrive,
            .npHouseWeather,
            .npPublicTransport,
            .npRecommended,
            .npSafeNeighborhood,
            .npSchool,
            .npStopwatch,
            .npStore,
            .npWalk,
            .nyhetsbrevFraFinn,
            .okonomi,
            .pin,
            .playVideo,
            .primingFavoritesComments,
            .primingFavoritesSearch,
            .primingFavoritesSharing,
            .profile,
            .ratings,
            .realestate,
            .remove,
            .removeFilterTag,
            .savedSearches,
            .service,
            .shopping,
            .sold,
            .travel,
            .vehicles,
            .virtualViewing,
            .warranty,
            .yourads,
    ]
  }
}
