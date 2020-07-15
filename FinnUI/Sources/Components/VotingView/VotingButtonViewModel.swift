//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public struct VotingButtonViewModel {
    public let identifier: String
    public let title: String
    public let subtitle: String?
    public let icon: UIImage
    public let isEnabled: Bool
    public let isSelected: Bool

    public init(
        identifier: String,
        title: String,
        subtitle: String?,
        icon: UIImage,
        isEnabled: Bool = true,
        isSelected: Bool = false
    ) {
        self.identifier = identifier
        self.title = title
        self.subtitle = subtitle
        self.icon = icon
        self.isEnabled = isEnabled
        self.isSelected = isSelected
    }
}
