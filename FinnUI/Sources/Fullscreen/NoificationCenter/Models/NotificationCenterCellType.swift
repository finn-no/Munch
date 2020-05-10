//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import FinniversKit

public enum NotificationCenterCellType {
    case notificationCell(NotificationCellModel)
    case emptyCell
    case feedbackCell(FeedbackViewDelegate, FeedbackView.State, FeedbackViewModel)
}
