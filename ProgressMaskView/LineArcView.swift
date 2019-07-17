//
//  LineArcView.swift
//  ProgressMaskView
//
//  Created by Yu Software on 2019/07/17.
//  Copyright © 2019 Yu Software. All rights reserved.
//

import Foundation




/// Arc with thick line filled with two color gradation.
@IBDesignable
open class LineArcView : UIView, CircleShape {
    
    private var currentFrame: CGRect
    
    private var currentStartAngle: CGFloat = 0
    
    private var currentEndAngle: CGFloat = 0
    
    private let angleMinStep = CGFloat.pi / 18000
    
    private let angleStep = CGFloat.pi / 30
    
    private var angleAnimationLink: CADisplayLink?
    
    public var sholdAnimate = false
    
    @IBInspectable public var widthAndHeight: CGFloat = 100 {
        didSet { setNeedsDisplay() }
    }
    
    @IBInspectable public var autoFitInside: Bool = true {
        didSet { setNeedsDisplay() }
    }
    
    @IBInspectable public var circleRadiusRatio: CGFloat = 0.45 {
        didSet { setNeedsDisplay() }
    }
    
    @IBInspectable public var circleLineWidthRatio: CGFloat = 0.05 {
        didSet { setNeedsDisplay() }
    }
    
    @IBInspectable public var circleCenterRatio: CGPoint = CGPoint(x: 0.5, y: 0.5) {
        didSet { setNeedsDisplay() }
    }
    
    @IBInspectable public var lineGradation: CGFloat = 1 {
        didSet { setNeedsDisplay() }
    }
    
    @IBInspectable public var startAngle: CGFloat = 0 {
        didSet {
            if sholdAnimate {
                currentStartAngle = oldValue
                guard angleAnimationLink == nil else { return }
                angleAnimationLink = CADisplayLink(target: self, selector: #selector(animateAngles))
                angleAnimationLink?.add(to: .main, forMode: .default)
            } else {
                currentStartAngle = startAngle
                setNeedsDisplay()
            }
        }
    }
    
    @IBInspectable public var endAngle: CGFloat = CGFloat.pi {
        didSet {
            if sholdAnimate {
                currentEndAngle = oldValue
                guard angleAnimationLink == nil else { return }
                angleAnimationLink = CADisplayLink(target: self, selector: #selector(animateAngles))
                angleAnimationLink?.add(to: .main, forMode: .default)
            } else {
                currentEndAngle = endAngle
                setNeedsDisplay()
            }
        }
    }
    
    // MARK: - Methods
    
    public override init(frame: CGRect) {
        currentFrame = frame
        super.init(frame: frame)
        backgroundColor = UIColor.clear
    }
    
    public required init?(coder aDecoder: NSCoder) {
        let dummy = CGRect(x: 0, y: 0, width: 100, height: 100)  // dummy
        currentFrame = dummy
        super.init(coder: aDecoder)
        currentFrame = frame
        backgroundColor = UIColor.clear
    }
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: widthAndHeight, height: widthAndHeight)
    }
    
    // Fit inside if required.
    open override func layoutSubviews() {
        guard autoFitInside else { return }
        guard currentFrame.size != frame.size else { return }
        currentFrame = frame
        let minLength = min(frame.width, frame.height)
        widthAndHeight = minLength
    }
    
    // draw thick arc.
    open override func draw(_ rect: CGRect) {
        let mask = CAShapeLayer()
        mask.path = makeArcPath(startAngle: startAngle, endAngle: endAngle)
        layer.mask = mask
        
        guard let cg = UIGraphicsGetCurrentContext() else { return }
        UIGraphicsPushContext(cg)
        let color1 = backgroundColor!.cgColor
        let color2 = backgroundColor!.withAlphaComponent((1 - lineGradation)).cgColor
        let colors = [color1, color2] as CFArray
        let points:[CGFloat] = [1, 0.5, 0, 0.5]  // radian 0 is backgroundColor.
        let gradient = CGGradient(colorsSpace: CGColorSpace(name: CGColorSpace.sRGB), colors: colors, locations: points)!
        cg.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 0), end: CGPoint(x: frame.width, y: frame.height), options: [.drawsAfterEndLocation, .drawsAfterEndLocation])
        UIGraphicsPopContext()
    }
    
    /// Return a closed path of a thick arc
    private func makeArcPath(startAngle: CGFloat, endAngle: CGFloat) -> CGPath {
        let shape = UIBezierPath(arcCenter: circleCenter, radius: circleRadius + circleLineWidth / 2, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        shape.addArc(withCenter: circleCenter, radius: circleRadius - circleLineWidth / 2, startAngle: endAngle, endAngle: startAngle, clockwise: true)
        shape.close()
        return shape.cgPath
    }
    
    /// Calc next angle for animation
    func nextTickAngle(current: CGFloat, final: CGFloat) -> CGFloat {
        var next:CGFloat = (current + final) / 2
        if abs(next - final) > angleStep {
            if current < final {
                next = current + angleStep
            } else {
                next = current - angleStep
            }
        }
        return next
    }
    /// Set path animation. Taple is (Start Angle, End Angle) in radian.
    func executePathAnimation(from: (CGFloat, CGFloat), to: (CGFloat, CGFloat)) {
        let anime = CABasicAnimation(keyPath: "path")
        let oldPath = makeArcPath(startAngle: from.0, endAngle: from.1)
        let newPath = makeArcPath(startAngle: to.0, endAngle: to.1)
        anime.fromValue = oldPath
        anime.toValue = newPath
        anime.duration = 0.05//endAngleAnimationLink!.duration
        anime.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        if let mask = layer.mask as? CAShapeLayer {
            CATransaction.begin()
            mask.add(anime, forKey: "angle")
            mask.path = newPath
            CATransaction.commit()
        }
    }
    
    /// Move arc length step by step
    /// Automatic layer animation is not suitable for an arc length change because it changes a thickness also. Therefore, set small amount of change to minimize the effect.
    @objc func animateAngles() {
        //print("-- \(currentStartAngle) - \(currentEndAngle) --")
        if abs(currentEndAngle - endAngle) < angleMinStep && abs(currentStartAngle - startAngle) < angleMinStep {
            angleAnimationLink?.invalidate()
            angleAnimationLink = nil
            return
        }
        let nextStartAngle = nextTickAngle(current: currentStartAngle, final: startAngle)
        let nextEndAngle = nextTickAngle(current: currentEndAngle, final: endAngle)
        currentStartAngle = nextStartAngle
        currentEndAngle = nextEndAngle
        executePathAnimation(from: (currentStartAngle, currentEndAngle), to: (nextStartAngle, nextEndAngle))
    }
    

}
