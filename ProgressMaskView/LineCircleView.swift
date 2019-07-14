//
//  LineCircleView.swift
//  ProgressMaskView
//
//  Created by Yu Software on 2019/07/13.
//  Copyright © 2019 Yu Software. All rights reserved.
//

import UIKit



public protocol CircleShape {
    /// ビューの大きさ。
    var viewSize: CGFloat { get set }
    /// 円の大きさ。0-1の割合で、0.4で全体の8割の大きさの円になる。
    var circleRadiusRatio: CGFloat { get set }
    /// 円の半径。frameの大きさにcircleRasiudRatioをかけたもの
    var circleRadius: CGFloat { get }
    /// 線の太さ。0-1の割合。
    var circleLineWidthRatio: CGFloat { get set }
    /// 線の太さ。
    var circleLineWidth: CGFloat { get }
    /// 中心点。0-1の範囲で0.5が中央。
    var circleCenterRatio: CGPoint { get set }
    /// 円の大きさ。frameの大きさにcircleCenterRatioをかけたもの
    var circleCenter: CGPoint { get }
    /// 混色の割合。0-1
    var blendStart: CGFloat { get set }
    /// 混色の割合。0-1
    var blendEnd: CGFloat { get set }
    /// 描画の開始角度
    var startAngle:CGFloat { get set }
    /// 描画の終了角度
    var endAngle:CGFloat { get set }
}

/// デフォルト実装
extension CircleShape where Self: UIView {
    public var circleRadius: CGFloat { return frame.width * circleRadiusRatio }
    public var circleLineWidth: CGFloat { return frame.width * circleLineWidthRatio }
    public var circleCenter: CGPoint {
        return CGPoint(x: frame.width * circleCenterRatio.x, y: frame.width * circleCenterRatio.y )
    }
}

/// 太い綺麗な円を描く
open class LineCircleView : UIView, CircleShape {
    private let backgroundBlendView: LineCircleMaskView
    private let foregroundBlendView: LineCircleMaskView
    private var isRotating: Bool = false
    public var viewSize: CGFloat = 300 {
        didSet {
            backgroundBlendView.viewSize = viewSize
            foregroundBlendView.viewSize = viewSize
            setNeedsDisplay()
        }
    }
    public var circleRadiusRatio: CGFloat = 0.45{
        didSet {
            backgroundBlendView.circleRadiusRatio = circleRadiusRatio
            foregroundBlendView.circleRadiusRatio = circleRadiusRatio
        }
    }
    public var circleLineWidthRatio: CGFloat = 0.01 {
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
        addSubview(backgroundBlendView)
        addSubview(foregroundBlendView)
        setupConstraint(view: backgroundBlendView)
        setupConstraint(view: foregroundBlendView)
        foregroundBlendView.blendStart = 1.0
        foregroundBlendView.blendEnd = 0.5
        foregroundBlendView.endAngle = CGFloat.pi / 2
        backgroundBlendView.blendStart = 0.2
        backgroundBlendView.blendEnd = 0.8
        backgroundBlendView.endAngle = CGFloat.pi / 2
        //startRotation(duration: 1.0)
        let constraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0)
        self.addConstraint(constraint)
        self.backgroundColor = UIColor.clear
    }
    public required init?(coder aDecoder: NSCoder) {
        //super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: viewSize, height: viewSize)
    }
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: viewSize, height: viewSize)
    }
    /*open override func draw(_ rect: CGRect) {
        super.draw(rect)
        /*guard let cg = UIGraphicsGetCurrentContext() else { return }
        cg.setFillColor(UIColor.clear.cgColor)
        cg.addPath(createPath(startAngle: 0, endAngle: pi / 2))
        cg.closePath()
        cg.setFillColor(UIColor.clear.cgColor)
        cg.drawPath(using: .eoFill)
        
        let colors:CFArray = [circleForColor.cgColor, UIColor.clear.cgColor, circleForColor.cgColor] as CFArray
        let locations:[CGFloat] = [0,0,1,1]
        let gradient = CGGradient(colorsSpace: CGColorSpace(name: CGColorSpace.displayP3), colors: colors, locations: locations)!
        cg.drawRadialGradient(gradient, startCenter: circleCenterRatio, startRadius: 0, endCenter: CGPoint(x:0, y:0), endRadius: pi/2, options: .drawsBeforeStartLocation)
        */
    }*/
    
    // MARK: - Methods
    public func startRotation(duration: CGFloat) {
        print("startRotation", Date())
        guard layer.animation(forKey: "rotate") == nil else { print(" guarded.");return }
        isRotating = true
        let anime = CABasicAnimation(keyPath: "transform.rotation.z")
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
        CATransaction.commit()
    }
    public func stopRotation() {
        isRotating = false
        //layer.removeAllAnimations()
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
    public var viewSize: CGFloat = 300 {
        didSet { setNeedsDisplay() }
    }
    public var circleRadiusRatio: CGFloat = 0.45 {
        didSet { setNeedsDisplay() }
    }
    public var circleLineWidthRatio: CGFloat = 0.04 {
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
        didSet { setNeedsDisplay() }
    }
    public var lineColor: UIColor = UIColor.white {
        didSet { setNeedsDisplay() }
    }
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open override func draw(_ rect: CGRect) {
        let mask = CAShapeLayer()
        mask.path = createPath(startAngle: startAngle, endAngle: endAngle)
        layer.mask = mask
        
        guard let cg = UIGraphicsGetCurrentContext() else { return }
        let color1 = lineColor.withAlphaComponent(blendStart).cgColor
        let color2 = lineColor.withAlphaComponent(blendEnd).cgColor
        UIGraphicsPushContext(cg)
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

