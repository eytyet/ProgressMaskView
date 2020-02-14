//
//  ProgressMaskBarParameter.swift
//  ProgressMaskView
//
//  Created by eytyet on 2020/02/13.
//  Copyright © 2020 Yu Software. All rights reserved.
//

import UIKit

public struct ProgressMaskBarParameter {
    var color1: UIColor
    var color2: UIColor
    var blend: CGFloat
    var widthRatio: CGFloat {
        didSet { widthRatio = min(max(widthRatio, 0), 0.5) }
    }
    var radiusRatio: CGFloat {
        didSet { radiusRatio = min(max(radiusRatio, 0), 0.5) }
    }
}
