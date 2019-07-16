//
//  LineCircleView.swift
//  ProgressMaskView
//
//  Created by Yu Software on 2019/07/13.
//  Copyright © 2019 Yu Software. All rights reserved.
//

import UIKit

/// Protocol for circle view control
public protocol CircleShape {
    /// Set length of each size of the view.
    var sideLength: CGFloat { get set }
    /// Set radius of the circle as a ratio against sideLength. 0 - 0.5. 0.5 is largest.
    var circleRadiusRatio: CGFloat { get set }
    /// sideLength * circleRadiusRatio.
    var circleRadius: CGFloat { get }
    /// Set width of the line of circumference as a ratio against sideLength.
    var circleLineWidthRatio: CGFloat { get set }
    /// sideLength * circleLineWidthRatio.
    var circleLineWidth: CGFloat { get }
    /// Set center point of the circle in the view as a ratio against sideLength. Center is (0.5, 0.5)
    var circleCenterRatio: CGPoint { get set }
    /// Center of the circle.
    var circleCenter: CGPoint { get }
    /// Blend ratio at CCW side of the line. 0 - 1.
    var blendStart: CGFloat { get set }
    /// Blend ratio at clockwise side of the line. 0 - 1.
    var blendEnd: CGFloat { get set }
    /// Counter clockwise side of line. In radian.
    var startAngle:CGFloat { get set }
    /// Clockwise side of line. In radian.
    var endAngle:CGFloat { get set }
}

/// Default implementations
extension CircleShape where Self: UIView {
    public var circleRadius: CGFloat {
        return frame.width * circleRadiusRatio
    }
    public var circleLineWidth: CGFloat {
        return frame.width * circleLineWidthRatio
    }
    public var circleCenter: CGPoint {
        return CGPoint(x: frame.width * circleCenterRatio.x, y: frame.width * circleCenterRatio.y )
    }
}

/// UIView of a thick beautiful circle. Rotatable.
open class LineCircleView : UIView, CircleShape {
    private let backgroundBlendView: LineCircleMaskView
    private let foregroundBlendView: LineCircleMaskView
    private var isRotating: Bool = false
    public var sideLength: CGFloat = 300 {
        didSet {
            backgroundBlendView.sideLength = sideLength
            foregroundBlendView.sideLength = sideLength
            setNeedsDisplay()
        }
    }
    public var circleRadiusRatio: CGFloat = 0.45 {
        didSet {
            backgroundBlendView.circleRadiusRatio = circleRadiusRatio
            foregroundBlendView.circleRadiusRatio = circleRadiusRatio
        }
    }
    public var circleLineWidthRatio: CGFloat = 0.03 {
        didSet {
            backgroundBlendView.circleLineWidthRatio = circleLineWidthRatio
            foregroundBlendView.circleLineWidthRatio = circleLineWidthRatio
        }
    }
    public var circleCenterRatio: CGPoint = CGPoint(x: 0.5, y: 0.5) {
        didSet {
            backgroundBlendView.circleCenterRatio = circleCenterRatio
            foregroundBlendView.circleCenterRatio = circleCenterRatio
        }
    }
    public var blendStart: CGFloat = 0.1 {
        didSet {
            backgroundBlendView.blendStart = blendStart
            foregroundBlendView.blendStart = blendStart
        }
    }
    public var blendEnd: CGFloat = 0.9 {
        didSet {
            backgroundBlendView.blendEnd = blendEnd
            foregroundBlendView.blendEnd = blendEnd
        }
    }
    /// 混色の前面の色
    public var circleForColor: UIColor = UIColor.white {
        didSet {
            foregroundBlendView.lineColor = circleForColor
            foregroundBlendView.setNeedsDisplay()
        }
    }
    /// 混色の背面の色
    public var circleBackColor: UIColor = UIColor.black {
        didSet {
            self.backgroundBlendView.lineColor = circleBackColor
            backgroundBlendView.setNeedsDisplay()
        }
    }
    /// 描画の開始角度
    public var startAngle:CGFloat = 0 {
        didSet {
            backgroundBlendView.startAngle = startAngle
            foregroundBlendView.startAngle = startAngle
        }
    }
    /// 描画の終了角度
    public var endAngle:CGFloat = CGFloat.pi * 2 {
        didSet {
            backgroundBlendView.endAngle = endAngle
            foregroundBlendView.endAngle = endAngle
        }
    }
        
