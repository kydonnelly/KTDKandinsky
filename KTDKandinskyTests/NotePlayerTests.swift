//
//  NotePlayerTests.swift
//  KTDKandinskyTests
//
//  Created by Kyle Donnelly on 5/25/21.
//

import XCTest
@testable import KTDKandinsky

class NotePlayerTests: XCTestCase {

    func test_play_basicNote() throws {
        // Setup
        let player = NotePlayer.shared
        let note = Note(instrument: .tonal, scheme: 0, scale: 0)
        
        // Test
        let didPlay = player.play(note: note)
        
        // Verify
        XCTAssertTrue(didPlay)
    }
    
    func test_play_allGlock() throws {
        // Setup
        let player = NotePlayer.shared
        let instrument = Instrument.percussion
        let scheme = Scheme.glock
        
        var notes = [Note]()
        for scale in 0..<instrument.numScales {
            notes.append(Note(instrument: instrument, scheme: scheme, scale: scale))
        }
        
        var expectations = [XCTestExpectation]()
        
        // Test
        notes.enumerated().forEach { i, note in
            let expectation = XCTestExpectation(description: "\(i)")
            expectations.append(expectation)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(i)) {
                XCTAssertTrue(player.play(note: note))
                expectation.fulfill()
            }
        }
        
        // Verify
        XCTAssertEqual(XCTWaiter.wait(for: expectations, timeout: Double(notes.count) * 1.5), XCTWaiter.Result.completed)
    }
    
    func test_play_allNotes() throws {
        // Setup
        let player = NotePlayer.shared
        let instruments = Instrument.allCases
        
        var notes = [Note]()
        for instrument in instruments {
            for scheme in instrument.schemes {
                for scale in 0..<instrument.numScales {
                    notes.append(Note(instrument: instrument, scheme: scheme, scale: scale))
                }
            }
        }
        
        var expectations = [XCTestExpectation]()
        
        // Test
        notes.enumerated().forEach { i, note in
            let expectation = XCTestExpectation(description: "\(i)")
            expectations.append(expectation)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + TimeInterval(i)) {
                XCTAssertTrue(player.play(note: note))
                expectation.fulfill()
            }
        }
        
        // Verify
        XCTAssertEqual(XCTWaiter.wait(for: expectations, timeout: Double(notes.count) * 1.5), XCTWaiter.Result.completed)
    }

}
