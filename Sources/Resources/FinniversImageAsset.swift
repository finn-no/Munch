//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

// Generated by generate_image_assets_symbols as a "Run Script" Build Phase
// WARNING: This file is autogenerated, do not modify by hand

import UIKit

public extension UIImage {
    public convenience init(named imageAsset: FinniversImageAsset) {
        self.init(named: imageAsset.rawValue, in: FinniversKit.bundle, compatibleWith: nil)!
    }
}

public enum FinniversImageAsset: String {
    case noImage = "NoImage"
    case arrowDown
    case arrowRight
    case arrowUp
    case attachment
    case blockUser
    case boat
    case calendar
    case camera
    case car
    case check
    case checkmarkBig
    case classifieds
    case distance
    case download
    case edit
    case editBig
    case error
    case favouriteAdd
    case favouriteAddImg
    case favouriteAdded
    case favouriteAddedImg
    case favourites
    case gallery
    case gridView
    case help
    case hide
    case home
    case important
    case info
    case jobs
    case listView
    case mapDirections
    case mapDrawarea
    case mapMyposition
    case mc
    case messages
    case minus
    case miscLike
    case miscLiked
    case miscMoney
    case mittanbud
    case more
    case moreImg
    case moteplassen
    case notifications
    case onlyNew
    case pin
    case plus
    case profile
    case rate
    case rated
    case ratings
    case realestate
    case remove
    case search
    case searchBig
    case send
    case settings
    case share
    case shopping
    case smalljobs
    case spidLogo
    case success
    case trashcan
    case travel
    case vehicles
    case verified
    case view
    case webview
    case yourads

    public static var imageNames: [FinniversImageAsset] {
        return [
            .noImage,
            .arrowDown,
            .arrowRight,
            .arrowUp,
            .attachment,
            .blockUser,
            .boat,
            .calendar,
            .camera,
            .car,
            .check,
            .checkmarkBig,
            .classifieds,
            .distance,
            .download,
            .edit,
            .editBig,
            .error,
            .favouriteAdd,
            .favouriteAddImg,
            .favouriteAdded,
            .favouriteAddedImg,
            .favourites,
            .gallery,
            .gridView,
            .help,
            .hide,
            .home,
            .important,
            .info,
            .jobs,
            .listView,
            .mapDirections,
            .mapDrawarea,
            .mapMyposition,
            .mc,
            .messages,
            .minus,
            .miscLike,
            .miscLiked,
            .miscMoney,
            .mittanbud,
            .more,
            .moreImg,
            .moteplassen,
            .notifications,
            .onlyNew,
            .pin,
            .plus,
            .profile,
            .rate,
            .rated,
            .ratings,
            .realestate,
            .remove,
            .search,
            .searchBig,
            .send,
            .settings,
            .share,
            .shopping,
            .smalljobs,
            .spidLogo,
            .success,
            .trashcan,
            .travel,
            .vehicles,
            .verified,
            .view,
            .webview,
            .yourads,
    ]
  }
}
