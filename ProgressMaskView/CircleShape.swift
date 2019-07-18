//
//  CircleShape.swift
//  ProgressMaskView
//
//  Created by Yu Software on 2019/07/17.
//  Copyright © 2019 Yu Software. All rights reserved.
//

import UIKit

/// Protocol for a view of circle shape
///  Width and height is the same.
public protocol CircleShape {
    /// Set length of width and height of the view.
    var widthAndHeight: CGFloat { get set }
    /// When true, it automatically reduce circle size to fit into the bound size.
    var autoFitInside: Bool { get set }
    /// Set radius of the circle as a ratio against widthAndHeight. 0 - 0.5. 0.5 is largest.
    var circleRadiusRatio: CGFloat { get set }
    /// widthAndHeight * circleRadiusRatio.
    var circleRadius: CGFloat { get }
    /// Set width of the line of circumference as a ratio against widthAndHeight.
    var circleLineWidthRatio: CGFloat { get set }
    /// widthAndHeight * circleLineWidthRatio.
    var circleLineWidth: CGFloat { get }
    /// Set center point of the circle in the view as a ratio against widthAndHeight. Center is (0.5, 0.5)
    var circleCenterRatio: CGPoint { get set }
    /// Center of the circle.
    var circleCenter: CGPoint { get }
    /// Gradation to clear of the line color. 0 - 1. 0 is no gradation.
    var arcGradation: CGFloat { get set }
    /// Blend ratio at clockwise side of the line. 0 - 1.
    var startAngle: CGFloat { get set }
    /// Clockwise side of line. In radian.
    var endAngle: CGFloat { get set }
}

/// Default implementations
extension CircleShape where Self: UIView {
    public var circleRadius: CGFloat {
        return widthAndHeight * circleRadiusRatio * circleRadiusRatio * 2 / (circleRadiusRatio*2 + circleLineWidthRatio)
    }
    public var circleLineWidth: CGFloat {
        return widthAndHeight * circleLineWidthRatio * circleRadiusRatio * 2 / (circleRadiusRatio*2 + circleLineWidthRatio)
    }
    public var circleCenter: CGPoint {
        let minLength = min(bounds.width, bounds.height)
        return CGPoint(x: minLength * circleCenterRatio.x, y: minLength * circleCenterRatio.y )
    }
}
