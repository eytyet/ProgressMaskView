//
//  RotateLayer.swift
//  ProgressMaskView
//
//  Created by Yu Software on 2019/07/19.
//  Copyright © 2019 Yu Software. All rights reserved.
//

import Foundation

/// Layer with automatic rotation feature.
open class RotateLayer : CALayer {
    /// Rotation degree offset
    dynamic public var offsetAngle: Float = 0 {
        didSet {
            transform = Tool.matrixRotateZ(offsetAngle)
        }
    }
    
    // MARK: - CALayer
    
    public override init() {
        super.init()
        transform = Tool.matrixRotateZ(0.0)
        //registerRotateAnimation()
    }
 
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // This is used to duplicate layers to presentation layers.
    public override init(layer: Any) {
        super.init(layer: layer)
        let original = layer as! RotateLayer
        offsetAngle = original.offsetAngle
        transform = original.transform
    }
    
    // Notify needs of redraw.
    open override class func needsDisplay(forKey key: String) -> Bool {
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
    public func rotate(duration: TimeInterval, from startAngle: Float? = nil) {
        guard animation(forKey: "transform.rotation.z") == nil else { return }
        var start:Float
        if startAngle == nil {
            start = Tool.convertRotationZToRadian(from: transform) + offsetAngle
        } else {
            start = startAngle!
        }
        let anime = CABasicAnimation(keyPath: "transform.rotation.z")
        anime.duration = duration
        anime.fromValue = NSNumber(value: start - offsetAngle)
        anime.toValue = NSNumber(value: start - offsetAngle + Float.pi * 2)
        anime.repeatCount = Float.infinity
        add(anime, forKey: "transform.rotation.z")
    }
    
    /// Stop rotation.
    public func stopRotation() {
        if let current = presentation() {
            transform = current.transform
        }
        removeAnimation(forKey: "transform.rotation.z")
    }
}
