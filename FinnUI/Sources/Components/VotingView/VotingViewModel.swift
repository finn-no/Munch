//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

public struct VotingViewModel {
    public let icon: UIImage
    public let title: String
    public let description: String
    public let leftVotingButton: VotingButtonViewModel
    public let rightVotingButton: VotingButtonViewModel

    public init(
        icon: UIImage,
        title: String,
        description: String,
        leftVotingButton: VotingButtonViewModel,
        rightVotingButton: VotingButtonViewModel
    ) {
        self.icon = icon
        self.title = title
        self.description = description
        self.leftVotingButton = leftVotingButton
        self.rightVotingButton = rightVotingButton
    }
}
