//
//  ProgressMaskView.swift
//  ProgressMaskView
//
//  Created by eytyet on 2019/07/07.
//  Copyright © 2019 Yu Software. All rights reserved.
//

import UIKit

private let pi = CGFloat.pi
private let defaultProgressColor1 = UIColor.white
private let defaultProgressColor2 = UIColor.lightGray
private let defaultProgressBlendLevel: CGFloat = 0.9
private let defaultProgressRadius: CGFloat = 0.45
private let defaultProgressWidth: CGFloat = 0.05
private let defaultActivityColor1 = UIColor.white
private let defaultActivityColor2 = UIColor.gray
private let defaultActivityBlendLevel: CGFloat = 0.4
private let defaultActivityRadius: CGFloat = 0.40
private let defaultActivityWidth: CGFloat = 0.05
private let defaultMinCircleSize: CGFloat = 200
private let titleWidthInset: CGFloat = 32
private let titleHeightInset: CGFloat = 16


/// Show activity and progress bar in circle shape.
///  Easy to append to existing view controll to let user wait tentatively.
@IBDesignable
public class ProgressMaskView : UIView {

    public enum BarType {
        case activity
        case progress
    }

    /// Text of the title label.
    @IBInspectable public var title: String {
        set { titleLabel.text = newValue }
        get { return titleLabel.text ?? "" }
    }

    /// Font of title label.
    @IBInspectable public var titleFont: UIFont {
        set { titleLabel.font = newValue }
        get { return titleLabel.font }
    }
    
    /// Color of title label.
    @IBInspectable public var titleColor: UIColor {
        set { titleLabel.textColor = newValue }
        get { return titleLabel.textColor }
    }

    /// First color of the progress circle. Default is white.
    @IBInspectable public var progressColor1: UIColor = defaultProgressColor1 {
        didSet { circleProgressView.arcColor1 = progressColor1 }
    }

    /// Second color of the progress circile. Default is lightGray.
    @IBInspectable public var progressColor2: UIColor = defaultProgressColor2 {
        didSet { circleProgressView.arcColor2 = progressColor2 }
    }

    /// Progress bar color blend ratio. 0 - 1. Default is 0.7
    @IBInspectable public var progressBlendLevel: CGFloat = defaultProgressBlendLevel {
        didSet { circleProgressView.arcGradation = progressBlendLevel }
    }

    /// Progress bar radius ratio. 0 - 0.5. Default is 0.45
    @IBInspectable public var progressRadiusRatio: CGFloat = defaultProgressRadius {
        didSet { circleProgressView.arcRadiusRatio = progressRadiusRatio }
    }
    
    /// Progress bar width ratio. 0 - 0.5. Default is 0.05
    @IBInspectable public var progressWidthRatio: CGFloat = defaultProgressWidth {
        didSet { circleProgressView.arcLineWidthRatio = progressWidthRatio }
    }
    /// Progress bar start degrerr. 0 - 360. 0 is 12:00.
    @IBInspectable public var progressZeroDegree: Float = 0 {
        didSet {
            let radian = CGFloat(progressZeroDegree - 90) * pi / 180
            circleProgressView.setInitialAngle(start: radian, end: radian)
        }
    }
    
    /// First color of activity circle. Default is white.
    @IBInspectable public var activityColor1: UIColor = defaultActivityColor1 {
        didSet { circleActivityView.arcColor1 = activityColor1 }
    }

    /// Second color of activity circle. Default is gray.
    @IBInspectable public var activityColor2: UIColor = defaultActivityColor2 {
        didSet { circleActivityView.arcColor2 = activityColor2 }
    }
    
    /// Activity color blend ratio. 0 - 1. Default is 0.4
    @IBInspectable public var activityBlendLevel: CGFloat = defaultActivityBlendLevel {
        didSet { circleActivityView.arcGradation = defaultActivityBlendLevel }
    }
    
