//
//  ContentView.swift
//  KTDKandinskyDemo
//
//  Created by Kyle Donnelly on 5/25/21.
//

import KTDKandinsky
import SwiftUI

extension KTDKandinsky.Note: Identifiable {
    public typealias ID = String
    public var id: String {
        return self.soundFile
    }
}

struct PreviewAudioRow: View {
    var note: Note
    
    var body: some View {
        HStack {
            Text("Audio \(note.soundFile)")
            Spacer()
            Button("Play") {
                NotePlayer.shared.play(note: self.note)
            }
        }
    }
}

struct ContentView: View {
    let notes = NotePlayer.allNotes()
    var body: some View {
        VStack(content: {
            Text("All Notes")
            List(notes) { note in
                PreviewAudioRow(note: note)
            }
        })
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
