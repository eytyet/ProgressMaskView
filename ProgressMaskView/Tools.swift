//
//  Tools.swift
//  ProgressMaskView
//
//  Created by Yu Software on 2019/07/17.
//  Copyright © 2019 Yu Software. All rights reserved.
//

import Foundation

/// Create rotation matrix for Z rotation.
/// - Parameter radian: Rotation angle in radian.
/// - Returns: A rotation matrix.
func matrixRotateZ(_ radian:Float) -> CATransform3D {
    return CATransform3DMakeRotation(CGFloat(radian), 0, 0, 1)
}

/// Return rotation angle in radian for matrixRotateZ.
///  Note that the value may be 0 or 3.14... or 6.28... for 0 degree.
/// - Parameter transform: Z rotation matrix
/// - Returns: Rotation angle in radian
func getRadian(from transform:CATransform3D) -> Float {
    let cos = transform.m11
    let sin = transform.m12
    let radian = atan(sin/cos)
    if cos < 0 {
        return Float(radian) + Float.pi
    }
    return Float(radian)
}

// MARK: - UIView Extension

extension UIView {
    /// Add sub view and set the same constraints for 4 edges
    /// - Parameters:
    ///   - childView: UIView to be added as subview to this view.
    ///   - margin: Optional space between this view and subview for 4 edges. Default is 0.
    func addAndSetConstraint(_ childView: UIView, margin:CGFloat = 0) {
        addSubview(childView)
        childView.translatesAutoresizingMaskIntoConstraints = false
        let topConstraint = NSLayoutConstraint(item: childView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: margin)
        let bottomConstraint = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: childView, attribute: .bottom, multiplier: 1, constant: margin)
        let leftConstraint = NSLayoutConstraint(item: childView, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1, constant: margin)
        let rightConstraint = NSLayoutConstraint(item: self, attribute: .right, relatedBy: .equal, toItem: childView, attribute: .right, multiplier: 1, constant: margin)
        addConstraints([topConstraint, bottomConstraint, leftConstraint, rightConstraint])
    }
}
