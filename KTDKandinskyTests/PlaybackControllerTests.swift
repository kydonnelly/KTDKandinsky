//
//  PlaybackControllerTests.swift
//  KTDKandinskyTests
//
//  Created by Kyle Donnelly on 5/25/21.
//

import XCTest
@testable import KTDKandinsky

class TestPlayable: Playable {
    var frame: CGRect
    var scheme: Scheme
    var instrument: Instrument
    
    var playCount: Int = 0
    
    init(frame: CGRect = .zero, scheme: Scheme = .dumguitar, instrument: Instrument = .voice) {
        self.frame = frame
        self.scheme = scheme
        self.instrument = instrument
    }
    
    func didPlay(beat: TimeInterval) {
        self.playCount += 1
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
        let from: TimeInterval = 0.1
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
        let from: TimeInterval = 0.01
        let to: TimeInterval = 0.02
        
        // Test
        let result = controller.playChords(from: from, to: to)
        
        // Verify
        XCTAssertEqual(result?.count, 0)
    }
    
    func test_playChords_acrossHit() throws {
        // Setup
        let playable = TestPlayable()
        let controller = PlaybackController(playables: [playable])
        let from: TimeInterval = 0.0
        let to: TimeInterval = 0.4
        
        // Test
        let result = controller.playChords(from: from, to: to)
        
        // Verify
        XCTAssertEqual(result?.count, 1)
        XCTAssertEqual(playable.playCount, 1)
    }
    
    func test_playChords_threeVocals() throws {
        // Setup
        let playables = [TestPlayable(scheme: .dumguitar),
                         TestPlayable(scheme: .laachoir),
                         TestPlayable(scheme: .beebop)]
        let controller = PlaybackController(playables: playables)
        let from: TimeInterval = 0.0
        let to: TimeInterval = 0.4
        
        // Test
        let result = controller.playChords(from: from, to: to)
        
        // Verify
        XCTAssertEqual(result?.count, 1)
        for playable in playables {
            XCTAssertEqual(playable.playCount, 1)
        }
    }
    
    func test_playChords_oneChordThreeScales() throws {
        // Setup
        let playables = [TestPlayable(frame: CGRect(x: 0, y: 0, width: 0, height: 0), scheme: .dumguitar),
                         TestPlayable(frame: CGRect(x: 0, y: 1, width: 0, height: 0), scheme: .laachoir),
                         TestPlayable(frame: CGRect(x: 0, y: 2, width: 0, height: 0), scheme: .beebop)]
        let controller = PlaybackController(playables: playables)
        let from: TimeInterval = 0
        let to: TimeInterval = 0.4
        
        // Test
        let result = controller.playChords(from: from, to: to)
        
        // Verify
        XCTAssertEqual(result?.count, 1)
        for playable in playables {
            XCTAssertEqual(playable.playCount, 1)
        }
    }
    
    func test_playChords_threeChordsTwoScales() throws {
        // Setup
        let playables = [TestPlayable(frame: CGRect(x: 0, y: 0, width: 0, height: 0), scheme: .dumguitar),
                         TestPlayable(frame: CGRect(x: 0, y: 1, width: 0, height: 0), scheme: .laachoir),
                         TestPlayable(frame: CGRect(x: 1, y: 2, width: 0, height: 0), scheme: .beebop),
                         TestPlayable(frame: CGRect(x: 1, y: 4, width: 0, height: 0), scheme: .mallety, instrument: .pluck),
                         TestPlayable(frame: CGRect(x: 2, y: 1, width: 0, height: 0), scheme: .laachoir),
                         TestPlayable(frame: CGRect(x: 2, y: 3, width: 0, height: 0), scheme: .funk, instrument: .pluck)]
        let controller = PlaybackController(playables: playables)
        let from: TimeInterval = 0.8
        let to: TimeInterval = 1.3
        
        // Test
        let result = controller.playChords(from: from, to: to)
        
        // Verify
        XCTAssertEqual(result?.count, 1)
        XCTAssertEqual(playables[0].playCount, 0)
        XCTAssertEqual(playables[1].playCount, 0)
        XCTAssertEqual(playables[2].playCount, 0)
        XCTAssertEqual(playables[3].playCount, 0)
        XCTAssertEqual(playables[4].playCount, 1)
        XCTAssertEqual(playables[5].playCount, 1)
        waitForSound()
    }
    
}
