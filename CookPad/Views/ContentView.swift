//
//  ContentView.swift
//  CookPad
//
//  Created by Mariano Arselan on 26-01-26.
//

import SwiftUI

struct ContentView: View {
    
    @State var authViewModel = UserAuthModel()
    
    var body: some View {
        VStack {
            switch authViewModel.status {
            case .loggedIn:
                MainView()
            case .loggedOut:
                VStack {
                    givenName
                    profilePic
                    signInButton
                }
            case .restoring:
                DotsLoadingIndicator()
                    .frame(maxHeight: .infinity)
            case .unknown:
                EmptyView()
            case .error:
                Text("Error in authentication process")
            }
        }
        .task {
            await authViewModel.tryRestoreSession()
        }
        .environment(\.authService, authViewModel)
    }
    
    var signInButton: some View {
        Button(action: {
            Task {
                await self.authViewModel.signIn()
            }
        }) {
            Text("Sign In")
        }
    }
    
    var profilePic: some View {
        AsyncCachedImage(urlString: authViewModel.imageUrl) { phase in
            switch phase {
            case .loaded(let image):
                image
                    .resizable()
                    .frame(width: 100, height: 100)
            case .loading:
                defaultPic
            case .error:
                defaultPic
            }
        }
    }
    
    var givenName: some View {
        Text(authViewModel.givenName)
            .font(.system(.title3, design: .rounded))
            .bold()
            .padding()
    }
    
    var defaultPic: some View {
        Image(systemName: "person.crop.circle.fill")
            .resizable()
            .frame(width: 100, height: 100)
    }
    
    
}

#Preview {
    ContentView()
}
