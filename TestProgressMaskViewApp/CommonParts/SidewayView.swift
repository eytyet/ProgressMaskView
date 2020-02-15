//
//  SidewayView.swift
//  TestProgressMaskView
//
//  Created by eytyet on 2020/02/14.
//  Copyright © 2020 Yu Software. All rights reserved.
//

import UIKit

/// Rotate subview in right angle.
@IBDesignable
public class SidewayView: UIView {

    /// For convenience initializer
    public enum Angle {
        case clockwise
        case counterClockwise
        case upsideDown
        case normal
        var isRightAngle: Bool {
            self == .clockwise || self == .counterClockwise
        }
    }

    /// Angle of this view.
    private(set) var angle = Angle.normal

    /// Resize ratio
    private(set) var scale: CGFloat = 1.0

    /// Set for clockwise or upsideDown
    @IBInspectable var isClockwise: Bool = false {
        didSet { updateAngle() }
    }
    /// Set for couunterClockwise or upsideDown
    @IBInspectable var isCounterClockwise: Bool = false {
        didSet { updateAngle() }
    }

    /// Helper to get child view size.
    private var childSize: CGSize? { subviews.first?.intrinsicContentSize }

    /// Helper to get child view size.
    private var childView: UIView? { subviews.first }

    /// Receive size order and manage child size.
    public override var bounds: CGRect {
        get { super.bounds }
        set {
            super.bounds = newValue
            // Pass the size to child view.
            var size = newValue.size
            if angle.isRightAngle {
                swap(&size.width, &size.height)
            }
            guard let originalSize = childSize else { return }
            scale = min(size.width / originalSize.width, size.height / originalSize.height, 1)  // No enlargement
            if let child = childView {
                applyAngle(child)
            }
        }
    }

    // MARK: - Initialize

    private override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    convenience init(view: UIView, angle: Angle) {
        self.init(frame: CGRect.zero)
        switch angle {
        case .clockwise:
            isClockwise = true
            isCounterClockwise = false
        case .counterClockwise:
            isClockwise = false
            isCounterClockwise = true
        case .upsideDown:
            isClockwise = true
            isCounterClockwise = true
        case .normal:
            isClockwise = false
            isCounterClockwise = false
        }
    }

    // MARK: - UIView

    public override class var requiresConstraintBasedLayout: Bool { true }

    public override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        guard var childSize = childSize else { return size }
        if angle.isRightAngle { swap(&childSize.width, &childSize.height) }
        return childSize
    }

    /// Only one subview is allowed.
    override public func addSubview(_ view: UIView) {
        subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        super.addSubview(view)
        applyAngle(view)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        // if rotated, origin of child view is incorrectly moved. Adjust it to zero.
        if angle.isRightAngle, let child = childView {
            child.frame.origin = CGPoint.zero
        }
    }

    public override func prepareForInterfaceBuilder() {
        if let child = subviews.first {
            applyAngle(child)
        }
    }

    // MARK: - Methods

    private func updateAngle() {
        switch (isClockwise, isCounterClockwise) {
        case (true, false):
            angle = .clockwise
        case (false, true):
            angle = .counterClockwise
        case (true, true):
            angle = .upsideDown
        case (false, false):
            angle = .normal
        }
        if let view = subviews.first {
            applyAngle(view)
        }
    }

    private func applyAngle(_ view: UIView) {
        let transform = CGAffineTransform.identity.scaledBy(x: scale, y: scale)
        switch angle {
        case .normal:
            view.transform = transform
        case .upsideDown:
            view.transform = transform.rotated(by: .pi)
        case .clockwise:
            view.transform = transform.rotated(by: .pi / -2)
        case .counterClockwise:
            view.transform = transform.rotated(by: .pi / 2)
        }
        invalidateIntrinsicContentSize()
        setNeedsLayout()
    }
}
