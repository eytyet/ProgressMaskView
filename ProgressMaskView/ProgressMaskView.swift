//
//  ProgressMaskView.swift
//  ProgressMaskView
//
//  Created by Yu Software on 2019/07/07.
//  Copyright © 2019 Yu Software. All rights reserved.
//

import UIKit

fileprivate let pi = CGFloat.pi

/// Show activity and progress bar of circle shape.
///  Easy to append to existing view controll tentatively to let user wait.
@IBDesignable
public class ProgressMaskView : UIView {

    /// Set text into title label in progress bar
    @IBInspectable public var title: String? {
        set { titleLabel?.text = newValue }
        get { return titleLabel?.text }
    }

    /// First color of the progress circle
    @IBInspectable public var progressColor1: UIColor = UIColor.white {
        didSet { circleProgressView.arcColor1 = progressColor1 }
    }

    /// Second color of the progress circile
    @IBInspectable public var progressColor2: UIColor = UIColor.white {
        didSet { circleProgressView.arcColor2 = progressColor2 }
    }

    /// First color of activity circle
    @IBInspectable public var activityColor1: UIColor = UIColor.white {
        didSet { circleActivityView.arcColor1 = activityColor1 }
    }

    /// Second color of activity circle
    @IBInspectable public var activityColor2: UIColor = UIColor.gray {
        didSet { circleActivityView.arcColor2 = activityColor2 }
    }
    
    /// Progress start digree 0 to 360. 0 is 00:00. Not radian.
    public var progressStartDegree: CGFloat = 0
    
    private var _progress: CGFloat = 0
    
    /// Progress of the progress bar. 0 to 1.
    public var progress: Float {
        set {
            _progress = CGFloat(newValue)
            circleProgressView.endAngle = (pi * 2) * (_progress + progressStartDegree / 360) + pi / 2
        }
        get {
            return Float(_progress)
        }
    }
    
    /// Color of the base round view
    public var backgroundPlateColor: UIColor = UIColor(white: 0.6, alpha: 0.9) {
        didSet { backgroundRoundView.backgroundColor = backgroundPlateColor }
    }
    
    private var backgroundRoundView: SimpleRView!
    
    /// Title label shown in center of circle.
    private var titleLabel: UILabel!
    
    private var circleActivityView: LineArcRotateView!
    
    private var circleProgressView: LineArcRotateView!
    
    private var timer:Timer?
    
    private var animationDirection:Int = -8
    
    private var angleStep = CGFloat.pi / 90
    
    // MARK: - Methods

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    /// Create all views and set up all constraints.
    /// default value of each property did not passed to its didSet block. So call it again at here.
    private func setup() {

        // Darken all area.
        self.backgroundColor = UIColor(white: 0, alpha: 0.7)

        // Base round view
        backgroundRoundView = SimpleRView(frame: frame)
        backgroundRoundView.cornerRadius = 32
        backgroundPlateColor = UIColor(white: 0.6, alpha: 0.9)
        addSubview(backgroundRoundView)
        backgroundRoundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundRoundView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 8).isActive = true
        backgroundRoundView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: 8).isActive = true
        backgroundRoundView.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor, constant: 8).isActive = true
        backgroundRoundView.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: 8).isActive = true
        backgroundRoundView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        backgroundRoundView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        // Activity View
        circleActivityView = LineArcRotateView(frame: frame)
        activityColor1 = UIColor.blue//(red: 0.3, green: 0.6, blue: 0.9, alpha: 0.9)
        activityColor2 = UIColor.cyan//(red: 0.5, green: 0.7, blue: 1.0, alpha: 0.5)
        circleActivityView.setInitialAngle(start: 0, end: 0)
        circleActivityView.widthAndHeight = 200
        backgroundRoundView.addSubview(circleActivityView)
        backgroundRoundView.addAndSetConstraint(circleActivityView, margin: 16)
        
        // Progress View
        circleProgressView = LineArcRotateView(frame: frame)
        progressColor1 = UIColor.cyan//init(red: 0.3, green: 0.8, blue: 5.0, alpha: 1)
        progressColor2 = UIColor.white//init(red: 0.5, green: 0.9, blue: 7.0, alpha: 1)
        circleProgressView.setInitialAngle(start: pi / 2, end: 0)
        circleProgressView.circleRadiusRatio = 0.38
        circleProgressView.circleLineWidthRatio
        circleProgressView.widthAndHeight = 200
        backgroundRoundView.addSubview(circleProgressView)
        backgroundRoundView.addAndSetConstraint(circleProgressView, margin: 16)
        
        // Label at center.
        titleLabel = UILabel(frame: frame)
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.textAlignment = .center
        backgroundRoundView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.topAnchor.constraint(greaterThanOrEqualTo: backgroundRoundView.topAnchor, constant: 32).isActive = true
        titleLabel.bottomAnchor.constraint(greaterThanOrEqualTo: backgroundRoundView.bottomAnchor, constant: 32).isActive = true
        titleLabel.leftAnchor.constraint(greaterThanOrEqualTo: backgroundRoundView.leftAnchor, constant: 16).isActive = true
        titleLabel.rightAnchor.constraint(lessThanOrEqualTo: backgroundRoundView.rightAnchor, constant: 16).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: backgroundRoundView.centerYAnchor).isActive = true
    }
    
    /// Add this view onto the given view and set constraint for 4 sides.
    public func install(to view: UIView) {
        view.addSubview(self)
        view.addAndSetConstraint(self)
    }
    
    /// Appear. Must be called from the main thread.
    public func showIn(second: TimeInterval = 0.3) {
        startAnimation()
        UIView.animate(withDuration: second) {
            self.alpha = 1
        }
    }

    /// Disappear. Must be called from the main thread.
    public func hideIn(second: TimeInterval, uninstall: Bool) {
        UIView.animate(withDuration: second, animations: {
            self.alpha = 0
        }, completion: { _ in
            self.stopAnimation()
            if uninstall {
                self.removeFromSuperview()
            }
        })
    }
    
    /// Start animation
    public func startAnimation() {
        //activityView?.startAnimating()
        circleActivityView.endAngle = circleActivityView.startAngle - pi / 2
        circleActivityView.startRotation(duration: 2.0)
        startTimer()
    }
    
    /// Stop animation
    public func stopAnimation() {
        //activityView.stopAnimating()
        stopTimer()
        circleActivityView.stopRotation()
    }
    
    /// Start animation timer
    private func startTimer() {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(timerFunc), userInfo: nil, repeats: true)
    }
    
    /// Stop animation timer
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    
    @objc func timerFunc() {
        let center = animationDirection > 0 ? 4 : -4
        let d = angleStep * CGFloat(center - animationDirection)
        let d2 = angleStep * 4
        circleActivityView.endAngle += d + d2
        circleActivityView.startAngle += d2
        if animationDirection > 0 {
            animationDirection = animationDirection == 1 ? -8 : animationDirection - 1
        } else {
            animationDirection = animationDirection == -1 ? 8 : animationDirection + 1
        }
    }
}


