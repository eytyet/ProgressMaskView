//
//  LineArcView.swift
//  ProgressMaskView
//
//  Created by Yu Software on 2019/07/13.
//  Copyright © 2019 Yu Software. All rights reserved.
//

import UIKit


/// UIView of a thick beautiful arc. Rotatable.
@IBDesignable
open class LineArcRotateView : UIView, ArcShape {
    
    private let backgroundArcView: LineArcView
    
    private let foregroundArcView: LineArcView
    
    private var isRotating: Bool = false
    
    private var angleDifference = CGFloat.pi / 2 {
        didSet {
            backgroundArcLayer.offsetAngle = -Float(angleDifference)
        }
    }
    
    private var foregroundArcLayer: RotateLayer!
    
    private var backgroundArcLayer: RotateLayer!
    
    @IBInspectable public var widthAndHeight: CGFloat {
        get {
            return foregroundArcView.widthAndHeight
        }
        set {
            foregroundArcView.widthAndHeight = newValue
            backgroundArcView.widthAndHeight = newValue
        }
    }
    
    @IBInspectable public var autoFitInside: Bool {
        get {
            return foregroundArcView.autoFitInside
        }
        set {
            foregroundArcView.autoFitInside = newValue
            backgroundArcView.autoFitInside = newValue
        }
    }
    
    @IBInspectable public var arcRadiusRatio: CGFloat {
        get {
            return foregroundArcView.arcRadiusRatio
        }
        set {
            foregroundArcView.arcRadiusRatio = newValue
            backgroundArcView.arcRadiusRatio = newValue
        }
    }
    
    @IBInspectable public var arcLineWidthRatio: CGFloat {
        get {
            return foregroundArcView.arcLineWidthRatio
        }
        set {
            foregroundArcView.arcLineWidthRatio = newValue
            backgroundArcView.arcLineWidthRatio = newValue
        }
    }
    
    @IBInspectable public var arcCenterRatio: CGPoint {
        get {
            return foregroundArcView.arcCenterRatio
        }
        set {
            foregroundArcView.arcCenterRatio = newValue
            backgroundArcView.arcCenterRatio = newValue
        }
    }
    
    @IBInspectable public var arcGradation: CGFloat {
        get {
            return foregroundArcView.arcGradation
        }
        set {
            foregroundArcView.arcGradation = newValue
            backgroundArcView.arcGradation = newValue
        }
    }
    
    /// Arc fill color 1
    @IBInspectable public var arcColor1: UIColor {
        get {
            return foregroundArcView.lineColor
        }
        set {
            foregroundArcView.lineColor = newValue
        }
    }
    
    /// Arc fill color 2
    @IBInspectable public var arcColor2: UIColor {
        get {
            return backgroundArcView.lineColor
        }
        set {
            backgroundArcView.lineColor = newValue
        }
    }
    
    /// Start angle
    @IBInspectable public var startAngle: CGFloat {
        get {
            return foregroundArcView.startAngle
        }
        set {
            foregroundArcView.startAngle = newValue
            backgroundArcView.startAngle = newValue + angleDifference
        }
    }
    
    /// End angle. It should be endAngle < startAngle.
    @IBInspectable public var endAngle: CGFloat {
        get {
            return foregroundArcView.endAngle
        }
        set {
            foregroundArcView.endAngle = newValue
            backgroundArcView.endAngle = newValue + angleDifference
        }
    }
    
    // MARK: - UIView
    
    public override init(frame: CGRect) {
        backgroundArcView = LineArcView(frame: frame)
        foregroundArcView = LineArcView(frame: frame)
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        let dummy = CGRect(x: 0, y: 0, width: 100, height: 100)
        backgroundArcView = LineArcView(frame: dummy)
        foregroundArcView = LineArcView(frame: dummy)
        super.init(coder: aDecoder)
        setup()
    }
    
