//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit

public protocol TransactionStepViewDelegate: AnyObject {
    func transactionStepViewDidSelectActionButton(_ view: TransactionStepView, inTransactionStep step: Int,
                                                  withAction action: String?, withUrl urlString: String?,
                                                  withFallbackUrl fallbackUrlString: String?)
}

public enum TransactionStepViewState: String {
    case notStarted = "not_started"
    case active = "active"
    case completed = "completed"

    var style: TransactionStepView.Style {
        switch self {
        case .notStarted:
            return .notStarted
        case .active:
            return .active
        case .completed:
            return .completed
        }
    }
}

public class TransactionStepView: UIView {
    // MARK: - Public properties

    public weak var delegate: TransactionStepViewDelegate?

    // MARK: - Private properties

    private var step: Int
    private var model: TransactionStepViewModel
    private var actionButtonModel: TransactionStepButtonViewModel?

    private var style: TransactionStepView.Style
    private var activeStepColor: UIColor = .bgTertiary

    private var verticalStackViewLeadingAnchor: NSLayoutConstraint?
    private var verticalStackViewTrailingAnchor: NSLayoutConstraint?
    private var verticalStackViewTopAnchor: NSLayoutConstraint?

    private var bottomAnchorConstraint: NSLayoutConstraint?

    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(withAutoLayout: true)
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .leading
        return stackView
    }()

    private lazy var titleView: UITextView = {
        let view = UITextView(withAutoLayout: true)
        view.font = style.titleFont
        view.textColor = style.titleTextColor
        view.backgroundColor = style.backgroundColor
        view.isScrollEnabled = false
        view.isEditable = false
        view.contentInset = .init(top: -.mediumSpacing, leading: 0, bottom: 0, trailing: 0)
        view.adjustsFontForContentSizeCategory = true
        view.textContainer.widthTracksTextView = true
        view.textContainer.heightTracksTextView = true
        return view
    }()

    private lazy var bodyView: UITextView = {
        let view = UITextView(withAutoLayout: true)
        view.font = style.bodyFont
        view.textColor = style.bodyTextColor
        view.backgroundColor = style.backgroundColor
        view.isScrollEnabled = false
        view.isEditable = false
        view.contentInset = .init(top: -.mediumSpacing, leading: 0, bottom: 0, trailing: 0)
        view.adjustsFontForContentSizeCategory = true
        view.textContainer.widthTracksTextView = true
        view.textContainer.heightTracksTextView = true
        return view
    }()

    private lazy var detailView: UITextView = {
        let view = UITextView(withAutoLayout: true)
        view.font = style.detailFont
        view.textColor = style.detailTextColor
        view.backgroundColor = style.backgroundColor
        view.isScrollEnabled = false
        view.isEditable = false
        view.contentInset = .leadingInset(0)
        view.adjustsFontForContentSizeCategory = true
        view.textContainer.widthTracksTextView = true
        view.textContainer.heightTracksTextView = true
        return view
    }()

    // MARK: - Init

    public init(step: Int, model: TransactionStepViewModel, withAutoLayout autoLayout: Bool = false) {
        self.step = step
        self.model = model
        self.actionButtonModel = model.button ?? nil
        self.style = model.state.style

        super.init(frame: .zero)

        translatesAutoresizingMaskIntoConstraints = !autoLayout
        setup()
    }

    public func hasCompletedLastStep(_ isCompleted: Bool) {
        guard isCompleted == true else { return }

        backgroundColor = activeStepColor
        titleView.backgroundColor = activeStepColor
        bodyView.backgroundColor = activeStepColor
        detailView.backgroundColor = activeStepColor

        verticalStackViewTopAnchor?.constant = .mediumLargeSpacing
        verticalStackViewLeadingAnchor?.constant = .mediumLargeSpacing
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private

private extension TransactionStepView {
    private func setup() {
        backgroundColor = style.backgroundColor
        layer.cornerRadius = style.cornerRadius

        addSubview(verticalStackView)

        titleView.text = model.title
        verticalStackView.addArrangedSubview(titleView)

        switch style {
        case .notStarted, .completed:
            verticalStackViewLeadingAnchor = verticalStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .smallSpacing)
            verticalStackViewTrailingAnchor = verticalStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.mediumSpacing)
            verticalStackViewTopAnchor = verticalStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor)

            NSLayoutConstraint.activate([
                verticalStackViewLeadingAnchor!,
                verticalStackViewTrailingAnchor!,
                verticalStackViewTopAnchor!,

                titleView.heightAnchor.constraint(greaterThanOrEqualToConstant: .mediumPlusSpacing),
            ])

        case .active:
            verticalStackViewLeadingAnchor = verticalStackView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor, constant: .mediumLargeSpacing)
            verticalStackViewTrailingAnchor = verticalStackView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor, constant: -.mediumSpacing)
            verticalStackViewTopAnchor = verticalStackView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: .mediumLargeSpacing)

            NSLayoutConstraint.activate([
                verticalStackViewLeadingAnchor!,
                verticalStackViewTrailingAnchor!,
                verticalStackViewTopAnchor!,

                titleView.heightAnchor.constraint(greaterThanOrEqualToConstant: .mediumPlusSpacing),
            ])
        }

        titleView.setContentHuggingPriority(.required, for: .vertical)
        setupOptionalViews()
    }

    private func setupOptionalViews() {
        if let bodyText = model.body {
            bodyView.text = bodyText
            verticalStackView.addArrangedSubview(bodyView)

            bodyView.setContentHuggingPriority(.required, for: .vertical)
            NSLayoutConstraint.activate([bodyView.trailingAnchor.constraint(equalTo: verticalStackView.trailingAnchor)])

            bottomAnchorConstraint = bottomAnchor.constraint(equalTo: bodyView.bottomAnchor, constant: .mediumPlusSpacing)
        }

        if let buttonModel = actionButtonModel {
            let buttonText = buttonModel.text
            let buttonStyle = TransactionStepView.ActionButton(rawValue: buttonModel.style).buttonStyle

            let actionButton = Button(style: buttonStyle, withAutoLayout: true)
            actionButton.setTitle(buttonText, for: .normal)
            actionButton.isEnabled = style.actionButtonEnabled
            actionButton.addTarget(self, action: #selector(handleActionButtonTap), for: .touchUpInside)

            verticalStackView.addArrangedSubview(actionButton)

            if model.state == .completed {
                actionButton.contentHorizontalAlignment = .leading
                actionButton.contentEdgeInsets = .leadingInset(-2)
            }

            actionButton.setContentHuggingPriority(.required, for: .vertical)
            NSLayoutConstraint.activate([actionButton.heightAnchor.constraint(equalToConstant: 40)])

            bottomAnchorConstraint = bottomAnchor.constraint(equalTo: actionButton.bottomAnchor, constant: .mediumPlusSpacing)
        }

        if let detailText = model.detail {
            detailView.text = detailText
            verticalStackView.addArrangedSubview(detailView)

            bottomAnchorConstraint = bottomAnchor.constraint(equalTo: detailView.bottomAnchor, constant: .mediumPlusSpacing)
        }

        bottomAnchorConstraint?.isActive = true
    }
}

// MARK: - Selectors

private extension TransactionStepView {
    @objc func handleActionButtonTap() {
        let buttonAction = actionButtonModel?.action
        let buttonUrlString = actionButtonModel?.urlString
        let buttonFallbackUrl = actionButtonModel?.fallbackUrlString

//        delegate?.transactionStepViewDidSelectActionButton(self, inTransactionStep: step, withAction: action, withUrl: urlString, withFallbackUrl: fallbackUrlString)
    }
}
