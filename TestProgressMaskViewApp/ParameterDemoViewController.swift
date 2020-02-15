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

    @IBOutlet weak var activityControllerView: ParameterControlView! {
        didSet {
            activityControllerView.delegate = self
            activityControllerView.title = "Activity Bar"
            activityControllerView.setParameter(color1: .red, color2: .yellow, blendLevel: 0.5, radiusRatio: 0.5, widthRatio: 0.1)
        }
    }

    @IBOutlet weak var progressControllerView: ParameterControlView! {
        didSet {
            progressControllerView.delegate = self
            progressControllerView.title = "Progress Bar"
            progressControllerView.setParameter(color1: .blue, color2: .cyan, blendLevel: 1.0, radiusRatio: 0.4, widthRatio: 0.2)
        }
    }

    // MARK: - Private properties

    private var sampleProcess: SampleProcess?

    // MARK: - UIViewController

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startJob()
    }

    // MRAK: - Methods

    private func startJob() {
        guard sampleProcess == nil else { return }

        progressMaskView.progress = 0
        progressMaskView.setParameters(bar: .activity, parameter: activityControllerView.parameters)
        progressMaskView.setParameters(bar: .progress, parameter: progressControllerView.parameters)
        progressMaskView.showIn(second: 1.0)

        sampleProcess = SampleProcess()
        sampleProcess?.delegate = self
        sampleProcess?.startJob()
    }
}

// MARK: - Parameter Control View Delegate

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
        startJob()
    }
    
    func didBlendLevelChanged(_ parameterView: ParameterControlView, blendLevel: CGFloat) {
        if parameterView.tag == 1 {  // Activity Bar
            progressMaskView.activityBlendLevel = blendLevel
        } else {    // Progress Bar
            progressMaskView.progressBlendLevel = blendLevel
        }
        startJob()
    }
    
    func didWidthRatioChanged(_ parameterView: ParameterControlView, widthRatio: CGFloat) {
        if parameterView.tag == 1 {  // Activity Bar
            progressMaskView.activityWidthRatio = widthRatio
        } else {    // Progress Bar
            progressMaskView.progressWidthRatio = widthRatio
        }
        startJob()
    }
    
    func didRadiusRatioChanged(_ parameterView: ParameterControlView, radiusRatio: CGFloat) {
        if parameterView.tag == 1 {  // Activity Bar
            progressMaskView.activityRadiusRatio = radiusRatio
        } else {    // Progress Bar
            progressMaskView.progressRadiusRatio = radiusRatio
        }
        startJob()
    }
}

// MARK: - Sample Process Delegate

extension ParameterDemoViewController: SampleProcessDelegate {
    func notify(progress: Float) {
        progressMaskView.progress = progress
    }

    func notify(completion: Bool) {
        progressMaskView.hideIn(second: 1.0, uninstall: false) {
            self.sampleProcess = nil
        }
    }
}
