//
//  AddNewMeal.swift
//  CookPad
//
//  Created by Mariano Arselan on 02-02-26.
//

import SwiftUI
import PhotosUI

struct AddNewMeal: View {
    
    enum PhotoSource: Identifiable {
        case photoLibrary
        case camera
        
        var id: Int {
            hashValue
        }
    }
    
    
    @State var photoSource: PhotoSource?
    @State var isPresented: Bool = false
    
    @State var name: String = ""
    @State var description: String = ""
    @State var image = Image("hamburguer")
    @State var selectedImage: UIImage = UIImage()
    
    var body: some View {
        ScrollView {
            image
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .padding()
                .onTapGesture {
                    isPresented.toggle()
                }
            CustomTextField(title: "Name:", text: $name)
                .padding()
            TextEditor(text: $description)
                .frame(height: 200)
                .autocapitalization(.none)
                .autocorrectionDisabled()
                .overlay (
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color(.systemGray5), lineWidth: 1)
                )
                .padding()
            
        }
        .actionSheet(isPresented: $isPresented) {
            ActionSheet(title: Text("Select Photo"), message: nil, buttons: [
                .default(Text("Photo Library")) {
                    photoSource = .photoLibrary
                },
                .default(Text("Camera")) {
                    photoSource = .camera
                },
                .cancel()
            ])
        }
        .sheet(item: $photoSource) {
             source in
            switch source {
            case .photoLibrary:
                ImagePicker(sourceType: .photoLibrary, selectedImage: $selectedImage)
            case .camera:
                ImagePicker(sourceType: .camera, selectedImage: $selectedImage)
            }
        }
        .onChange(of: selectedImage) { newValue in
            image = Image(uiImage: newValue)
        }
    
    }
}

#Preview {
    AddNewMeal()
}