    /// setup views, constraints and default values.
    private func setup() {
        func addAndSetup(_ view: LineArcView) {
            addAndSetConstraint(view)
            view.shouldAnimate = true
        }
        addAndSetup(backgroundArcView)
        addAndSetup(foregroundArcView)
        let squareConstraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0)
        self.addConstraint(squareConstraint)
        foregroundArcView.shouldAnimate = true
        backgroundArcView.shouldAnimate = true
        foregroundArcLayer = (foregroundArcView.layer as! RotateLayer)
        backgroundArcLayer = (backgroundArcView.layer as! RotateLayer)
        backgroundArcLayer.offsetAngle = -Float(angleDifference)
        arcRadiusRatio = 0.45
        arcLineWidthRatio = 0.05
        startAngle = 0
        endAngle = 0
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: widthAndHeight, height: widthAndHeight)
    }
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: widthAndHeight, height: widthAndHeight)
    }
    
    // MARK: - Methods
    
    /// Start rotate animation
    public func startRotation(duration: TimeInterval) {
        //guard foregroundArcView.layer.animation(forKey: "rotate") == nil else { return }
        guard isRotating == false else { return }
        isRotating = true
        foregroundArcLayer.rotate(duration: 3)
        backgroundArcLayer.rotate(duration: 3)
        //backgroundArcLayer.startOffsetChange(duration: 30)
        
        /*
        let currentRadian = getRadian(from: foregroundArcView.layer.transform)
        let anime1 = CABasicAnimation(keyPath: "transform.rotation.z")
        anime1.duration = duration
        anime1.fromValue = NSNumber(value: currentRadian)
        anime1.toValue = NSNumber(value: currentRadian + Float.pi * 2)
        anime1.repeatCount = Float.infinity
        let anime2 = CABasicAnimation(keyPath: "transform.rotation.z")
        anime2.duration = duration
        anime2.fromValue = NSNumber(value: currentRadian - Float(angleDifference))
        anime2.toValue = NSNumber(value: currentRadian - Float(angleDifference) + Float.pi * 2)
        anime2.repeatCount = Float.infinity
        print("start from \(currentRadian). from [\(anime1.fromValue), \(anime2.fromValue)")
        /*CATransaction.begin()
        CATransaction.setCompletionBlock({  // repeat rotation
            if self.isRotating {
                self.startRotation(duration: duration)
            }
        })
        CATransaction.commit()*/
        #warning("anime3は動いていない。要更新。")
        let anime3 = CABasicAnimation(keyPath: "angleDifference")
        anime3.duration = duration
        anime3.fromValue = NSNumber(value: Float(angleDifference))
        anime3.toValue = NSNumber(value: Float(angleDifference + CGFloat.pi))
        self.foregroundArcView.layer.add(anime1, forKey: "rotate")
        self.backgroundArcView.layer.add(anime2, forKey: "rotate")
        self.backgroundArcView.layer.add(anime3, forKey: "angleDifference")
        UIView.animate(withDuration: duration, animations: {
            self.layoutIfNeeded()
            self.angleDifference += CGFloat.pi
        }, completion: { (_) in
            if self.isRotating {
                self.startRotation(duration: duration)
            }
        })
 */
    }
    
    /// Stop rotate animation.
    public func stopRotation() {
        isRotating = false
        foregroundArcLayer.stopRotation()
        backgroundArcLayer.stopRotation()
        //backgroundArcLayer.stopOffsetChange()
        //foregroundArcView.layer.transform = foregroundArcView.layer.presentation()!.transform
        //backgroundArcView.layer.transform = backgroundArcView.layer.presentation()!.transform
        //foregroundArcView.layer.removeAnimation(forKey: "rotate")
        //backgroundArcView.layer.removeAnimation(forKey: "rotate")
        //backgroundArcView.layer.removeAnimation(forKey: "angleDifference")
        //let radian = getRadian(from: foregroundArcView.layer.transform)
        //print("stop: radian= \(radian)")
    }
    
    /// Setup initial angle without animation
    public func setInitialAngle(start: CGFloat, end: CGFloat) {
        func setup(_ view: LineArcView) {
            view.shouldAnimate = false
            view.startAngle = start
            view.endAngle = end
            view.shouldAnimate = true
        }
        setup(foregroundArcView)
        setup(backgroundArcView)
    }
    
}





