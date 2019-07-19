//
//  LineCircleView.swift
//  ProgressMaskView
//
//  Created by Yu Software on 2019/07/13.
//  Copyright © 2019 Yu Software. All rights reserved.
//

import UIKit


/// UIView of a thick beautiful circle. Rotatable.
@IBDesignable
open class LineArcRotateView : UIView, CircleShape {
    
    private let backgroundArcView: LineArcView
    
    private let foregroundArcView: LineArcView
    
    private var isRotating: Bool = false
    
    private var angleDifference = CGFloat.pi / 2
    
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
    
    @IBInspectable public var circleRadiusRatio: CGFloat {
        get {
            return foregroundArcView.circleRadiusRatio
        }
        set {
            foregroundArcView.circleRadiusRatio = newValue
            backgroundArcView.circleRadiusRatio = newValue
        }
    }
    
    @IBInspectable public var circleLineWidthRatio: CGFloat {
        get {
            return foregroundArcView.circleLineWidthRatio
        }
        set {
            foregroundArcView.circleLineWidthRatio = newValue
            backgroundArcView.circleLineWidthRatio = newValue
        }
    }
    
    @IBInspectable public var circleCenterRatio: CGPoint {
        get {
            return foregroundArcView.circleCenterRatio
        }
        set {
            foregroundArcView.circleCenterRatio = newValue
            backgroundArcView.circleCenterRatio = newValue
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
    
    /// 描画の終了角度
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
        backgroundArcView.shouldAnimate = false
        foregroundArcView.layer.transform = matrixRotateZ(0)
        backgroundArcView.layer.transform = matrixRotateZ(-angleDifference)
        circleRadiusRatio = 0.45
        circleLineWidthRatio = 0.05
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
    /// rotate the
    public func startRotation(duration: TimeInterval) {
        print("startRotation", Date(), foregroundArcView.layer.transform)
        guard foregroundArcView.layer.animation(forKey: "rotate") == nil else { return }
        isRotating = true
        
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
    }
    public func stopRotation() {
        isRotating = false
        foregroundArcView.layer.transform = foregroundArcView.layer.presentation()!.transform
        backgroundArcView.layer.transform = backgroundArcView.layer.presentation()!.transform
        foregroundArcView.layer.removeAnimation(forKey: "rotate")
        backgroundArcView.layer.removeAnimation(forKey: "rotate")
        backgroundArcView.layer.removeAnimation(forKey: "angleDifference")
        let radian = getRadian(from: foregroundArcView.layer.transform)
        print("stop: radian= \(radian)")
    }
}



