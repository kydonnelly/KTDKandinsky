//
//  WobbleTests.swift
//  KTDKandinskyTests
//
//  Created by Kyle Donnelly on 5/26/21.
//

import XCTest
@testable import KTDKandinsky

struct TestWobbler: Wobbler {
    let wobble: CGFloat = 0.5
}

class WobbleTests: XCTestCase {
    
    func test_wobble_increaseWidth() {
        // Setup
        let wobbler = TestWobbler()
        let input: TimeInterval = 0
        let initialWidth: CGFloat = 1
        var result1 = initialWidth
        var result2 = initialWidth
        
        // Test
        wobbler.wobble(t: 0, dt: input, widthIndex: 0, width1: &result1, width2: &result2)
        
        // Verify
        XCTAssertTrue(result1 > initialWidth)
        XCTAssertTrue(result2 > result1)
    }
    
    func test_wobble_decreaseWidth() {
        // Setup
        let wobbler = TestWobbler()
        let input: TimeInterval = 1.0
        let initialWidth: CGFloat = 1
        var result1 = initialWidth
        var result2 = initialWidth
        
        // Test
        wobbler.wobble(t: 0, dt: input, widthIndex: 0, width1: &result1, width2: &result2)
        
        // Verify
        XCTAssertTrue(result1 < initialWidth)
        XCTAssertTrue(result2 < result1)
    }
    
}
