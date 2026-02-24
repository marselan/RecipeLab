//
//  NoteViewModel.swift
//  CookPad
//
//  Created by Mariano Arselan on 23-02-26.
//

import Foundation
import Observation

@Observable
class NoteViewModel {
    
    enum EditingMode {
        case new
        case update
        case retry
    }
    
    enum Status {
        case loading
        case saving
        case loaded(Note)
        case edit(EditingMode)
        case errorLoading
        case errorSaving
    }
    
    @ObservationIgnored
    @Inject var storage: StorageProtocol
    var text: String = ""
    var status: Status = .loading
    
    private var email: String = ""
    private var id: String = ""
    
    func fetchNote(email: String, id: String) {
        Task { @MainActor in
            do {
                self.email = email
                self.id = id
                status = .loading
                let note = try await storage.fetchNote(email: email, id: id)
                if let note {
                    text = note.text
                    status = .loaded(note)
                } else {
                    status = .edit(.new)
                }
            } catch {
                status = .errorLoading
            }
        }
    }
    
    func saveNote() {
        Task { @MainActor in
            do {
                status = .saving
                let note = Note(id: id, text: text)
                try await storage.saveNote(email: email, note: note)
                self.text = note.text
                self.status = .loaded(note)
            } catch {
                status = .errorSaving
            }
        }
    }
    
    func editNote() {
        status = .edit(.update)
    }
}

