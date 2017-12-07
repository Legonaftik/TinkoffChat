//
//  AppDelegate.swift
//  TinkoffChat
//
//  Created by Vladimir Pavlov on 20/09/2017.
//  Copyright © 2017 Vladimir Pavlov. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    private lazy var particleEmmiter: CAEmitterLayer = {
        let particleEmitter = CAEmitterLayer()
        particleEmitter.emitterShape = kCAEmitterLayerPoint
        particleEmitter.emitterCells = [TinkoffEmitterCell()]
        window?.layer.addSublayer(particleEmitter)
        return particleEmitter
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        showHerbsOnScreenTouch()
        return true
    }

    func showHerbsOnScreenTouch() {
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(updateHerbsAnimation(recognizer:)))
        gestureRecognizer.minimumPressDuration = 0.2
        window?.addGestureRecognizer(gestureRecognizer)
    }

    @objc func updateHerbsAnimation(recognizer: UILongPressGestureRecognizer) {
        switch recognizer.state {
        case .began:
            particleEmmiter.birthRate = 1
            particleEmmiter.emitterPosition = recognizer.location(in: window)
        case .changed:
            particleEmmiter.emitterPosition = recognizer.location(in: window)
        case .ended:
            particleEmmiter.birthRate = 0
        default:
            break
        }
    }
}
