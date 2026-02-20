//
//  SettingsView.swift
//  CookPad
//
//  Created by Mariano Arselan on 09-02-26.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.authService) var authViewModel
    @Environment(\.dismiss) var dismiss
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .tint(.black)
                }
                .padding()
            }
            .padding(.bottom, 40)
            
            profile
                .padding()
            
            Button {
                authViewModel.signOut()
            } label: {
                HStack {
                    Text("Log out")
                        .font(.system(size: 20, weight: .regular, design: .rounded))
                    Spacer()
                    Image(systemName: "rectangle.portrait.and.arrow.right")
                }
                .padding(.vertical)
                .padding(.horizontal, 20)
            }
            .foregroundStyle(.black)
            Spacer()
        }
    }
    
    private var profile: some View {
        HStack {
            profilePic
            VStack(alignment: .leading) {
                givenName
                email
                Spacer()
            }
            .padding(.top, 10)
            .padding(.leading, 10)
            Spacer()
        }
        .fixedSize(horizontal: false, vertical: true)
    }
    
    private var profilePic: some View {
        AsyncCachedImage(urlString: authViewModel.imageUrl) { phase in
            switch phase {
            case .loaded(let image):
                image
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
            default:
                defaultPic
            }
        }
    }
    
    private var givenName: some View {
        Text(authViewModel.givenName)
            .font(.system(.title3, design: .rounded))
            .bold()
    }
    
    private var email: some View {
        Text(authViewModel.email)
            .font(.system(.subheadline, design: .rounded))
            .bold()
    }
    
    private var defaultPic: some View {
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .frame(width: 100, height: 100)
    }
}

#Preview {
    SettingsView()
        .environment(\.authService, MockUserAuthModel())
}
