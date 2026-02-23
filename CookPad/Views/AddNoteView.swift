//
//  AddNoteView.swift
//  CookPad
//
//  Created by Mariano Arselan on 23-02-26.
//

import SwiftUI
import Swinject

struct AddNoteView: View {
    @State private var viewModel = NoteViewModel()
    @Environment(\.authService) var authViewModel
    
    var id: String
    
    var body: some View {
        VStack {
            switch viewModel.status {
            case .loading:
                DotsLoadingIndicator()
                    .frame(maxHeight: .infinity)
            case .saving:
                EmptyView()
            case .loaded(let note):
                readOnlyView(note)
            case .edit(let mode):
                editingView(mode)
            case .errorLoading:
                Text("Something went wrong")
            case .errorSaving:
                EmptyView()
            }
        }
        .onAppear {
            viewModel.fetchNote(email: authViewModel.email, id: id)
        }
    }
    
    func readOnlyView(_ note: Note) -> some View {
        VStack {
            ZStack {
                Text("Note")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
                HStack {
                    Spacer()
                    Button {
                        viewModel.editNote()
                    } label: {
                        Image(systemName: "pencil")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                            .foregroundStyle(.black)
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.top, 40)
            ScrollView(showsIndicators: false) {
                HStack {
                    Text(note.text)
                        .multilineTextAlignment(.leading)
                        .padding(.leading)
                    Spacer()
                }
            }
        }
    }
    
    func editingView(_ mode: NoteViewModel.EditingMode) -> some View {
        VStack {
            Text(mode == .new ? "Add a note" : "Update note")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .padding(.top, 40)
            ScrollView(showsIndicators: false) {
                TextEditor(text: $viewModel.text)
                    .frame(height: 200)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .overlay (
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(.systemGray5), lineWidth: 1)
                    )
                    .padding(.horizontal)
                Button {
                    viewModel.saveNote()
                } label: {
                    Text("Save")
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical)
                        .foregroundStyle(.white)
                        .background(.blue)
                        .cornerRadius(14)
                }
                .padding()
            }
        }
    }
}

// New note
#Preview  {
    Resolver.shared.register(StorageProtocol.self) { _ in
        AddNoteMockStorageNewNote()
    }
    return AddNoteView(id: "id").environment(\.authService, MockUserAuthModel())
    

}

// Update note
#Preview  {
    Resolver.shared.register(StorageProtocol.self) { _ in
        AddNoteMockStorageUpdateNote()
    }
    return AddNoteView(id: "id").environment(\.authService, MockUserAuthModel())
    

}

class AddNoteMockStorageNewNote: Storage {
    override func fetchNote(email: String, id: String) async throws -> Note? {
        nil
    }
    override func saveNote(email: String, note: Note) async throws {
        
    }

}

class AddNoteMockStorageUpdateNote: Storage {
    override func fetchNote(email: String, id: String) async throws -> Note? {
        Note(id: "id", text: "Remeber to cook evenly each side until it gets brown.")
    }
    override func saveNote(email: String, note: Note) async throws {
        
    }

}
