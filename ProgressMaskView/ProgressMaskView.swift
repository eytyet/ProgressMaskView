//
//  ProgressMaskView.swift
//  ProgressMaskView
//
//  Created by Yu Software on 2019/07/07.
//  Copyright © 2019 Yu Software. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
public class ProgressMaskView : UIView {
    @IBInspectable public var title:String? {
        set {
            titleLabel?.text = newValue
        }
        get {
            return titleLabel?.text
        }
    }
    @IBInspectable public var progressColor1:UIColor?
    @IBInspectable public var progressColor2:UIColor?
    @IBInspectable public var motionColor1:UIColor?
    @IBInspectable public var motionColor2:UIColor?
    private var _progress: CGFloat = 0
    public var progress: Float {
        set {
            //progressView?.progress = newValue
            _progress = CGFloat(newValue)
            circleProgressView.endAngle = (CGFloat.pi * 2) * _progress - CGFloat.pi / 2
        }
        get {
            return Float(_progress)//progressView?.progress ?? 0
        }
    }
    private var roundBackgroundView: SimpleRView!
    private var titleLabel: UILabel!
    //private var activityView: UIActivityIndicatorView!
    //private var progressView: UIProgressView!
    private var circleView: LineCircleView!
    private var circleProgressView:LineCircleView!

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
        circleView.circleForColor = UIColor.init(red: 0.9, green: 0.5, blue: 1.0, alpha: 0.9)
        circleView.circleBackColor = UIColor.init(red: 0.5, green: 0.9, blue: 1.0, alpha: 0.8)
        roundBackgroundView.addSubview(circleView)
        circleView.translatesAutoresizingMaskIntoConstraints = false
        topConstraint = NSLayoutConstraint(item: circleView, attribute: .top, relatedBy: .equal, toItem: roundBackgroundView, attribute: .top, multiplier: 1, constant: 16)
        bottomConstraint = NSLayoutConstraint(item: roundBackgroundView, attribute: .bottom, relatedBy: .equal, toItem: circleView, attribute: .bottom, multiplier: 1, constant: 16)
        leftConstraint = NSLayoutConstraint(item: circleView, attribute: .left, relatedBy: .equal, toItem: roundBackgroundView, attribute: .left, multiplier: 1, constant: 16)
        rightConstraint = NSLayoutConstraint(item: roundBackgroundView, attribute: .right, relatedBy: .equal, toItem: circleView, attribute: .right, multiplier: 1, constant: 16)
        roundBackgroundView.addConstraints([topConstraint, bottomConstraint, leftConstraint, rightConstraint])
        
        circleProgressView = LineCircleView()
        circleProgressView.circleForColor = UIColor.init(red: 0.8, green: 0.8, blue: 1.0, alpha: 1)
        circleProgressView.circleBackColor = UIColor.init(red: 0.9, green: 0.9, blue: 1.0, alpha: 1)
        circleProgressView.startAngle = -CGFloat.pi / 2
        circleProgressView.endAngle = -CGFloat.pi / 2
        roundBackgroundView.addSubview(circleProgressView)
        circleProgressView.translatesAutoresizingMaskIntoConstraints = false
        topConstraint = NSLayoutConstraint(item: circleProgressView, attribute: .top, relatedBy: .equal, toItem: roundBackgroundView, attribute: .top, multiplier: 1, constant: 16)
        bottomConstraint = NSLayoutConstraint(item: roundBackgroundView, attribute: .bottom, relatedBy: .equal, toItem: circleProgressView, attribute: .bottom, multiplier: 1, constant: 16)
        leftConstraint = NSLayoutConstraint(item: circleProgressView, attribute: .left, relatedBy: .equal, toItem: roundBackgroundView, attribute: .left, multiplier: 1, constant: 16)
        rightConstraint = NSLayoutConstraint(item: roundBackgroundView, attribute: .right, relatedBy: .equal, toItem: circleProgressView, attribute: .right, multiplier: 1, constant: 16)

        
        titleLabel = UILabel(frame: frame)
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.textAlignment = .center
        roundBackgroundView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        //topConstraint = NSLayoutConstraint(item: titleLabel!, attribute: .top, relatedBy: .equal, toItem: roundBackgroundView, attribute: .top, multiplier: 1, constant: 32)
        leftConstraint = NSLayoutConstraint(item: titleLabel!, attribute: .left, relatedBy: .equal, toItem: roundBackgroundView, attribute: .left, multiplier: 1, constant: 16)
        rightConstraint = NSLayoutConstraint(item: roundBackgroundView!, attribute: .right, relatedBy: .equal, toItem: titleLabel, attribute: .right, multiplier: 1, constant: 16)
        roundBackgroundView.addConstraints([leftConstraint, rightConstraint])
        titleLabel.centerYAnchor.constraint(equalTo: roundBackgroundView.centerYAnchor).isActive = true
        
        /*activityView = UIActivityIndicatorView(style: .whiteLarge)
        roundBackgroundView.addSubview(activityView)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        topConstraint = NSLayoutConstraint(item: activityView!, attribute: .top, relatedBy: .equal, toItem: titleLabel, attribute: .bottom, multiplier: 1, constant: 16)
        roundBackgroundView.addConstraints([topConstraint])
        roundBackgroundView.centerXAnchor.constraint(equalTo: activityView.centerXAnchor).isActive = true
        
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.trackTintColor = UIColor(white: 0.4, alpha: 1)
        roundBackgroundView.addSubview(progressView)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        topConstraint = NSLayoutConstraint(item: progressView!, attribute: .top, relatedBy: .equal, toItem: activityView, attribute: .bottom, multiplier: 1, constant: 32)
        bottomConstraint = NSLayoutConstraint(item: roundBackgroundView!, attribute: .bottom, relatedBy: .equal, toItem: progressView, attribute: .bottom, multiplier: 1, constant: 32)
        leftConstraint = NSLayoutConstraint(item: progressView!, attribute: .left, relatedBy: .equal, toItem: roundBackgroundView, attribute: .left, multiplier: 1, constant: 16)
        rightConstraint = NSLayoutConstraint(item: roundBackgroundView!, attribute: .right, relatedBy: .equal, toItem: progressView, attribute: .right, multiplier: 1, constant: 16)
        roundBackgroundView.addConstraints([topConstraint, bottomConstraint, leftConstraint, rightConstraint])
        */
        
    }
    /// add myself to the given view and set constraint for 4 edges.
    public func install(to view: UIView) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 0)
        let bottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
        let leftConstraint = NSLayoutConstraint(item: self, attribute: .left, relatedBy: .equal, toItem: view, attribute: .left, multiplier: 1, constant: 0)
        let rightConstraint = NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 1, constant: 0)
        view.addConstraints([topConstraint, bottomConstraint, leftConstraint, rightConstraint])
    }
    /// start animation
    public func startAnimation() {
        //activityView?.startAnimating()
        circleView.startRotation(duration: 2.0)
    }
    /// stop animation
    public func stopAnnimation() {
        //activityView.stopAnimating()
        circleView.stopRotation()
    }
}


