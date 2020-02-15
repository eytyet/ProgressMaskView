//
//  UIViewExtensions.swift
//  TestProgressMaskView
//
//  Created by eytyet on 2020/02/14.
//  Copyright © 2020 Yu Software. All rights reserved.
//

import UIKit

extension UIView {
    /// Add subview and set constraints with optional insets.
    public func addSubviewWithConstraints(_ view: UIView, insets: UIEdgeInsets = UIEdgeInsets.zero) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: topAnchor, constant: insets.top),
            view.centerYAnchor.constraint(equalTo: centerYAnchor, constant: (insets.top - insets.bottom) / 2),
            view.leadingAnchor.constraint(equalTo: leadingAnchor, constant: insets.left),
            view.centerXAnchor.constraint(equalTo: centerXAnchor, constant: (insets.left - insets.right) / 2)
        ])
    }

}
