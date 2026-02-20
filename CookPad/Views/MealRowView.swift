//
//  MealRowView.swift
//  CookPad
//
//  Created by Mariano Arselan on 27-01-26.
//

import SwiftUI

struct MealRowView: View {
    
    @Environment(FavoritesViewModel.self) private var favoritesViewModel
    
    var meal: Meal
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 10) {
                Text(meal.name)
                    .font(.system(.callout, design: .rounded))
                    .bold()
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.black)
                Text(ingredients)
                    .font(.system(.caption, design: .rounded))
                    .lineLimit(2)
                    .foregroundStyle(.black)
                    .multilineTextAlignment(.leading)
                HStack {
                    Image(systemName: "clock")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.gray)
                    Text("25 min")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.gray)
                    Spacer()
                    Image(systemName: favoritesViewModel.isFavorite(meal: meal) ? "heart.fill" : "heart")
                        .resizable()
                        .foregroundStyle(.black)
                        .frame(width: 25, height: 25)
                        .padding()
                        .onTapGesture { _ in
                            favoritesViewModel.toggle(meal: meal)
                        }
                }
            } // VStack
            .padding()
            Spacer()
            AsyncCachedImage(urlString: meal.thumbnail) { phase in
                switch phase {
                case .loaded(let image):
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .cornerRadius(8)
                default:
                    Image(systemName: "photo.fill")
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(8)
                        .foregroundColor(.black)
                }
            }
        }
    }
    
    private var ingredients: String {
        var ing = ""
        for (index, value) in meal.ingredients.enumerated() {
            let cValue = index == 0 ? value.capitalized : value
            ing += index == meal.ingredients.count - 1 ? "\(cValue)" : "\(cValue), "
        }
        return ing
    }
}

#Preview {
    VStack {
        MealRowView(meal: Meal(id: "", name: "Stew", category: "Some category", thumbnail: "https://www.themealdb.com/images/media/meals/g046bb1663960946.jpg", ingredients: ["garlic", "olive oil", "tomatoes"], measures: [], instructions: "Mix everything", ytUrl: ""))
            .padding()
    }
 //   .background(.gray)
}
