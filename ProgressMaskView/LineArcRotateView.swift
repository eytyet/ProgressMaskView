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
    @IBInspectable public var widthAndHeight: CGFloat = 200 {
        didSet {
            backgroundArcView.widthAndHeight = widthAndHeight
            foregroundArcView.widthAndHeight = widthAndHeight
            setNeedsLayout()
        }
    }
    @IBInspectable public var autoFitInside: Bool = true {
        didSet {
            setNeedsDisplay()
        }
    }
    @IBInspectable public var circleRadiusRatio: CGFloat = 0.45 {
        didSet {
            backgroundArcView.circleRadiusRatio = circleRadiusRatio
            foregroundArcView.circleRadiusRatio = circleRadiusRatio
        }
    }
    @IBInspectable public var circleLineWidthRatio: CGFloat = 0.03 {
        didSet {
            backgroundArcView.circleLineWidthRatio = circleLineWidthRatio
            foregroundArcView.circleLineWidthRatio = circleLineWidthRatio
        }
    }
    @IBInspectable public var circleCenterRatio: CGPoint = CGPoint(x: 0.5, y: 0.5) {
        didSet {
            backgroundArcView.circleCenterRatio = circleCenterRatio
            foregroundArcView.circleCenterRatio = circleCenterRatio
        }
    }
    @IBInspectable public var lineGradation: CGFloat = 1.0 {
        didSet {
            backgroundArcView.lineGradation = lineGradation
            foregroundArcView.lineGradation = lineGradation
        }
    }
    /// Front color
    @IBInspectable public var circleForColor: UIColor = UIColor.white {
        didSet {
            UIView.animate(withDuration: 0.1) {
                self.foregroundArcView.backgroundColor = self.circleForColor
            }
        }
    }
    /// 混色の背面の色
    @IBInspectable public var circleBackColor: UIColor = UIColor.black {
        didSet {
            UIView.animate(withDuration: 0.1) {
                self.backgroundArcView.backgroundColor = self.circleBackColor
            }
        }
    }
    /// 描画の開始角度
    @IBInspectable public var startAngle:CGFloat = 0 {
        didSet {
            backgroundArcView.startAngle = startAngle
            foregroundArcView.startAngle = startAngle
        }
    }
    /// 描画の終了角度
    @IBInspectable public var endAngle:CGFloat = CGFloat.pi * 2 {
        didSet {
            backgroundArcView.endAngle = endAngle
            foregroundArcView.endAngle = endAngle
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
    private func setup() {
        addSubview(backgroundArcView)
        addSubview(foregroundArcView)
        setupConstraint(view: backgroundArcView)
        setupConstraint(view: foregroundArcView)
        foregroundArcView.endAngle = CGFloat.pi / 2
        backgroundArcView.endAngle = CGFloat.pi / 2
        //startRotation(duration: 1.0)
        let constraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1, constant: 0)
        self.addConstraint(constraint)
        self.backgroundColor = UIColor.clear
        layer.transform = CATransform3DMakeRotation(CGFloat.pi, 0, 0, 1)

    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return CGSize(width: widthAndHeight, height: widthAndHeight)
    }
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: widthAndHeight, height: widthAndHeight)
    }
    
    // MARK: - Methods
    public func startRotation(duration: CGFloat) {
        print("startRotation", Date())
        guard layer.animation(forKey: "rotate") == nil else { print(" guarded.");return }
        isRotating = true
        backgroundArcView.sholdAnimate = true
        foregroundArcView.sholdAnimate = true
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
        backgroundArcView.sholdAnimate = false
        foregroundArcView.sholdAnimate = false
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



