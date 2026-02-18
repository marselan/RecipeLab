//
//  MealCardView.swift
//  CookPad
//
//  Created by Mariano Arselan on 26-01-26.
//

import SwiftUI

struct MealCardView: View {
    
    var meal: Meal
    
    @Environment(FavoritesViewModel.self) private var favoritesViewModel
    
    var body: some View {
        VStack {
            if let url = URL(string: meal.thumbnail) {
                ZStack(alignment: .bottomLeading) {
                    AsyncImage(url: url) { image in
                        ZStack(alignment: .topTrailing) {
                            image
                                .resizable()
                                .scaledToFill()
                                .foregroundColor(.black)
                            Image(systemName: favoritesViewModel.isFavorite(meal: meal) ? "heart.fill" : "heart")
                                .resizable()
                                .foregroundStyle(.white)
                                .frame(width: 25, height: 25)
                                .shadow(color: .black, radius: 5)
                                .padding()
                                .onTapGesture { _ in
                                    favoritesViewModel.toggle(meal: meal)
                                }
                        }
                    } placeholder: {
                        Image(systemName: "photo.fill")
                            .resizable()
                            .foregroundColor(.black)
                    }
                    Text(meal.name)
                        .font(.system(.headline, design: .rounded))
                        .multilineTextAlignment(.leading)
                        .padding(.bottom, 10)
                        .padding(.leading, 10)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                        .shadow(color: .black, radius: 4)
                }
            } else {
                Image(systemName: "photo.fill")
                    .resizable()
                    .foregroundColor(.black)
            }
        }
        .cornerRadius(14)
        .aspectRatio(1.2, contentMode: .fit)
    }
}

#Preview {
    MealCardView(meal: Meal(id: "", name: "Some meal name here that looks good", category: "Some category", thumbnail: "https://www.themealdb.com/images/media/meals/1549542994.jpg", ingredients: ["Chicken", "Onion", "Beef"], measures: [], instructions: "Mix everything", ytUrl: ""))
        .frame(width: 200)
}
