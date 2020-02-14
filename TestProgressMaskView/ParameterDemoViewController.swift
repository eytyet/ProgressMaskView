//
//  ParameterDemoViewController.swift
//  TestProgressMaskView
//
//  Created by eytyet on 2020/02/14.
//  Copyright © 2020 Yu Software. All rights reserved.
//

import UIKit
import ProgressMaskView

class ParameterDemoViewController: UIViewController {

    @IBOutlet weak var progressMaskView: ProgressMaskView!
    @IBOutlet weak var activityControlView: ParameterControlView! {
        didSet {
            activityControlView.delegate = self
            activityControlView.title = "Activity Bar"
            activityControlView.color1View.backgroundColor = .red
            activityControlView.color2View.backgroundColor = .yellow
        }
    }

    @IBOutlet weak var progressControlerView: ParameterControlView! {
        didSet {
            progressControlerView.delegate = self
            progressControlerView.title = "Progress Bar"
            progressControlerView.color1View.backgroundColor = .blue
            progressControlerView.color2View.backgroundColor = .cyan
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        progressMaskView.showIn(second: 1.0)
        progressMaskView.progress = 0.5
    }
    

}

extension ParameterDemoViewController: ParameterControlViewDelegate {
    func didColorChanged(_ parameterView: ParameterControlView, index: Int, color: UIColor) {
        if parameterView.tag == 1 {  // Activity Bar
            if index == 1 {
                progressMaskView.activityColor1 = color
            }
            if index == 2 {
                progressMaskView.activityColor2 = color
            }
        } else {    // Progress Bar
            if index == 1 {
                progressMaskView.progressColor1 = color
            }
            if index == 2 {
                progressMaskView.progressColor2 = color
            }
        }
    }
    
    func didBlendLevelChanged(_ parameterView: ParameterControlView, blendLevel: CGFloat) {
        if parameterView.tag == 1 {  // Activity Bar
            progressMaskView.activityBlendLevel = blendLevel
        } else {    // Progress Bar
            progressMaskView.progressBlendLevel = blendLevel
        }
    }
    
    func didWidthRatioChanged(_ parameterView: ParameterControlView, widthRatio: CGFloat) {
        if parameterView.tag == 1 {  // Activity Bar
            progressMaskView.activityWidthRatio = widthRatio
        } else {    // Progress Bar
            progressMaskView.progressWidthRatio = widthRatio
        }
    }
    
    func didRadiusRatioChanged(_ parameterView: ParameterControlView, radiusRatio: CGFloat) {
        if parameterView.tag == 1 {  // Activity Bar
            progressMaskView.activityRadiusRatio = radiusRatio
        } else {    // Progress Bar
            progressMaskView.progressRadiusRatio = radiusRatio
        }
    }
    

}
