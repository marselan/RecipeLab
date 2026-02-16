//
//  FavoritesView.swift
//  CookPad
//
//  Created by Mariano Arselan on 13-02-26.
//

import SwiftUI

struct FavoritesView: View {
   
    @State private var viewModel = FavoritesViewModel()
    @Environment(\.authService) var authViewModel
    
    var body: some View {
        VStack {
            switch viewModel.status {
            case .loading:
                DotsLoadingIndicator()
                    .frame(maxHeight: .infinity)
            case .loaded(let meals):
                NavigationStack {
                    VStack {
                        Text("Favorites")
                            .font(.system(size: 24, weight: .bold, design: .rounded))
                            .padding()
                        ScrollView(showsIndicators: false) {
                            ForEach(meals) { meal in
                                NavigationLink(destination: MealDetailView(id: meal.id)) {
                                    MealRowView(meal: meal)
                                }
                            }
                        }
                    }
                }
            case .error:
                Text("Error")
            }
        }
        .onAppear() {
            viewModel.fetchFavorites(email: authViewModel.email)
        }
    }
}

#Preview {
    FavoritesView()
}
