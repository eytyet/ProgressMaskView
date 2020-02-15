//
//  SampleProcess.swift
//  TestProgressMaskViewApp
//
//  Created by Yu Software on 2020/02/15.
//  Copyright © 2020 Yu Software. All rights reserved.
//

import Foundation

/// To notify progress of the job.
protocol SampleProcessDelegate: class {
    func notify(progress: Float)
    func notify(completion: Bool)
}

/// A dummy job process proceeded by timer.
class SampleProcess {

    weak var delegate: SampleProcessDelegate?

    private let repeatInterval: TimeInterval = 0.1

    private(set) var progress: Float = 0

    private var timer: Timer?

    func startJob() {
        progress = 0
        startTimer()
    }

    func endJob() {
        endTimer()
    }

    private func startTimer() {
        guard timer == nil else { return }
        let timer = Timer(timeInterval: repeatInterval, target: self, selector: #selector(proceed), userInfo: nil, repeats: true)
        self.timer = timer
        RunLoop.main.add(timer, forMode: .default)
        timer.fire()
    }

    private func endTimer() {
        guard let timer = timer  else { return }
        timer.invalidate()
        self.timer = nil
    }

    deinit {
        endTimer()
    }

    /// Proceed the job progress
    @objc func proceed() {
        progress += Float.random(in: 0 ... 0.02 )

        if progress < 1 {
            delegate?.notify(progress: progress)
            return
        }
        endTimer()
        progress = 1
        delegate?.notify(completion: true)
    }
}
