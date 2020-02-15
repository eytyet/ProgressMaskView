//
//  LineArcView.swift
//  ProgressMaskView
//
//  Created by eytyet on 2019/07/13.
//  Copyright © 2019 Yu Software. All rights reserved.
//

import UIKit


/// UIView of a thick beautiful arc. Rotatable.
@IBDesignable
open class LineArcRotateView: UIView, ArcShape {
    
    /// Arc view on front side.
    private let foregroundArcView: LineArcView
    
    /// Arc view on back side. Two arcs show beautiful colors.
    private let backgroundArcView: LineArcView
    
    /// Flag.
    private var isRotating: Bool = false
    
    /// Layer of foregroundArcView
    private var foregroundArcLayer: RotateLayer!
    
    /// Layer of backgroundArcView
    private var backgroundArcLayer: RotateLayer!
    
    /// Angle difference between front and back. Used to color change.
    public var angleDifference = CGFloat.pi / 2 {
        didSet {
            backgroundArcLayer.offsetAngle = -Float(angleDifference)
        }
    }
    
    // MRAK: ArcShape protocol
    
    /// Size of view. Only one value since it must be square
    @IBInspectable public var widthAndHeight: CGFloat {
        get { foregroundArcView.widthAndHeight }
        set {
            foregroundArcView.widthAndHeight = newValue
            backgroundArcView.widthAndHeight = newValue
        }
    }
    
    /// If true, the diameter is always smaller than widthAndHeight.
    @IBInspectable public var autoFitInside: Bool {
        get { foregroundArcView.autoFitInside }
        set {
            foregroundArcView.autoFitInside = newValue
            backgroundArcView.autoFitInside = newValue
        }
    }
    
    /// Ratio of the arc radius against widthAndHeight. 0.5 is maximum.
    @IBInspectable public var arcRadiusRatio: CGFloat {
        get { foregroundArcView.arcRadiusRatio }
        set {
            foregroundArcView.arcRadiusRatio = newValue
            backgroundArcView.arcRadiusRatio = newValue
        }
    }
    
    /// Ratio of the arc line width against widthAndHeight.
    /// If arcRadiusRatio is 0.45 and arcLineWidthRatio is 0.02, line fills 0.43-0.46.
    @IBInspectable public var arcLineWidthRatio: CGFloat {
        get { foregroundArcView.arcLineWidthRatio }
        set {
            foregroundArcView.arcLineWidthRatio = newValue
            backgroundArcView.arcLineWidthRatio = newValue
        }
    }
    
    /// Ratio of the arc center.
    @IBInspectable public var arcCenterRatio: CGPoint {
        get { foregroundArcView.arcCenterRatio }
        set {
            foregroundArcView.arcCenterRatio = newValue
            backgroundArcView.arcCenterRatio = newValue
        }
    }
    
    /// Ratio of the arc line color mix.
    @IBInspectable public var arcGradation: CGFloat {
        get { foregroundArcView.arcGradation }
        set {
            foregroundArcView.arcGradation = newValue
            backgroundArcView.arcGradation = newValue
        }
    }
    
    /// Arc line fill color 1
    @IBInspectable public var arcColor1: UIColor {
        get { foregroundArcView.lineColor }
        set { foregroundArcView.lineColor = newValue }
    }
    
    /// Arc line fill color 2
    @IBInspectable public var arcColor2: UIColor {
        get { backgroundArcView.lineColor }
        set { backgroundArcView.lineColor = newValue }
    }
    
    /// Start angle
    @IBInspectable public var startAngle: CGFloat {
        get { foregroundArcView.startAngle }
        set {
            foregroundArcView.startAngle = newValue
            backgroundArcView.startAngle = newValue + angleDifference
        }
    }
    
    /// End angle. It should be endAngle < startAngle.
    @IBInspectable public var endAngle: CGFloat {
        get { foregroundArcView.endAngle }
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
        addConstraint(squareConstraint)
        foregroundArcView.shouldAnimate = true
        backgroundArcView.shouldAnimate = true
        foregroundArcLayer = (foregroundArcView.layer as! RotateLayer)
        backgroundArcLayer = (backgroundArcView.layer as! RotateLayer)
        backgroundArcLayer.offsetAngle = -Float(angleDifference)
        arcRadiusRatio = 0.45
        arcLineWidthRatio = 0.05
        endAngle = 0
        startAngle = 0
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: widthAndHeight, height: widthAndHeight)
    }
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: widthAndHeight, height: widthAndHeight)
    }
    
    // MARK: - Methods
    
    /// Start rotate animation
    /// - Parameter duration: Time period of one rotation.
    public func startRotation(duration: TimeInterval) {
        guard isRotating == false else { return }
        isRotating = true
        foregroundArcLayer.rotate(duration: duration)
        backgroundArcLayer.rotate(duration: duration)

    }
    
    /// Stop rotate animation.
    public func stopRotation() {
        isRotating = false
        foregroundArcLayer.stopRotation()
        backgroundArcLayer.stopRotation()
    }
    
    /// Setup initial angle without animation
    /// - Parameters:
    ///   - start: Start angle of the arc in radian.
    ///   - end: End angle of the arc in radian.
    ///   - offset: Offset of angle in radian. If 0, start/end angle begin at 03:00. -pi/2 is 0:00.
    public func setInitialAngle(start: CGFloat, end: CGFloat, offset: CGFloat? = nil) {
        func setup(_ view: LineArcView, diff: CGFloat) {
            view.shouldAnimate = false
            view.startAngle = start + diff
            view.endAngle = end + diff
            if let offset = offset {
                view.offsetAngle = offset
            }
            view.shouldAnimate = true
        }
        setup(foregroundArcView, diff: 0)
        setup(backgroundArcView, diff: angleDifference)
    }
    
}





