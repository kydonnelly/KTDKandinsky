//
//  PlaybackController.swift
//  Pods
//
//  Created by Kyle Donnelly on 5/25/21.
//

import Foundation

typealias Chord = [Note]

protocol Playable {
    var frame: CGRect { get }
    var scheme: Scheme { get }
    var instrument: Instrument { get }
}

extension Playable {
    func scale(rect: CGRect) -> Int {
        guard rect.size.height > 0 else { return 0 }
        
        let numScales = self.instrument.numScales
        let yRatio = (self.frame.origin.y - rect.origin.y) / rect.size.height
        return Int(CGFloat(numScales) * yRatio)
    }
}

class PlaybackController {
    
    public var chordThresholdRatio: CGFloat = 0.07
    
    private let bounds: CGRect
    private let chords: [Chord]
    private let chordThreshold: CGFloat
    
    private var metronome: CADisplayLink?
    
    init(playables: [Playable]) {
        guard !playables.isEmpty else {
            preconditionFailure("Guard against empty playables in caller")
        }
        
        let minX = playables.map { $0.frame.origin.x }.min()!
        let minY = playables.map { $0.frame.origin.y }.min()!
        let maxX = playables.map { $0.frame.origin.x + $0.frame.size.width }.max()!
        let maxY = playables.map { $0.frame.origin.y + $0.frame.size.height }.max()!
        self.bounds = CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
        
        self.chordThreshold = self.bounds.size.width * self.chordThresholdRatio
        
        let sortedPlayables = playables.sorted {
            return $0.frame.midX > $1.frame.midX
        }
        
        var playableChords = [[Playable]]()
        for playable in sortedPlayables {
            if var chord = playableChords.popLast() {
                if let anchor = chord.first,
                   abs(anchor.frame.midX - playable.frame.midX) <= self.chordThreshold {
                    chord.append(playable)
                    playableChords.append(chord)
                    continue
                } else {
                    playableChords.append(chord)
                }
            }
        
            playableChords.append([playable])
        }
        
        self.chords = playableChords.map { [bounds = self.bounds] in
            $0.map {
                return Note(instrument: $0.instrument, scheme: $0.scheme, scale: $0.scale(rect: bounds))
            }
        }
    }
    
    var metronomeMilliseconds: Double {
        switch self.chords.count {
        case 2: return 500
        case 3: return 443.333
        case 4: return 361.500
        case 5: return 333
        default: return 308
        }
    }
    
    func startMetronome() {
        self.metronome = CADisplayLink(target: self, selector: #selector(hit(_:)))
        self.metronome?.add(to: .main, forMode: .common)
    }
    
    func stopMetronome() {
        self.metronome?.remove(from: .main, forMode: .common)
        self.metronome?.invalidate()
        self.metronome = nil
    }
    
    @objc public func hit(_ link: CADisplayLink) {
        let time = link.timestamp
        let lastHit = time - link.duration
        self.playChords(from: lastHit, to: time)
    }
    
    @discardableResult
    func playChords(from: TimeInterval, to: TimeInterval) -> Range<Int>? {
        guard from <= to else {
            return nil
        }
        
        let threshold = self.metronomeMilliseconds
        let startIndex = Int(from / threshold)
        let endIndex = Int(to / threshold)
        let range = startIndex..<endIndex
        guard startIndex != endIndex else {
            return range
        }
        
        // only play the latest chord
        let index = endIndex % self.chords.count
        let chord = self.chords[index]
        chord.forEach {
            NotePlayer.shared.play(note: $0)
        }
        
        return range
    }
    
}