    /// Activity radius ratio. 0 - 0.5. Default is 0.4
    @IBInspectable public var activityRadiusRatio: CGFloat = defaultActivityRadius {
        didSet { circleActivityView.arcRadiusRatio = activityRadiusRatio }
    }
    
    /// Activity width ratio. 0 - 0.5. Default is 0.05
    @IBInspectable public var activityWidthRatio: CGFloat = defaultActivityWidth {
        didSet { circleActivityView.arcLineWidthRatio = activityWidthRatio }
    }

    /// Content of progress property.
    private var _progress: CGFloat = 0
    
    /// Progress of the progress bar. 0 - 1.0. Default is 0.
    public var progress: Float {
        set {
            _progress = CGFloat(newValue)
            circleProgressView.startAngle = pi * 2 * _progress + circleProgressView.endAngle
        }
        get {
            return Float(_progress)
        }
    }
    
    /// Color of the base corner round view
    public var backgroundPlateColor: UIColor = UIColor(white: 0.6, alpha: 0.9) {
        didSet { backgroundRoundView.backgroundColor = backgroundPlateColor }
    }
    
    /// Corner round view which ha all UI parts.
    private var backgroundRoundView: SimpleRView!
    
    /// Title label shown in center of the circles.
    private var titleLabel: UILabel!
    
    /// Activity view.
    private var circleActivityView: LineArcRotateView!
    
    /// Progress view.
    private var circleProgressView: LineArcRotateView!
    
    /// Time for color animation of activity view..
    private var timer: Timer?
    
    /// Parameter to control length of activity view.
    private var animationDirection: Int = -8
    
    /// Cache of an angle unit value.
    private let angleStep = CGFloat.pi / 90

    // MARK: - UIView

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    public override func prepareForInterfaceBuilder() {
        circleProgressView.setInitialAngle(start: .pi * 1.3, end: .pi * -0.5)
        circleActivityView.setInitialAngle(start: .pi, end: .pi * 0.3)
    }

    // MARK: - Methods

