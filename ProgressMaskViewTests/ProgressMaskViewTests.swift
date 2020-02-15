//
//  ProgressMaskViewTests.swift
//  ProgressMaskViewTests
//
//  Created by eytyet on 2019/07/07.
//  Copyright © 2019 Yu Software. All rights reserved.
//

import XCTest
@testable import ProgressMaskView

class ProgressMaskViewTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTools() {
        
        // Check matrixRotateZ and convertRotationZToRadian function
        func check(_ radian: CGFloat) {
            let a = Tool.matrixRotateZ(Float(radian))
            let b = Tool.convertRotationZToRadian(from: a)
            let diff = abs(radian - CGFloat(b))
            let remainder = diff.remainder(dividingBy: CGFloat.pi)
            XCTAssertTrue(remainder < 0.000001, "Failed. Original radian is '\(radian)'. reverted radian is '\(b)'.  diff=\(diff), remainder=\(remainder)" )
            print("diff = \(remainder)")
        }
        let dig90 = CGFloat.pi / 2
        let dig30 = CGFloat.pi / 6
        for i in -2 ... 2 {
            for j in 0 ..< 3 {
                print("Test \(90 * i + 30 * j) degree.")
                check(dig90 * CGFloat(i) + dig30 * CGFloat(j))
            }
        }
    }

    func testScopes() {
        // Check these functions are accessible or not.
        var progressMaskView = ProgressMaskView()
        progressMaskView = ProgressMaskView(frame:CGRect.zero)
        let _ = ProgressMaskView.init(coder:)
        let _ = ProgressMaskView.BarType.self
        let _ = ProgressMaskView.showIn
        let _ = ProgressMaskView.hideIn
        let _ = progressMaskView.setParameters(bar:parameter:)
        // Check properties
        let _ = progressMaskView.progress
        let _ = progressMaskView.backgroundPlateColor
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
