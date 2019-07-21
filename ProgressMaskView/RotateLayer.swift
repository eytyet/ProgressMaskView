//
//  RotateLayer.swift
//  ProgressMaskView
//
//  Created by Yu Software on 2019/07/19.
//  Copyright © 2019 Yu Software. All rights reserved.
//

import Foundation

open class RotateLayer : CALayer {
    /// Rotation degree offset
    dynamic public var offsetAngle: Float = 0 {
        didSet {
            transform = matrixRotateZ(offsetAngle)
        }
    }
    
    // MARK: - CALayer
    
    public override init() {
        super.init()
        transform = matrixRotateZ(0.0)
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
        print("needsDisplay(forKey:\(key))")        
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
            start = getRadian(from: transform) + offsetAngle
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
    /*
    private func registerRotateAnimation() {
        let angle = getRadian(from: transform)
        let anime = CABasicAnimation(keyPath: "transform.rotation.z")
        anime.duration = duration
        anime.fromValue = NSNumber(value: angle - offsetAngle)
        anime.toValue = NSNumber(value: angle - offsetAngle + Float.pi * 2)
        anime.repeatCount = Float.infinity
        if var actions = actions {
            actions["transform.rotation.z"] = anime
        } else {
            actions = ["transform.rotation.z" : anime]
        }
        //add(anime, forKey: "transform.rotation.z")
    }*/
    /*
    /// Change offset automatically
    ///
    /// - Parameter duration: Duration of one round.
    public func startOffsetChange(duration: TimeInterval, clockwise: Bool = true) {
        print("offsetChange")
        guard animation(forKey: "offsetAngle") == nil else { return }
        let anime = CABasicAnimation(keyPath: "offsetAngle")
        let diff = clockwise == true ? -Float.pi * 2 : Float.pi * 2
        anime.duration = duration
        anime.fromValue = NSNumber(value: offsetAngle)
        anime.toValue = NSNumber(value: offsetAngle + diff)
        anime.repeatCount = Float.infinity
        add(anime, forKey: "offsetAngle")
    }
    
    public func stopOffsetChange() {
        guard let current = presentation() else { return }
        offsetAngle = current.offsetAngle
        removeAnimation(forKey: "offsetAngle")
    }*/
    
}
