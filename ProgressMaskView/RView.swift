//
//  RView.swift
//  ProgressMaskView
//
//  Created by Yu Software on 2019/07/07.
//  Copyright © 2019 Yu Software. All rights reserved.
//

import Foundation
import UIKit


@IBDesignable
class RView: UIView {
    var corners: UIRectCorner = [.allCorners]
    @IBInspectable var cornerRadius: CGFloat = 10
    @IBInspectable var roundTopLeft:Bool {
        get {
            if corners.contains(.topLeft) {
                return true
            }
            return false
        }
        set {
            if newValue == true {
                corners.insert(.topLeft)
            } else {
                corners.remove(.topLeft)
            }
        }
    }
    @IBInspectable var roundTopRight:Bool {
        get {
            if corners.contains(.topRight) {
                return true
            }
            return false
        }
        set {
            if newValue == true {
                corners.insert(.topRight)
            } else {
                corners.remove(.topRight)
            }
        }
    }
    @IBInspectable var roundBottomLeft:Bool {
        get {
            if corners.contains(.bottomLeft) {
                return true
            }
            return false
        }
        set {
            if newValue == true {
                corners.insert(.bottomLeft)
            } else {
                corners.remove(.bottomLeft)
            }
        }
    }
    @IBInspectable var roundBottmRight:Bool {
        get {
            if corners.contains(.bottomRight) {
                return true
            }
            return false
        }
        set {
            if newValue == true {
                corners.insert(.bottomRight)
            } else {
                corners.remove(.bottomRight)
            }
        }
    }
    
    ///Init from code
    override init(frame: CGRect) {
        super.init(frame: frame)
        initRoundView()
    }
    /// Init from XCode
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initRoundView()
    }
    
    private func initRoundView() {
    }
    
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        self.corners = corners
        self.cornerRadius = radius
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let maskPath = UIBezierPath(roundedRect: self.bounds,
                                    byRoundingCorners: self.corners,
                                    cornerRadii: CGSize(width: self.cornerRadius, height: self.cornerRadius))
        
        let maskLayer = CAShapeLayer()
        maskLayer.frame = self.bounds
        maskLayer.path = maskPath.cgPath
        self.layer.mask = maskLayer
    }
}

