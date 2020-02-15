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

    func testArcShape() {
        struct Test: ArcShape {
            var widthAndHeight: CGFloat
            var autoFitInside: Bool
            var arcRadiusRatio: CGFloat
            var arcLineWidthRatio: CGFloat
            var arcCenterRatio: CGPoint
            var arcCenter: CGPoint
            var arcGradation: CGFloat
            var startAngle: CGFloat
            var endAngle: CGFloat
        }

        var a = Test(widthAndHeight: 100, autoFitInside: false, arcRadiusRatio: 0.5, arcLineWidthRatio: 0.1, arcCenterRatio: CGPoint(x: 0.5, y: 0.5), arcCenter: CGPoint(x: 50, y: 50), arcGradation: 1, startAngle: 0, endAngle: .pi)
        XCTAssert(a.arcRadius == 45)
        XCTAssert(a.arcLineWidth == 10)

        a.arcRadiusRatio = 0.4
        XCTAssert(a.arcRadius == 35)
        XCTAssert(a.arcLineWidth == 10)

        a.arcLineWidthRatio = 0.4
        XCTAssert(a.arcRadius == 20)
        XCTAssert(a.arcLineWidth == 40)

    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
