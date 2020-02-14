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
        
        // Check getRadian function
        func check(_ radian: CGFloat) {
            let a = matrixRotateZ(Float(radian))
            let b = getRadian(from: a)
            let int = Int(b / Float.pi)
            let result = radian - CGFloat(int) * CGFloat.pi
            let diff = abs(result - radian)//.truncatingRemainder(dividingBy: CGFloat.pi)
            XCTAssertTrue(diff < 0.000001, "Fail on \(radian) radian. atan=\(b).  diff=\(diff)" )
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
        
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
