//
//  ViewController.swift
//  TestProgressMaskView
//
//  Created by eytyet on 2020/02/13.
//  Copyright © 2020 Yu Software. All rights reserved.
//

import UIKit
import ProgressMaskView

class RandamDemoViewController: UIViewController {

    @IBOutlet weak var activityColor1View: UIView!
    @IBOutlet weak var activityColor2View: UIView!
    @IBOutlet weak var activityBlendLabel: UILabel!
    @IBOutlet weak var activityRadiusLabel: UILabel!
    @IBOutlet weak var activityWidthLabel: UILabel!

    @IBOutlet weak var progressColor1View: UIView!
    @IBOutlet weak var progressColor2View: UIView!
    @IBOutlet weak var progressBlendLabel: UILabel!
    @IBOutlet weak var progressRadiusLabel: UILabel!
    @IBOutlet weak var progressWidthLabel: UILabel!

    private var progressMaskView: ProgressMaskView?
    private var timer: Timer?
    private var progress = Float.zero
    private var random: CGFloat { .random(in: 0 ... 1) }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        startDemo()
    }

    // MARK: - Methods

    private func startDemo() {
        progressMaskView = makeProgressMaskView()
        progress = 0
        showParameters(progressMaskView!)

        let recognizer = UITapGestureRecognizer(target: self, action: #selector(onTap))
        progressMaskView?.addGestureRecognizer(recognizer)

        // start timer to proceed the progress.
        timer = Timer(timeInterval: 0.1, target: self, selector: #selector(proceed), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .default)
        timer?.fire()
    }

    private func makeProgressMaskView() -> ProgressMaskView {
        let view = ProgressMaskView()

        view.title = "Test..."
        view.activityColor1 = .random
        view.activityColor2 = .random
        view.activityBlendLevel = .random
        view.activityRadiusRatio = 0.5//random / 3 + 0.1
        view.activityWidthRatio = .random / 3 + 0.15
        view.progressColor1 = .random
        view.progressColor2 = .random
        view.progressBlendLevel = .random / 2 + 0.5
        view.progressRadiusRatio = .random / 4 + 0.25
        view.progressWidthRatio = .random / 4 + 0.25

        // Call from non-main thread to reproduce bug #3.
        DispatchQueue.global().async {
            view.install(to: self)
            view.show(in: 1.0)
        }
        return view
    }

    private func showParameters(_ view: ProgressMaskView) {
        //display
        activityColor1View.backgroundColor = view.activityColor1
        activityColor2View.backgroundColor = view.activityColor2
        activityBlendLabel.text = String(format: "%.2f", view.activityBlendLevel)
        activityRadiusLabel.text = "Radius ratio =" + String(format: "%.2f", view.activityRadiusRatio)
        activityWidthLabel.text = "Width ratio =" + String(format: "%.2f", view.activityWidthRatio)
        progressColor1View.backgroundColor = view.progressColor1
        progressColor2View.backgroundColor = view.progressColor2
        progressBlendLabel.text = String(format: "%.2f", view.progressBlendLevel)
        progressRadiusLabel.text = "Radius ratio =" + String(format: "%.2f", view.progressRadiusRatio)
        progressWidthLabel.text = "Width ratio =" + String(format: "%.2f", view.progressWidthRatio)
    }

    @objc func proceed() {
        guard let progressMaskView = progressMaskView else { return }

        progress += Float.random(in: 0 ..< 0.01)
        if progress > 1 {
            progress = 1
            progressMaskView.progress = progress
            progressMaskView.hide(in: 1.0, uninstall: true) {
                self.progressMaskView = nil
                self.startDemo()
            }
            timer?.invalidate()
            timer = nil
            return
        }
        progressMaskView.progress = progress
    }

    /// Called on tap
    @objc func onTap(_ sender: UITapGestureRecognizer) {
        progress = 1    // end current progress.
    }

}
