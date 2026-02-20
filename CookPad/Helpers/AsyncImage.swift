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
    private let imageLoader = ImageLoader()
    @State private var phase: ImagePhase = .loading
    private var urlString: String
    private var content: (ImagePhase) -> Content
    
    init(urlString: String , @ViewBuilder _ content: @escaping (ImagePhase) -> Content) {
        self.urlString = urlString
        self.content = content
    }
    
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


