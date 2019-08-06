//
//  Copyright © 2019 FINN AS. All rights reserved.
//

import Foundation

protocol MessageFormToolbarDelegate: AnyObject {
    func messageFormToolbar(_ toolbar: MessageFormToolbar, didSelectMessageTemplate template: MessageFormTemplate)
    func messageFormToolbarTappedCustomizeButton(_ toolbar: MessageFormToolbar)
}

class MessageFormToolbar: UIView {

    // MARK: - UI properties

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = CGSize(width: toolbarCellMaxWidth, height: toolbarCellHeight)

        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.register(MessageFormTemplateCell.self)
        view.register(MessageFormCustomizeCell.self)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .clear
        view.showsHorizontalScrollIndicator = false
        view.contentInset = UIEdgeInsets(top: 0, leading: .mediumSpacing, bottom: 0, trailing: .mediumSpacing)
        return view
    }()

    private lazy var safeAreaHeight: CGFloat = {
        if #available(iOS 11.0, *) {
            return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        } else {
            return 0
        }
    }()

    private lazy var safeAreaCoverView: UIView = {
        let view = UIView(withAutoLayout: true)
        view.backgroundColor = MessageFormToolbar.backgroundColor
        return view
    }()

    // MARK: - Internal properties

    weak var delegate: MessageFormToolbarDelegate?

    var showCustomizeButton: Bool = false {
        didSet {
            if showCustomizeButton != oldValue {
                collectionView.reloadData()
            }
        }
    }

    // MARK: - Private properties

    private static let backgroundColor = UIColor(r: 208, g: 212, b: 215)

    private let viewModel: MessageFormViewModel

    private let toolbarHeight: CGFloat = 68
    private let toolbarTopPadding: CGFloat = .mediumSpacing
    private let toolbarBottomPadding: CGFloat = .mediumSpacing
    private var toolbarCellHeight: CGFloat { return toolbarHeight - toolbarTopPadding - toolbarBottomPadding }
    private var toolbarCellMaxWidth: CGFloat {
        if UIDevice.isIPad() {
            return 200
        } else {
            return 130
        }
    }

    private var customTemplates: [MessageFormTemplate] {
        return viewModel.messageTemplateStore?.customTemplates ?? []
    }

    // MARK: - Init

    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }

    required init(viewModel: MessageFormViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setup()
    }

    private func setup() {
        backgroundColor = MessageFormToolbar.backgroundColor
        showCustomizeButton = viewModel.showCustomizeButton && viewModel.messageTemplateStore != nil

        addSubview(collectionView)
        addSubview(safeAreaCoverView)
        collectionView.fillInSuperview(insets: UIEdgeInsets(top: toolbarTopPadding, leading: 0, bottom: -toolbarBottomPadding, trailing: 0))

        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: toolbarHeight),

            safeAreaCoverView.heightAnchor.constraint(equalToConstant: safeAreaHeight),
            safeAreaCoverView.leadingAnchor.constraint(equalTo: leadingAnchor),
            safeAreaCoverView.trailingAnchor.constraint(equalTo: trailingAnchor),
            safeAreaCoverView.topAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    // MARK: - Internal methods

    func offsetForToolbar(withKeyboardVisible keyboardVisible: Bool) -> CGFloat {
        /// The Toolbar view wants to hide its' bottom padding when the keyboard is visible,
        /// as this padding is "embedded" in the top of the stock keyboard itself.
        if keyboardVisible {
            return safeAreaHeight - toolbarBottomPadding
        } else {
            return safeAreaHeight
        }
    }

    func reloadData() {
        collectionView.reloadData()
    }
}

extension MessageFormToolbar: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            let trailingMargin = showCustomizeButton ? CGFloat.mediumSpacing : 0
            return UIEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: trailingMargin)
        }

        return UIEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
    }

    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return .mediumSpacing
    }
}

extension MessageFormToolbar: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return showCustomizeButton ? 1 : 0
        case 1:
            return customTemplates.count + viewModel.defaultMessageTemplates.count
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let cell = collectionView.dequeue(MessageFormCustomizeCell.self, for: indexPath)
            cell.delegate = self
            return cell
        case 1:
            let maybeTemplate: MessageFormTemplate?
            if indexPath.row < customTemplates.count {
                maybeTemplate = customTemplates[safe: indexPath.row]
            } else {
                let index = indexPath.row - customTemplates.count
                maybeTemplate = viewModel.defaultMessageTemplates[safe: index]
            }

            guard let template = maybeTemplate else {
                return UICollectionViewCell()
            }

            let cell = collectionView.dequeue(MessageFormTemplateCell.self, for: indexPath)
            cell.configure(withTemplate: template, maxWidth: toolbarCellMaxWidth, height: toolbarCellHeight)
            cell.delegate = self
            return cell
        default:
            fatalError("Unexpected section: \(indexPath.section)")
        }
    }
}

