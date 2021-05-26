//
//  NotePlayer.swift
//  KTDKandinsky
//
//  Created by Kyle Donnelly on 5/25/21.
//

import AVFoundation
import Foundation

public struct Note: Hashable {
    let instrument: Instrument
    let scheme: Scheme
    let scale: Int
    
    public init(instrument: Instrument, scheme: Scheme, scale: Int) {
        self.instrument = instrument
        self.scheme = scheme
        self.scale = scale
    }
    
    init(instrument: Instrument, scheme: Int, scale: Int) {
        self.init(instrument: instrument,
                  scheme: instrument.schemes[scheme],
                  scale: scale)
    }
    
    public var soundFile: String {
        let scheme = self.scheme
        let instrument = self.instrument
        
        if instrument == .percussion && scheme == .glock {
            switch scale {
            case 0:
                return "percussion_timp_low"
            case 1:
                return "percussion_timp_high"
            case 2, 3:
                return "\(String(describing: instrument))_\(scheme.rawValue)\(scale - 2)"
            default:
                return "percussion_triangle"
            }
        }
        
        return "\(String(describing: instrument))_\(scheme.rawValue)\(scale)"
    }
    
    var fileExtension: String {
        return "mp3"
    }
}

public class NotePlayer {
    
    public static let shared = NotePlayer()
    
    var notePlayers: [Note: AVAudioPlayer]
    
    init() {
        self.notePlayers = [:]
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            return
        }
        
        for note in Self.allNotes() {
            let filename = note.soundFile
            let bundle = Bundle(for: Self.self)
            guard let url = bundle.url(forResource: filename, withExtension: note.fileExtension) else {
                continue
            }
            
            do {
                let player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
                player.numberOfLoops = 0
                self.notePlayers[note] = player
            } catch {
                continue
            }
        }
    }
    
    public static func allNotes() -> [Note] {
        var notes = [Note]()
        for instrument in Instrument.allCases {
            for scheme in instrument.schemes {
                for scale in 0..<instrument.numScales {
                    notes.append(Note(instrument: instrument, scheme: scheme, scale: scale))
                }
            }
        }
        return notes
    }
    
    @discardableResult
    public func play(note: Note) -> Bool {
        guard let player = self.notePlayers[note] else {
            return false
        }
        
        player.play()
        return true
    }
    
}
