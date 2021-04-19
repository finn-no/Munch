import Foundation

public struct NumberedListItem {
    public let title: String?
    public let body: String

    public init(title: String? = nil, body: String) {
        self.title = title
        self.body = body
    }
}