extension MessageFormToolbar: MessageFormTemplateCellDelegate {
    fileprivate func messageFormTemplateCellWasTapped(_ cell: MessageFormTemplateCell) {
        guard let messageTemplate = cell.template else {
            return
        }

        delegate?.messageFormToolbar(self, didSelectMessageTemplate: messageTemplate)
    }
}

extension MessageFormToolbar: MessageFormCustomizeCellDelegate {
    fileprivate func messageFormCustomizeCellWasTapped(_ cell: MessageFormCustomizeCell) {
        delegate?.messageFormToolbarTappedCustomizeButton(self)
    }
}

// MARK: - MessageFormTemplateCell

private protocol MessageFormTemplateCellDelegate: AnyObject {
    func messageFormTemplateCellWasTapped(_ cell: MessageFormTemplateCell)
}

private class MessageFormTemplateCell: UICollectionViewCell {

    // MARK: - UI properties

    private lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundColor(color: .toothPaste, forState: .normal)
        button.setBackgroundColor(color: .secondaryBlue, forState: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var label: Label = {
        let label = Label(style: .detail)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.textAlignment = .center
        label.lineBreakMode = .byTruncatingTail
        return label
    }()

    private lazy var heightConstraint = contentView.heightAnchor.constraint(equalToConstant: 100)
    private lazy var widthConstraint = contentView.widthAnchor.constraint(equalToConstant: 100)

    // MARK: - Internal properties

    weak var delegate: MessageFormTemplateCellDelegate?
    private(set) var template: MessageFormTemplate?

    // MARK: - Init

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        contentView.addSubview(button)
        button.fillInSuperview()

        button.addSubview(label)
        label.fillInSuperview(margin: .smallSpacing)
    }

    // MARK: - Internal methods

    func configure(withTemplate template: MessageFormTemplate, maxWidth: CGFloat, height: CGFloat) {
        self.template = template
        label.text = template.text.condenseWhitespace()
        heightConstraint.constant = height
        widthConstraint.constant = maxWidth

        heightConstraint.isActive = true
        widthConstraint.isActive = true
    }

    // MARK: - Private methods

    @objc private func buttonTapped() {
        delegate?.messageFormTemplateCellWasTapped(self)
    }
}

// MARK: - MessageFormCustomizeCell

private protocol MessageFormCustomizeCellDelegate: AnyObject {
    func messageFormCustomizeCellWasTapped(_ cell: MessageFormCustomizeCell)
}

private class MessageFormCustomizeCell: UICollectionViewCell {

    static let cellSize = CGSize(width: 30, height: 30)
    static let imageSize = CGSize(width: 25, height: 25)

    // MARK: - UI properties

    private lazy var button: UIButton = {
        let button = UIButton(type: .custom)
        button.setBackgroundColor(color: .toothPaste, forState: .normal)
        button.setBackgroundColor(color: .secondaryBlue, forState: .highlighted)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = MessageFormCustomizeCell.cellSize.width / 2
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()

    private lazy var imageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: .plus))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .clear
        return imageView
    }()

    // MARK: - Internal properties

    weak var delegate: MessageFormCustomizeCellDelegate?

    // MARK: - Init

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    private func setup() {
        contentView.addSubview(button)
        button.addSubview(imageView)

        button.fillInSuperview()

        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            imageView.widthAnchor.constraint(equalToConstant: MessageFormCustomizeCell.imageSize.width),
            imageView.heightAnchor.constraint(equalToConstant: MessageFormCustomizeCell.imageSize.height),

            contentView.widthAnchor.constraint(equalToConstant: MessageFormCustomizeCell.cellSize.width),
            contentView.heightAnchor.constraint(equalToConstant: MessageFormCustomizeCell.cellSize.height)
        ])
    }

    // MARK: - Private methods

    @objc private func buttonTapped() {
        delegate?.messageFormCustomizeCellWasTapped(self)
    }
}

// MARK: - Private extensions

private extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        guard let context = UIGraphicsGetCurrentContext() else {
            UIGraphicsEndImageContext()
            return
        }

        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.setBackgroundImage(colorImage, for: forState)
    }
}

private extension String {
    func condenseWhitespace() -> String {
        let components = self.components(separatedBy: .whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
}

