//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

public class MessageFormBottomSheet: BottomSheet {

    // MARK: - Public properties

    public weak var messageFormDelegate: MessageFormDelegate?

    // MARK: - Private properties

    private let messageFormViewController: MessageFormViewController!
    private let rootController: UINavigationController!
    private let viewModel: MessageFormViewModel

    // MARK: - Init

    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    public required init(viewModel: MessageFormViewModel) {
        self.viewModel = viewModel
        messageFormViewController = MessageFormViewController(viewModel: viewModel)
        rootController = UINavigationController(rootViewController: messageFormViewController)
        rootController.navigationBar.isTranslucent = false

        super.init(rootViewController: rootController, height: .messageFormHeight, draggableArea: .navigationBar)
    }
}

extension MessageFormBottomSheet: MessageFormDelegate {
    public func messageFormDidCancel() {
        messageFormDelegate?.messageFormDidCancel()
    }

    public func messageFormDidFinish(withText text: String, templateState: MessageFormTemplateState) {
        messageFormDelegate?.messageFormDidFinish(withText: text, templateState: templateState)
    }
}

// MARK: - Private extensions

private extension BottomSheet.Height {
    static var messageFormHeight: BottomSheet.Height {
        let screenSize = UIScreen.main.bounds.size

        if screenSize.height <= 568 {
            return BottomSheet.Height(compact: 510, expanded: 510)
        }

        let height = screenSize.height - 64

        return BottomSheet.Height(compact: height, expanded: height)
    }
}
