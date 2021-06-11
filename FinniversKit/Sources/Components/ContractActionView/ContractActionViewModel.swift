//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public struct ContractActionViewModel {
    public let identifier: String?
    public let title: String?
    public let strings: [String]
    public let buttonTitle: String
    public let buttonUrl: URL
    public let videoLink: VideoLink?

    public init(identifier: String?, title: String? = nil, strings: [String], buttonTitle: String, buttonUrl: URL, videoLink: VideoLink? = nil) {
        self.identifier = identifier
        self.title = title
        self.strings = strings
        self.buttonTitle = buttonTitle
        self.buttonUrl = buttonUrl
        self.videoLink = videoLink
    }

    public struct VideoLink {
        public let title: String
        public let videoUrl: URL
        public let thumbnailUrl: URL

        public init(title: String, videoUrl: URL, thumbnailUrl: URL) {
            self.title = title
            self.videoUrl = videoUrl
            self.thumbnailUrl = thumbnailUrl
        }
    }
}
