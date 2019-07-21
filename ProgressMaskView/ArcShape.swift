//
//  ArcShape.swift
//  ProgressMaskView
//
//  Created by Yu Software on 2019/07/17.
//  Copyright © 2019 Yu Software. All rights reserved.
//

import UIKit

/// Protocol for a view of arc shape
///  Width and height is the same.
public protocol ArcShape {
    /// Set length of width and height of the view.
    var widthAndHeight: CGFloat { get set }
    /// When true, it automatically reduce arc size to fit into the bound size.
    var autoFitInside: Bool { get set }
    /// Set radius of the arc as a ratio against widthAndHeight. 0 - 0.5. 0.5 is largest.
    var arcRadiusRatio: CGFloat { get set }
    /// widthAndHeight * arcRadiusRatio.
    var arcRadius: CGFloat { get }
    /// Set width of the line of circumference as a ratio against widthAndHeight.
    var arcLineWidthRatio: CGFloat { get set }
    /// widthAndHeight * arcLineWidthRatio.
    var arcLineWidth: CGFloat { get }
    /// Set center point of the arc in the view as a ratio against widthAndHeight. Center is (0.5, 0.5)
    var arcCenterRatio: CGPoint { get set }
    /// Center of the arc.
    var arcCenter: CGPoint { get }
    /// Gradation to clear of the line color. 0 - 1. 0 is no gradation.
    var arcGradation: CGFloat { get set }
    /// Blend ratio at clockwise side of the line. 0 - 1.
    var startAngle: CGFloat { get set }
    /// Clockwise side of line. In radian.
    var endAngle: CGFloat { get set }
}

/// Default implementations
extension ArcShape where Self: UIView {
    
    /// Radius of arc. Rasius is from the center of circle to the center of line width.
    /// Keep (arcRadiusRatio + arcLineWidthRatio) < 0.5.
    public var arcRadius: CGFloat {
        return widthAndHeight * arcRadiusRatio * arcRadiusRatio * 2 / (arcRadiusRatio*2 + arcLineWidthRatio)
    }
    
    /// Line width.
    public var arcLineWidth: CGFloat {
        return widthAndHeight * arcLineWidthRatio * arcRadiusRatio * 2 / (arcRadiusRatio*2 + arcLineWidthRatio)
    }
    
    /// Center position.
    public var arcCenter: CGPoint {
        let minLength = min(bounds.width, bounds.height)
        return CGPoint(x: minLength * arcCenterRatio.x, y: minLength * arcCenterRatio.y )
    }
}
