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
open class LineArcView : UIView, ArcShape {
    
    /// Bounds at current state.
    private var currentBounds: CGRect
    
    /// Start angle of arc at current state.
    private var currentStartAngle: CGFloat = 0
    
    /// End angle of arc at current state.
    private var currentEndAngle: CGFloat = 0
    
    /// Threshold to determine whether the same angle or not.
    private let angleMinStep = CGFloat.pi / 18000
    
    /// Step of path animation.
    private let angleStep = CGFloat.pi / 90
    
    /// Timer which is syncronized to the device refresh ratio.
    private var angleAnimationLink: CADisplayLink?
    
    /// If this flag is on, angle change is animaed automatically. Default is false.
    public var shouldAnimate = false
    
    /// Offset against startAngle and endAngle
    @IBInspectable public var offsetAngle: CGFloat = 0 {
        didSet {
            (layer as! RotateLayer).offsetAngle = Float(offsetAngle)
        }
    }

    // MARK: ArcShape protocol
    
    @IBInspectable public var widthAndHeight: CGFloat = 100 {
        didSet { requestUpdate() }
    }
    
    @IBInspectable public var autoFitInside: Bool = true {
        didSet { requestUpdate() }
    }
    
    @IBInspectable public var arcRadiusRatio: CGFloat = 0.45 {
        didSet { requestUpdate() }
    }
    
    @IBInspectable public var arcLineWidthRatio: CGFloat = 0.05 {
        didSet { requestUpdate() }
    }
    
    @IBInspectable public var arcCenterRatio: CGPoint = CGPoint(x: 0.5, y: 0.5) {
        didSet { requestUpdate() }
    }
    
    @IBInspectable public var arcGradation: CGFloat = 0.5 {
        didSet { requestUpdate() }
    }
    
    @IBInspectable public var startAngle: CGFloat = 0 {
        didSet {
            if shouldAnimate {
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
    
    @IBInspectable public var endAngle: CGFloat = 0 {
        didSet {
            if shouldAnimate {
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
    
    @IBInspectable public var lineColor: UIColor = UIColor.white {
        didSet {
            requestUpdate()
        }
    }
    /// Remember size of cached information.
    private var sizeOfCachedInformatin: CGSize?
    
    /// Content of gradientMaskCache
    private var _gradientMaskCache: CGImage?
    
    /// Cache for gradient image mask.
    private var gradientMaskCache: CGImage? {
        if let size = sizeOfCachedInformatin, size.width == bounds.width || size.height == bounds.height { return _gradientMaskCache }
        sizeOfCachedInformatin = bounds.size
        let width = Int(bounds.size.width)
        let height = Int(bounds.size.height)
        let colorSpace = CGColorSpaceCreateDeviceGray()
        guard let cg = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width, space: colorSpace, bitmapInfo: 0) else {
            print("Failed to create a CGContext for a gradation mask.")
            return _gradientMaskCache
        }
        let color1 = UIColor.white
        let color2 = UIColor.white.withAlphaComponent(1 - arcGradation)
        let colors = [color1.cgColor, color2.cgColor]
        let points: [CGFloat] = [0, 1]
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceGray(), colors: colors as CFArray, locations: points) else { return _gradientMaskCache }
        cg.drawLinearGradient(gradient, start: CGPoint(x: 0, y: 0), end: CGPoint(x: bounds.width, y: 0), options: [.drawsAfterEndLocation, .drawsAfterEndLocation]) // radian 0 is backgroundColor.
        guard let maskImage = cg.makeImage() else { return _gradientMaskCache }
        let imageMask = CGImage(maskWidth: width, height: height, bitsPerComponent: 8, bitsPerPixel: 8, bytesPerRow: width, provider: maskImage.dataProvider!, decode: nil, shouldInterpolate: false)
        _gradientMaskCache = imageMask
        return _gradientMaskCache
    }
    
    /// Remember size of cached image.
    private var sizeOfFillImage: CGSize?

    /// Content of fillImageCache
    private var _fillImageCache: CGImage?

    /// A lineColor filled image. Cached
    private var fillImageCache: CGImage? {
        if let size = sizeOfCachedInformatin, size.width == bounds.width || size.height == bounds.height { return _fillImageCache }
        sizeOfFillImage = bounds.size
        let width = Int(bounds.size.width)
        let height = Int(bounds.size.height)
        guard let cg = CGContext(data: nil, width: width, height: height, bitsPerComponent: 8, bytesPerRow: width * 4, space: CGColorSpace(name: CGColorSpace.sRGB)!, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) else {
            print("Cannot create fillContext!")
            return _fillImageCache
        }
        cg.setFillColor(lineColor.cgColor)
        cg.fill(bounds)
        _fillImageCache = cg.makeImage()
        return _fillImageCache
    }

    // MARK: - UIView
    
    public override init(frame: CGRect) {
        currentBounds = frame
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented.")
    }
    private func setup() {
        backgroundColor = nil
        isOpaque = false
        //clipsToBounds = true
    }
    
    // Use RotateLayer
    open override class var layerClass : AnyClass {
        return RotateLayer.self
    }
    
    // This view wants to be widthAndHeight x widthAndHeight in size.
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: widthAndHeight, height: widthAndHeight)
    }
    
    // Fit inside if required.
    open override func layoutSubviews() {
        guard autoFitInside else { return }
        guard currentBounds.size != bounds.size else { return }
        currentBounds = frame
        let minLength = min(frame.width, frame.height)
        widthAndHeight = minLength
    }
    
    // Draw a thick arc.
    open override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let cg = UIGraphicsGetCurrentContext() else { return }

        let mask = CAShapeLayer()
        mask.path = makeArcPath(startAngle: startAngle, endAngle: endAngle)
        layer.mask = mask
        guard let fillImage = fillImageCache?.copy() else { return }
        guard let maskImage = gradientMaskCache else { return }
        guard let img = fillImage.masking(maskImage) else { return }

        cg.saveGState()
        cg.beginTransparencyLayer(auxiliaryInfo: nil)
        cg.setBlendMode(CGBlendMode.normal)
        cg.draw(img, in: rect)
        cg.clip(to: rect, mask: gradientMaskCache!)
        cg.endTransparencyLayer()
        cg.restoreGState()
    }
    
    // MARK: - Methods
    
    /// Set force redraw
    private func requestUpdate() {
        sizeOfCachedInformatin = nil
        setNeedsDisplay()
    }
    
    /// Return a closed path of a thick arc
    /// - Parameter startAngle: Radian (edge with largear number)
    /// - Parameter endAngle: Radian (edge with smaller number)
    /// - Returns: CGPath of a closed thick arc shape.
    private func makeArcPath(startAngle: CGFloat, endAngle: CGFloat) -> CGPath {
        let shape = UIBezierPath(arcCenter: arcCenter, radius: arcRadius + arcLineWidth / 2, startAngle: startAngle, endAngle: endAngle, clockwise: false)
        shape.addArc(withCenter: arcCenter, radius: arcRadius - arcLineWidth / 2, startAngle: endAngle, endAngle: startAngle, clockwise: true)
        shape.close()
        return shape.cgPath
    }
    
    /// Calculate the next angle for animation
    /// - Parameter current: Current angle in radian
    /// - Parameter final: Target angle in radian
    /// - Returns: Next angle in radian.
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
    
    /// Set path animation.
    /// - Parameter from : Start point of the animation. (Start Angle, End Angle)
    /// - Parameter to : End point of the animation. (Start Angle, End Angle)
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
    /// Automatic layer animation is not suitable for the arc length change because it affects its thickness. Set small amount of change to minimize this side effect.
    @objc func animateAngles() {
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