    /// Create all views and set up all constraints.
    /// default value of each property did not passed to its didSet block. So call it again at here.
    private func setup() {

        alpha = 0
        isUserInteractionEnabled = true     // Disable user input.

        // Darken all area.
        backgroundColor = UIColor(white: 0, alpha: 0.7)

        // Base round view
        backgroundRoundView = SimpleRView(frame: frame)
        backgroundRoundView.cornerRadius = 32
        backgroundPlateColor = UIColor(white: 0.6, alpha: 0.9)
        addSubview(backgroundRoundView)
        backgroundRoundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundRoundView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 8),
            backgroundRoundView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -8),
            backgroundRoundView.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor, constant: 8),
            backgroundRoundView.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -8),
            backgroundRoundView.centerXAnchor.constraint(equalTo: centerXAnchor),
            backgroundRoundView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        // Progress View
        circleProgressView = LineArcRotateView(frame: frame)
        circleProgressView.setInitialAngle(start: 0, end: 0)
        circleProgressView.widthAndHeight = defaultMinCircleSize
        progressColor1 = defaultProgressColor1
        progressColor2 = defaultProgressColor2
        progressBlendLevel = defaultProgressBlendLevel
        progressRadiusRatio = defaultProgressRadius
        progressWidthRatio = defaultProgressWidth
        progressZeroDegree = 0
        backgroundRoundView.addSubview(circleProgressView)
        backgroundRoundView.addAndSetConstraint(circleProgressView, margin: 16)
        
        // Activity View
        circleActivityView = LineArcRotateView(frame: frame)
        circleActivityView.setInitialAngle(start: 0, end: 0)
        circleActivityView.widthAndHeight = defaultMinCircleSize
        activityColor1 = defaultActivityColor1
        activityColor2 = defaultActivityColor2
        activityBlendLevel = defaultActivityBlendLevel
        activityRadiusRatio = defaultActivityRadius
        activityWidthRatio = defaultActivityWidth
        backgroundRoundView.addSubview(circleActivityView)
        backgroundRoundView.addAndSetConstraint(circleActivityView, margin: 16)
        
        // Label at center.
        titleLabel = UILabel(frame: frame)
        titleLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        titleLabel.textAlignment = .center
        backgroundRoundView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(greaterThanOrEqualTo: backgroundRoundView.topAnchor, constant: titleWidthInset),
            titleLabel.bottomAnchor.constraint(greaterThanOrEqualTo: backgroundRoundView.bottomAnchor, constant: -titleWidthInset),
            titleLabel.leftAnchor.constraint(greaterThanOrEqualTo: backgroundRoundView.leftAnchor, constant: titleHeightInset),
            titleLabel.rightAnchor.constraint(lessThanOrEqualTo: backgroundRoundView.rightAnchor, constant: -titleHeightInset),
            titleLabel.centerYAnchor.constraint(equalTo: backgroundRoundView.centerYAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: backgroundRoundView.centerXAnchor)
        ])
    }

    /// Setup all parameters of activity or progress bar.
    /// - Parameters:
    ///   - bar: which bar to be set.
    ///   - parameter: parameters of the bar
    public func setParameters(bar: BarType, parameter: ProgressMaskBarParameter) {
        switch bar {
        case .activity:
            activityColor1 = parameter.color1
            activityColor2 = parameter.color2
            activityBlendLevel = parameter.blend
            activityRadiusRatio = parameter.radiusRatio
            activityWidthRatio = parameter.widthRatio
        case .progress:
            progressColor1 = parameter.color1
            progressColor2 = parameter.color2
            progressBlendLevel = parameter.blend
            progressRadiusRatio = parameter.radiusRatio
            progressWidthRatio = parameter.widthRatio
        }
    }
    
    /// Add this view onto the given view and set constraint for 4 sides.
    /// - Parameter view: Specify a parent view.
    public func install(to view: UIView) {
        view.addAndSetConstraint(self)
    }

    /// Add this view onto the given view controller and set constraint for 4 sides.
    /// This function will install this view to the UITabBarController if exist. If not, to UINavigationController. If not, to the passed controller.
    /// - Parameter controller: Specify current UIViewController. (e.g. "self")
    public func install(to controller: UIViewController) {
        if let tab = controller.tabBarController {
            tab.view.addAndSetConstraint(self)
        } else if let navi = controller.navigationController {
            navi.view.addAndSetConstraint(self)
        } else {
            controller.view.addAndSetConstraint(self)
        }
    }

    /// Appear. Must be called from the main thread.
    /// - Parameter second: Optional. Animation duration in second. Default is 0.3.
    public func showIn(second: TimeInterval = 0.3) {
        startAnimation()
        UIView.animate(withDuration: second) {
            self.alpha = 1
        }
    }

    /// Disappear. Must be called from the main thread.
    /// - Parameters:
    ///   - second: Optional. Default is 0.3. Animation duration in second.
    ///   - uninstall: Optional. Set true (default) to remove this view from the view hierarchly. If false, it is disappeared since alpha is 0 but remains in the view hierarchly.
    ///   - completion: Optional. completion handler.
    public func hideIn(second: TimeInterval = 0.3, uninstall: Bool = true, completion: (()->())? = nil) {
        UIView.animate(withDuration: second, animations: {
            self.alpha = 0
        }, completion: { _ in
            self.stopAnimation()
            if uninstall {
                self.removeFromSuperview()
            } else {
                self.progress = 0    // Prepare for next execution.
            }
            completion?()
        })
    }
    
    /// Start animation
    public func startAnimation() {
        circleActivityView.endAngle = circleActivityView.startAngle - pi / 2
        circleActivityView.startRotation(duration: 2.0)
        startTimer()
    }
    
    /// Stop animation
    public func stopAnimation() {
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
    
    /// Timer callback to control activity bar length and color.
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


