//
//  SimpleRView.swift
//  ProgressMaskView
//
//  Created by eytyet on 2019/07/07.
//  Copyright © 2019 Yu Software. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class SimpleRView: UIView {
    @IBInspectable var cornerRadius : CGFloat {
        get { layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
}
