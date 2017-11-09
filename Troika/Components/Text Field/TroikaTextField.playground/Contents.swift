//
//  Copyright © FINN.no AS, Inc. All rights reserved.
//

import UIKit
import PlaygroundSupport
import Troika
import TroikaDemoKit

TroikaDemoKit.setupPlayground()

let view = UIView()
view.backgroundColor = .white
view.frame = ScreenSize.medium

let presentable = TroikaTextFieldType.email

let textField = TroikaTextField()
textField.translatesAutoresizingMaskIntoConstraints = false
textField.presentable = presentable

view.addSubview(textField)

textField.topAnchor.constraint(equalTo: view.topAnchor, constant: .mediumLargeSpacing).isActive = true
textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: .mediumLargeSpacing).isActive = true
textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -.mediumLargeSpacing).isActive = true

PlaygroundPage.current.liveView = view
