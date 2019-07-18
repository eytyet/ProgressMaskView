//
//  Tools.swift
//  ProgressMaskView
//
//  Created by Yu Software on 2019/07/17.
//  Copyright © 2019 Yu Software. All rights reserved.
//

import Foundation

/// Create rotation matrix for Z rotation.
func matrixRotateZ(_ radian:CGFloat) -> CATransform3D {
    return CATransform3DMakeRotation(radian, 0, 0, 1)
}

/// Return rotation angle in radian for matrixRotateZ.
///  Note that the value may be 0 or 3.14... or 6.28... for 0 degree.
func getRadian(from transform:CATransform3D) -> Float {
    let cos = transform.m11
    let sin = transform.m12
    let radian = atan(sin/cos)
    if cos < 0 {
        return Float(radian) + Float.pi
    }
    return Float(radian)
}


extension UIView {
    /// Add sub view and set the same constraints for 4 edges
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
