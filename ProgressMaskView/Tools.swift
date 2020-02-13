//
//  Tools.swift
//  ProgressMaskView
//
//  Created by Yu Software on 2019/07/17.
//  Copyright © 2019 Yu Software. All rights reserved.
//

import Foundation

/// Keep common functions into Tool namespace
struct Tool {
    /// Create rotation matrix for Z rotation.
    /// - Parameter radian: Rotation angle in radian.
    /// - Returns: A rotation matrix.
    static func matrixRotateZ(_ radian:Float) -> CATransform3D {
        return CATransform3DMakeRotation(CGFloat(radian), 0, 0, 1)
    }
    
    /// Return rotation angle in radian for matrixRotateZ.
    ///  Note that the value may be 0 or 3.14... or 6.28... for 0 degree.
    /// - Parameter transform: Z rotation matrix
    /// - Returns: Rotation angle in radian
    static func convertRotationZToRadian(from transform:CATransform3D) -> Float {
        let cos = transform.m11
        let sin = transform.m12
        let radian = atan(sin/cos)
        if cos < 0 {
            return Float(radian) + Float.pi
        }
        return Float(radian)
    }
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
        addConstraints([
            childView.topAnchor.constraint(equalTo: topAnchor, constant: margin),
            bottomAnchor.constraint(equalTo: childView.bottomAnchor, constant: margin),
            childView.leftAnchor.constraint(equalTo: leftAnchor, constant: margin),
            rightAnchor.constraint(equalTo: childView.rightAnchor, constant: margin)
        ])
    }
}
