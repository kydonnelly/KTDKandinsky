//
//  PlaybackControllerTests.swift
//  KTDKandinskyTests
//
//  Created by Kyle Donnelly on 5/25/21.
//

import XCTest
@testable import KTDKandinsky

struct TestPlayable: Playable {
    var frame: CGRect
    var scheme: Scheme
    var instrument: Instrument
    
    init(frame: CGRect = .zero, scheme: Scheme = .dumguitar, instrument: Instrument = .voice) {
        self.frame = frame
        self.scheme = scheme
        self.instrument = instrument
    }
}

class PlaybackControllerTests: XCTestCase {
    
    // for manual testing
    private func waitForSound() {
        let expectation = XCTestExpectation(description: "waiting")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            expectation.fulfill()
        }
        _ = XCTWaiter.wait(for: [expectation], timeout: 4)
    }
    
    func test_playChords_negativeInterval() throws {
        // Setup
        let controller = PlaybackController(playables: [TestPlayable()])
        let from: TimeInterval = 1
        let to: TimeInterval = 0
        
        // Test
        let result = controller.playChords(from: from, to: to)
        
        // Verify
        XCTAssertNil(result)
    }

    func test_playChords_noInterval() throws {
        // Setup
        let controller = PlaybackController(playables: [TestPlayable()])
        let from: TimeInterval = 0
        let to: TimeInterval = 0
        
        // Test
        let result = controller.playChords(from: from, to: to)
        
        // Verify
        XCTAssertEqual(result?.count, 0)
    }
    
    func test_playChords_sameHit() throws {
        // Setup
        let controller = PlaybackController(playables: [TestPlayable()])
        let from: TimeInterval = 1
        let to: TimeInterval = 2
        
        // Test
        let result = controller.playChords(from: from, to: to)
        
        // Verify
        XCTAssertEqual(result?.count, 0)
    }
    
    func test_playChords_acrossHit() throws {
        // Setup
        let controller = PlaybackController(playables: [TestPlayable()])
        let from: TimeInterval = 0
        let to: TimeInterval = 400
        
        // Test
        let result = controller.playChords(from: from, to: to)
        
        // Verify
        XCTAssertEqual(result?.count, 1)
    }
    
    func test_playChords_threeVocals() throws {
        // Setup
        let controller = PlaybackController(playables: [TestPlayable(scheme: .dumguitar),
                                                        TestPlayable(scheme: .laachoir),
                                                        TestPlayable(scheme: .beebop)])
        let from: TimeInterval = 0
        let to: TimeInterval = 400
        
        // Test
        let result = controller.playChords(from: from, to: to)
        
        // Verify
        XCTAssertEqual(result?.count, 1)
    }
    
    func test_playChords_oneChordThreeScales() throws {
        // Setup
        let controller = PlaybackController(playables: [TestPlayable(frame: CGRect(x: 0, y: 0, width: 0, height: 0), scheme: .dumguitar),
                                                        TestPlayable(frame: CGRect(x: 0, y: 1, width: 0, height: 0), scheme: .laachoir),
                                                        TestPlayable(frame: CGRect(x: 0, y: 2, width: 0, height: 0), scheme: .beebop)])
        let from: TimeInterval = 0
        let to: TimeInterval = 400
        
        // Test
        let result = controller.playChords(from: from, to: to)
        
        // Verify
        XCTAssertEqual(result?.count, 1)
    }
    
    func test_playChords_threeChordsTwoScales() throws {
        // Setup
        let controller = PlaybackController(playables: [TestPlayable(frame: CGRect(x: 0, y: 0, width: 0, height: 0), scheme: .dumguitar),
                                                        TestPlayable(frame: CGRect(x: 0, y: 1, width: 0, height: 0), scheme: .laachoir),
                                                        TestPlayable(frame: CGRect(x: 1, y: 2, width: 0, height: 0), scheme: .beebop),
                                                        TestPlayable(frame: CGRect(x: 1, y: 4, width: 0, height: 0), scheme: .dumguitar),
                                                        TestPlayable(frame: CGRect(x: 2, y: 1, width: 0, height: 0), scheme: .laachoir),
                                                        TestPlayable(frame: CGRect(x: 2, y: 3, width: 0, height: 0), scheme: .beebop)])
        let from: TimeInterval = 800
        let to: TimeInterval = 1300
        
        // Test
        let result = controller.playChords(from: from, to: to)
        
        // Verify
        XCTAssertEqual(result?.count, 1)
        waitForSound()
    }
    
}
