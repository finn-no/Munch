//
//  Copyright © 2020 FINN.no AS. All rights reserved.
//

import FinniversKit

public class ConfettiView: UIView {

    private let confettiImages: [UIImage] = [
        .init(named: .confetti1),
        .init(named: .confetti2)
    ]

    private let confettiColors: [UIColor] = [
        .primaryBlue,
        .secondaryBlue,
        .pea,
        .watermelon
    ]

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setup() {
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }

    public func start(withDuration duration: TimeInterval = 0.75, completion: (() -> Void)? = nil) {
        let emitterLayer = createConfettiEmitterLayer()

        layer.addSublayer(emitterLayer)

        DispatchQueue.main.asyncAfter(
            deadline: .now() + duration,
            execute: {
                emitterLayer.lifetime = 0
                completion?()
            }
        )
    }

    private func createConfettiEmitterLayer() -> CAEmitterLayer {
        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterSize = CGSize(width: bounds.size.width, height: 1)
        emitterLayer.emitterPosition = CGPoint(x: bounds.size.width / 2, y: -50)
        emitterLayer.emitterShape = .line

        let beginTime = CACurrentMediaTime()

        emitterLayer.emitterCells = (0...8).map {
            let color = confettiColors[$0 % confettiColors.count]
            return createConfettiEmitterCell(beginTime: beginTime, color: color)
        }

        return emitterLayer
    }

    private func createConfettiEmitterCell(beginTime: CFTimeInterval, color: UIColor) -> CAEmitterCell {
        let cell = CAEmitterCell()

        cell.beginTime = beginTime
        cell.birthRate = 10
        cell.lifetime = 5

        cell.contents = confettiImages.randomElement()?.cgImage
        cell.color = color.cgColor

        cell.emissionLongitude = CGFloat.pi
        cell.emissionRange = CGFloat.pi / 8

        cell.velocity = UIDevice.current.userInterfaceIdiom == .pad ? 600 : 500
        cell.velocityRange = 50

        cell.scale = UIDevice.current.userInterfaceIdiom == .pad ? 0.3 : 0.2

        cell.spin = Float.random(in: 0...1) > 0.5 ? 8 : -8
        cell.spinRange = 2

        return cell
    }

}
