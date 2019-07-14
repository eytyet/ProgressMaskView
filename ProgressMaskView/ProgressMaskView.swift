//
//  ProgressMaskView.swift
//  ProgressMaskView
//
//  Created by Yu Software on 2019/07/07.
//  Copyright © 2019 Yu Software. All rights reserved.
//

import Foundation
import UIKit

private let pi = CGFloat.pi

@IBDesignable
public class ProgressMaskView : UIView {
    @IBInspectable public var title: String? {
        set { titleLabel?.text = newValue }
        get { return titleLabel?.text }
    }
    @IBInspectable public var progressColor1: UIColor = UIColor.white {
        didSet { circleProgressView.circleForColor = progressColor1 }
    }
    @IBInspectable public var progressColor2: UIColor = UIColor.white {
        didSet { circleProgressView.circleBackColor = progressColor2 }
    }
    @IBInspectable public var motionColor1: UIColor = UIColor.white {
        didSet { circleView.circleForColor = motionColor1 }
    }
    @IBInspectable public var motionColor2: UIColor = UIColor.gray {
        didSet { circleView.circleBackColor = motionColor2 }
    }
    private var _progress: CGFloat = 0
    public var progress: Float {
        set {
            _progress = CGFloat(newValue)
            circleProgressView.endAngle = (pi * 2) * _progress - pi / 2
        }
        get {
            return Float(_progress)
        }
    }
    private var roundBackgroundView: SimpleRView!
    private var titleLabel: UILabel!
    private var circleView: LineCircleView!
    private var circleProgressView: LineCircleView!
    private var timer:Timer?

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    /// Create all parts and set all constraints.
    private func setup() {
        self.backgroundColor = UIColor(white: 0, alpha: 0.7)

        roundBackgroundView = SimpleRView(frame: frame)
        roundBackgroundView.cornerRadius = 32
        roundBackgroundView.backgroundColor = UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 0.9)
        self.addSubview(roundBackgroundView)
        roundBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        var topConstraint = NSLayoutConstraint(item: roundBackgroundView!, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: self, attribute: .top, multiplier: 1, constant: 8)
        var bottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: roundBackgroundView, attribute: .bottom, multiplier: 1, constant: 8)
        var leftConstraint = NSLayoutConstraint(item: roundBackgroundView!, attribute: .left, relatedBy: .greaterThanOrEqual, toItem: self, attribute: .left, multiplier: 1, constant: 8)
        var rightConstraint = NSLayoutConstraint(item: self, attribute: .right, relatedBy: .greaterThanOrEqual, toItem: roundBackgroundView, attribute: .right, multiplier: 1, constant: 8)
        self.addConstraints([topConstraint, bottomConstraint, leftConstraint, rightConstraint])
        roundBackgroundView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        roundBackgroundView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        circleView = LineCircleView(frame: frame)
        motionColor1/*circleView.circleForColor*/ = UIColor.init(red: 0.3, green: 0.6, blue: 0.9, alpha: 0.9)
        motionColor2/*circleView.circleBackColor*/ = UIColor.init(red: 0.5, green: 0.7, blue: 1.0, alpha: 0.5)
        circleView.startAngle = pi / 2
        circleView.endAngle = pi / 2
        circleView.viewSize = 200
        roundBackgroundView.addSubview(circleView)
        setupConstraints(parentView: roundBackgroundView, childView: circleView, margin: 16)
        
        circleProgressView = LineCircleView()
        progressColor1/*circleProgressView.circleForColor*/ = UIColor.init(red: 0.3, green: 0.8, blue: 5.0, alpha: 1)
        progressColor2/*circleProgressView.circleBackColor*/ = UIColor.init(red: 0.5, green: 0.9, blue: 7.0, alpha: 1)
        circleProgressView.startAngle = -pi / 2
        circleProgressView.endAngle = -pi / 2
        circleProgressView.circleRadiusRatio = 0.38
        circleProgressView.viewSize = 200
        roundBackgroundView.addSubview(circleProgressView)
        setupConstraints(parentView: roundBackgroundView, childView: circleView, margin: 16)
        
        titleLabel = UILabel(frame: frame)
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.textAlignment = .center
        roundBackgroundView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        topConstraint = NSLayoutConstraint(item: titleLabel!, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: roundBackgroundView, attribute: .top, multiplier: 1, constant: 32)
        bottomConstraint = NSLayoutConstraint(item: roundBackgroundView!, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 32)
        leftConstraint = NSLayoutConstraint(item: titleLabel!, attribute: .left, relatedBy: .equal, toItem: roundBackgroundView, attribute: .left, multiplier: 1, constant: 16)
        rightConstraint = NSLayoutConstraint(item: roundBackgroundView!, attribute: .right, relatedBy: .equal, toItem: titleLabel, attribute: .right, multiplier: 1, constant: 16)
        roundBackgroundView.addConstraints([topConstraint, bottomConstraint, leftConstraint, rightConstraint])
        titleLabel.centerYAnchor.constraint(equalTo: roundBackgroundView.centerYAnchor).isActive = true
        
    }
    /// Add constraints fot 4 edges
    private func setupConstraints(parentView: UIView, childView: UIView, margin:CGFloat) {
        childView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: childView, attribute: .top, relatedBy: .equal, toItem: parentView, attribute: .top, multiplier: 1, constant: margin)
        let bottomConstraint = NSLayoutConstraint(item: parentView, attribute: .bottom, relatedBy: .equal, toItem: childView, attribute: .bottom, multiplier: 1, constant: margin)
        let leftConstraint = NSLayoutConstraint(item: childView, attribute: .left, relatedBy: .equal, toItem: parentView, attribute: .left, multiplier: 1, constant: margin)
        let rightConstraint = NSLayoutConstraint(item: parentView, attribute: .right, relatedBy: .equal, toItem: childView, attribute: .right, multiplier: 1, constant: margin)
        parentView.addConstraints([topConstraint, bottomConstraint, leftConstraint, rightConstraint])
    }
    /// Add this view onto the given view and set constraint for 4 edges.
    public func install(to view: UIView) {
        view.addSubview(self)
        setupConstraints(parentView: view, childView: self, margin: 0)
    }
    /// start animation
    public func startAnimation() {
        //activityView?.startAnimating()
        circleView.endAngle = pi
        circleView.startRotation(duration: 1.0)
        startTimer()
    }
    /// stop animation
    public func stopAnnimation() {
        //activityView.stopAnimating()
        stopTimer()
        circleView.stopRotation()
    }
    private func startTimer() {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timerFunc), userInfo: nil, repeats: true)
    }
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    @objc func timerFunc() {
        if circleProgressView.endAngle == pi {
            print("pi/2")
            circleProgressView.endAngle = pi / 2
        } else {
            print("pi")
            circleProgressView.endAngle = pi
        }
    }
}


