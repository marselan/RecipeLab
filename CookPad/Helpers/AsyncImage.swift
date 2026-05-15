//
//  AsyncCachedImage.swift
//  CookPad
//
//  Created by Mariano Arselan on 19-02-26.
//

import SwiftUI

enum ImagePhase: Equatable {
    case loading
    case loaded(Image)
    case error
}

struct AsyncCachedImage<Content: View>: View {
    @Inject
    private var imageLoader: ImageLoaderProtocol
    @State private var phase: ImagePhase = .loading
    var urlString: String
    @ViewBuilder var content: (ImagePhase) -> Content
    
    var body: some View {
        content(phase)
            .task { @MainActor in
                do {
                    let image = try await imageLoader.load(urlString: urlString)
                    phase = .loaded(image)
                } catch {
                    phase = .error
                }
            }
    }
}

#Preview {
    AsyncCachedImage(urlString: "https://www.themealdb.com/images/media/meals/ustsqw1468250014.jpg") { phase in
        switch phase {
        case .loading:
            Text("Loading...")
        case .loaded(let image):
            image
        case .error:
            Text("Error")
        }
    }
}


