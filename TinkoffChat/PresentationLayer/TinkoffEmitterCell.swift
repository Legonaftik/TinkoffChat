//
//  TinkoffEmitterCell.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 27/11/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import UIKit

class TinkoffEmitterCell: CAEmitterCell {

    override init() {
        super.init()

        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        contents = #imageLiteral(resourceName: "tinkoff-herb").cgImage

        birthRate = 10
        lifetime = 2.0
        lifetimeRange = 0.5
        // Initial direction to the top since it is the most clear direction to see
        // while user's finger is on the screen
        emissionLongitude = .pi * -0.5
        emissionRange = .pi * 0.25
        // Gravitation effect
        velocity = 120
        velocityRange = 20
        yAcceleration = 50
        // Smooth disappearance
        scale = 0.4
        scaleSpeed = -0.15
        alphaSpeed = -0.5
    }
}
