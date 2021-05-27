//
//  PlaybackController.swift
//  Pods
//
//  Created by Kyle Donnelly on 5/25/21.
//

import Foundation

typealias Chord = [Note]

public protocol Playable {
    var frame: CGRect { get }
    var scheme: Scheme { get }
    var instrument: Instrument { get }
    
    func didPlay(beat: TimeInterval)
}

extension Playable {
    func scale(rect: CGRect) -> Int {
        guard rect.size.height > 0 else { return 0 }
        
        let numScales = self.instrument.numScales
        let yRatio = 1.0 - (self.frame.origin.y - rect.origin.y + 0.001) / rect.size.height
        return Int(CGFloat(numScales) * yRatio)
    }
}

public class PlaybackController {
    
    public var chordThresholdRatio: CGFloat = 0.07
    
    private let bounds: CGRect
    private let chords: [Chord]
    private let playables: [[Playable]]
    private let chordThreshold: CGFloat
    
    private var beat: TimeInterval = 0
    private var metronome: CADisplayLink?
    private var metronomeSeconds: TimeInterval
    
    public init(playables: [Playable], bounds: CGRect? = nil, metronomeSeconds: TimeInterval? = nil) {
        guard !playables.isEmpty else {
            preconditionFailure("Guard against empty playables in caller")
        }
        
        if let bounds = bounds {
            self.bounds = bounds
        } else {
            let minX = playables.map { $0.frame.origin.x }.min()!
            let minY = playables.map { $0.frame.origin.y }.min()!
            let maxX = playables.map { $0.frame.origin.x + $0.frame.size.width }.max()!
            let maxY = playables.map { $0.frame.origin.y + $0.frame.size.height }.max()!
            self.bounds = CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
        }
        
        self.chordThreshold = self.bounds.size.width * self.chordThresholdRatio
        
        let sortedPlayables = playables.sorted {
            return $0.frame.midX < $1.frame.midX
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
        
        self.playables = playableChords
        self.chords = playableChords.map { [bounds = self.bounds] in
            $0.map {
                return Note(instrument: $0.instrument, scheme: $0.scheme, scale: $0.scale(rect: bounds))
            }
        }
        
        self.metronomeSeconds = metronomeSeconds ?? Self.defaultMetronome(numChords: playableChords.count)
    }
    
    static func defaultMetronome(numChords: Int) -> Double {
        switch numChords {
        case 2: return 0.500
        case 3: return 0.443333
        case 4: return 0.361500
        case 5: return 0.333
        default: return 0.308
        }
    }
    
    public func startMetronome() {
        self.beat = 0
        self.metronome = CADisplayLink(target: self, selector: #selector(hit(_:)))
        self.metronome?.add(to: .main, forMode: .common)
    }
    
    public func stopMetronome() {
        self.metronome?.remove(from: .main, forMode: .common)
        self.metronome?.invalidate()
        self.metronome = nil
    }
    
    @objc public func hit(_ link: CADisplayLink) {
        let lastBeat = self.beat
        self.beat += link.duration
        self.playChords(from: lastBeat, to: self.beat)
    }
    
    @discardableResult
    func playChords(from: TimeInterval, to: TimeInterval) -> Range<Int>? {
        guard from <= to else {
            return nil
        }
        
        let threshold = self.metronomeSeconds
        let startIndex = Int(from / threshold)
        let endIndex = Int(to / threshold)
        let range = startIndex..<endIndex
        for i in startIndex..<endIndex {
            let index = i % self.chords.count
            let chord = self.chords[index]
            let playables = self.playables[index]
            
            chord.forEach {
                NotePlayer.shared.play(note: $0)
            }
            
            playables.forEach {
                $0.didPlay(beat: threshold)
            }
        }
        
        return range
    }
    
}
