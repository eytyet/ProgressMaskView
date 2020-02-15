//
//  BinaryFloatingPointExtensions.swift
//  TestProgressMaskView
//
//  Created by eytyet on 2020/02/14.
//  Copyright © 2020 Yu Software. All rights reserved.
//

import Foundation

extension BinaryFloatingPoint {
    /// Returns string description.
    func decimal(_ count: Int) -> String {
        let value = Double(self)
        return String(format: "%.\(count)f", value)
    }
}
