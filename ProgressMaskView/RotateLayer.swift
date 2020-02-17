//
//  RotateLayer.swift
//  ProgressMaskView
//
//  Created by eytyet on 2019/07/19.
//  Copyright © 2019 Yu Software. All rights reserved.
//

import Foundation

fileprivate let keyRotationZ = "transform.rotation.z"

/// Layer with automatic rotation feature.
class RotateLayer: CALayer {
    /// Rotation degree offset
    dynamic var offsetAngle: Float = 0 {
        didSet {
            transform = Tool.matrixRotateZ(offsetAngle)
        }
    }
    
    // MARK: - CALayer
    
    override init() {
        super.init()
        transform = Tool.matrixRotateZ(0.0)
    }
 
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// This is used to duplicate layers to presentation layers.
    override init(layer: Any) {
        super.init(layer: layer)
        let original = layer as! RotateLayer
        offsetAngle = original.offsetAngle
        transform = original.transform
    }
    
    /// Notify needs of redraw.
    override class func needsDisplay(forKey key: String) -> Bool {
        if key == "offsetAngle" {
            return false
        }
        return super.needsDisplay(forKey: key)
    }
 
    // MARK: - Methods
    
    /// Start rotation.
    /// - Parameters:
    ///   - duration: Time of one round.
    ///   - startAngle: Start angle. omit it to start current location.
    func rotate(duration: TimeInterval, from startAngle: Float? = nil) {
        guard animation(forKey: keyRotationZ) == nil else { return }
        var start: Float
        if let angle = startAngle {
            start = angle
        } else {
            start = Tool.convertRotationZToRadian(from: transform) + offsetAngle
        }
        let anime = CABasicAnimation(keyPath: keyRotationZ)
        anime.duration = duration
        anime.fromValue = NSNumber(value: start - offsetAngle)
        anime.toValue = NSNumber(value: start - offsetAngle + .pi * 2)
        anime.repeatCount = .infinity
        add(anime, forKey: keyRotationZ)
    }
    
    /// Stop rotation.
    func stopRotation() {
        if let current = presentation() {
            transform = current.transform
        }
        removeAnimation(forKey: keyRotationZ)
    }
}
