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
        backgroundRoundView.translatesAutoresizingMaskIntoConstraints = false
        var topConstraint = NSLayoutConstraint(item: backgroundRoundView!, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: self, attribute: .top, multiplier: 1, constant: 8)
        var bottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: backgroundRoundView, attribute: .bottom, multiplier: 1, constant: 8)
        var leftConstraint = NSLayoutConstraint(item: backgroundRoundView!, attribute: .left, relatedBy: .greaterThanOrEqual, toItem: self, attribute: .left, multiplier: 1, constant: 8)
        var rightConstraint = NSLayoutConstraint(item: self, attribute: .right, relatedBy: .greaterThanOrEqual, toItem: backgroundRoundView, attribute: .right, multiplier: 1, constant: 8)
        self.addSubview(backgroundRoundView)
        self.addConstraints([topConstraint, bottomConstraint, leftConstraint, rightConstraint])
        backgroundRoundView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        backgroundRoundView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        // Activity View
        circleActivityView = LineArcRotateView(frame: frame)
        activityColor1 = UIColor(red: 0.3, green: 0.6, blue: 0.9, alpha: 0.9)
        activityColor2 = UIColor(red: 0.5, green: 0.7, blue: 1.0, alpha: 0.5)
        circleActivityView.startAngle = pi / 4
        circleActivityView.endAngle = pi
        circleActivityView.widthAndHeight = 200
        backgroundRoundView.addSubview(circleActivityView)
        backgroundRoundView.addAndSetConstraint(circleActivityView, margin: 16)
        
        // Progress View
        circleProgressView = LineArcRotateView(frame: frame)
        progressColor1 = UIColor.init(red: 0.3, green: 0.8, blue: 5.0, alpha: 1)
        progressColor2 = UIColor.init(red: 0.5, green: 0.9, blue: 7.0, alpha: 1)
        circleProgressView.startAngle = pi / 2
        circleProgressView.endAngle = pi / 2
        circleProgressView.circleRadiusRatio = 0.38
        circleProgressView.widthAndHeight = 200
        backgroundRoundView.addSubview(circleProgressView)
        backgroundRoundView.addAndSetConstraint(circleProgressView, margin: 16)
        
        // Label at center.
        titleLabel = UILabel(frame: frame)
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.textAlignment = .center
        backgroundRoundView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        topConstraint = NSLayoutConstraint(item: titleLabel!, attribute: .top, relatedBy: .greaterThanOrEqual, toItem: backgroundRoundView, attribute: .top, multiplier: 1, constant: 32)
        bottomConstraint = NSLayoutConstraint(item: backgroundRoundView!, attribute: .bottom, relatedBy: .greaterThanOrEqual, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 32)
        leftConstraint = NSLayoutConstraint(item: titleLabel!, attribute: .left, relatedBy: .equal, toItem: backgroundRoundView, attribute: .left, multiplier: 1, constant: 16)
        rightConstraint = NSLayoutConstraint(item: backgroundRoundView!, attribute: .right, relatedBy: .equal, toItem: titleLabel, attribute: .right, multiplier: 1, constant: 16)
        backgroundRoundView.addConstraints([topConstraint, bottomConstraint, leftConstraint, rightConstraint])
        titleLabel.centerYAnchor.constraint(equalTo: backgroundRoundView.centerYAnchor).isActive = true
    }
    

    
    /// Add this view onto the given view and set constraint for 4 sides.
    public func install(to view: UIView) {
        view.addSubview(self)
        view.addAndSetConstraint(self)
    }
    /// Start
    public func start(showDuration: TimeInterval = 0.3) {
        startAnimation()
        UIView.animate(withDuration: showDuration) {
            self.alpha = 1
        }
    }
    /// Start animation
    public func startAnimation() {
        //activityView?.startAnimating()
        circleActivityView.endAngle = pi
        circleActivityView.startRotation(duration: 2.0)
        startTimer()
    }
    /// Stop
    public func stop(uninstall: Bool, hideDuration:TimeInterval = 0.3) {
        UIView.animate(withDuration: hideDuration, animations: {
            self.alpha = 0
        }, completion: { _ in
            if uninstall {
                self.removeFromSuperview()
            }
        })
    }
    /// Stop animation
    public func stopAnnimation() {
        //activityView.stopAnimating()
        stopTimer()
        circleActivityView.stopRotation()
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
        if circleActivityView.endAngle == pi {
            print("pi/2")
            circleActivityView.endAngle = pi / 2
        } else {
            print("pi")
            circleActivityView.endAngle = pi
        }
    }
}