    // MARK: - UIView
    public override init(frame: CGRect) {
        backgroundBlendView = LineCircleMaskView(frame: frame)
        foregroundBlendView = LineCircleMaskView(frame: frame)
        super.init(frame: frame)
        setup()
    }
    public required init?(coder aDecoder: NSCoder) {
        let dummy = CGRect(x: 0, y: 0, width: 100, height: 100)
        backgroundBlendView = LineCircleMaskView(frame: dummy)
        foregroundBlendView = LineCircleMaskView(frame: dummy)
        super.init(coder: aDecoder)
        setup()
    }
    private func setup() {
        addSubview(backgroundBlendView)
        addSubview(foregroundBlendView)
        setupConstraint(view: backgroundBlendView)
        setupConstraint(view: foregroundBlendView)
        foregroundBlendView.blendStart = 0.7
        foregroundBlendView.blendEnd = 0.3
        foregroundBlendView.endAngle = CGFloat.pi / 2
        backgroundBlendView.blendStart = 0.2
        backgroundBlendView.blendEnd = 0.8
        backgroundBlendView.endAngle = CGFloat.pi / 2
        //startRotation(duration: 1.0)
        let constraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0)
        self.addConstraint(constraint)
        self.backgroundColor = UIColor.clear
        layer.transform = CATransform3DMakeRotation(CGFloat.pi, 0, 0, 1)

    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: sideLength, height: sideLength)
    }
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: sideLength, height: sideLength)
    }
    
    // MARK: - Methods
    public func startRotation(duration: CGFloat) {
        print("startRotation", Date())
        guard layer.animation(forKey: "rotate") == nil else { print(" guarded.");return }
        isRotating = true
        backgroundBlendView.isAnimate = true
        foregroundBlendView.isAnimate = true
        /*let anime = CABasicAnimation(keyPath: "transform.rotation.z")
        anime.duration = CFTimeInterval(duration)
        anime.fromValue = NSNumber(value: -Float.pi)
        anime.toValue = NSNumber(value: Float.pi)
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            if self.isRotating { // repeat
                self.startRotation(duration: duration)
            }
        })
        layer.add(anime, forKey: "rotate")
        CATransaction.commit()*/
    }
    public func stopRotation() {
        isRotating = false
        backgroundBlendView.isAnimate = false
        foregroundBlendView.isAnimate = false
        layer.removeAnimation(forKey: "rotate")
    }
    private func setupConstraint(view: UIView) {
        let parent = view.superview!
        view.translatesAutoresizingMaskIntoConstraints = false
        let top = NSLayoutConstraint(item: parent, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
        let bottom = NSLayoutConstraint(item: parent, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        let left = NSLayoutConstraint(item: parent, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0)
        let right = NSLayoutConstraint(item: parent, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0)
        addConstraints([top, bottom, left, right])
    }
}


/// 円周を透明で描画
open class LineCircleMaskView : UIView, CircleShape {
    private var currentEndAngle:CGFloat = 0
    private var angleStep = CGFloat.pi / 180 / 2
    private var endAngleAnimationLink:CADisplayLink?
    private let angleUnit = CGFloat.pi / 60
    public var isAnimate = false
    public var sideLength: CGFloat = 300 {
        didSet { setNeedsDisplay() }
    }
    public var circleRadiusRatio: CGFloat = 0.45 {
        didSet { setNeedsDisplay() }
    }
    public var circleLineWidthRatio: CGFloat = 0.03 {
        didSet { setNeedsDisplay() }
    }
    public var circleCenterRatio: CGPoint = CGPoint(x: 0.5, y: 0.5) {
        didSet { setNeedsDisplay() }
    }
    public var blendStart: CGFloat = 0.1 {
        didSet { setNeedsDisplay() }
    }
    public var blendEnd: CGFloat = 0.9 {
        didSet { setNeedsDisplay() }
    }
    public var startAngle: CGFloat = 0 {
        didSet { setNeedsDisplay() }
    }
    public var endAngle: CGFloat = CGFloat.pi {
        didSet {
            print("Set endAngle: From \(oldValue) to \(endAngle)")
            if isAnimate {
                currentEndAngle = oldValue
                guard endAngleAnimationLink == nil else { return }
                endAngleAnimationLink = CADisplayLink(target: self, selector: #selector(endAnime))
                endAngleAnimationLink?.add(to: .main, forMode: .default)
            } else {
                currentEndAngle = endAngle
                setNeedsDisplay()
            }
        }
    }
    /// Move one by one
    @objc func endAnime() {
        if abs(currentEndAngle - endAngle) < angleStep {
            endAngleAnimationLink?.invalidate()
            endAngleAnimationLink = nil
            return
        }
        var nextEndAngle:CGFloat = (currentEndAngle + endAngle) / 2
        if abs(nextEndAngle) > angleUnit {
            if currentEndAngle > endAngle {
                nextEndAngle = currentEndAngle + angleUnit
            } else {
                nextEndAngle = currentEndAngle - angleUnit
            }
        }
        //let nextEndAngle = (currentEndAngle + endAngle) / 2
        let anime = CABasicAnimation(keyPath: "path")
        let oldPath = createPath(startAngle: startAngle, endAngle: currentEndAngle)
        let newPath = createPath(startAngle: startAngle, endAngle: nextEndAngle)
        currentEndAngle = nextEndAngle
        anime.duration = 0.05//endAngleAnimationLink!.duration
        anime.fromValue = oldPath
        anime.toValue = newPath
        if let mask = layer.mask as? CAShapeLayer {
            CATransaction.begin()
            CATransaction.setAnimationTimingFunction(CAMediaTimingFunction.init(name: CAMediaTimingFunctionName.easeOut))
            mask.add(anime, forKey: "angle")
            mask.path = newPath
            CATransaction.commit()
        }
    }
    public var lineColor: UIColor = UIColor.white {
        didSet { setNeedsDisplay() }
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    open override func draw(_ rect: CGRect) {
        let mask = CAShapeLayer()
        mask.path = createPath(startAngle: startAngle, endAngle: endAngle)
        layer.mask = mask
        
        guard let cg = UIGraphicsGetCurrentContext() else { return }
        UIGraphicsPushContext(cg)
        let color1 = lineColor.withAlphaComponent(blendStart).cgColor
        let color2 = lineColor.withAlphaComponent(blendEnd).cgColor
        let colors = [color1, color2] as CFArray
        let points:[CGFloat] = [1,0, 0,1]
        let gradient = CGGradient(colorsSpace: CGColorSpace(name: CGColorSpace.sRGB), colors: colors, locations: points)!
        cg.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 0), end: CGPoint(x: frame.width, y: frame.height), options: [.drawsAfterEndLocation, .drawsAfterEndLocation])
        UIGraphicsPopContext()
    }
    
    /// 部分円を構成するパスを返す。
    private func createPath(startAngle:CGFloat, endAngle:CGFloat) -> CGPath {
        let shape = UIBezierPath(arcCenter: circleCenter, radius: circleRadius + circleLineWidth, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        shape.addLine(to: circlePoint(center: circleCenter, radius: circleRadius - circleLineWidth, angle: endAngle))
        shape.addArc(withCenter: circleCenter, radius: circleRadius - circleLineWidth, startAngle: endAngle, endAngle: startAngle, clockwise: false)
        shape.close()
        return shape.cgPath
    }
    /// 円上の点を返す
    private func circlePoint(center: CGPoint, radius: CGFloat, angle: CGFloat) -> CGPoint {
        let x = center.x + cos(angle) * radius
        let y = center.y + sin(angle) * radius
        return CGPoint(x: x, y: y)
    }
}

