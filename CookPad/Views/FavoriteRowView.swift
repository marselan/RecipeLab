//
//  FavoriteRowView.swift
//  CookPad
//
//  Created by Mariano Arselan on 18-02-26.
//

import SwiftUI

struct FavoriteRowView: View {
    
    @Environment(FavoritesViewModel.self) private var favoritesViewModel
    
    var meal: Meal
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 10) {
                Text(meal.name)
                    .font(.system(.callout, design: .rounded))
                    .bold()
                    .multilineTextAlignment(.leading)
                    .foregroundStyle(.black)
                HStack {
                    Image(systemName: "clock")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.gray)
                    Text("25 min")
                        .font(.system(.caption, design: .rounded))
                        .foregroundStyle(.gray)
                    Spacer()
                }
                Spacer()
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
                    photoImage
                }
            }
        }.fixedSize(horizontal: false, vertical: true)
    }
    
    private var photoImage: some View {
        Image(systemName: "photo.fill")
            .resizable()
            .scaledToFit()
            .frame(width: 100)
            .cornerRadius(8)
            .foregroundColor(.black)
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
    FavoriteRowView(meal: Meal(id: "", name: "Stew", category: "Some category", thumbnail: "https://www.themealdb.com/images/media/meals/g046bb1663960946.jpg", ingredients: ["garlic", "olive oil", "tomatoes"], measures: [], instructions: "Mix everything", ytUrl: ""))
            .padding()
            .environment(FavoritesViewModel())
}
