//
//  MealCardView.swift
//  CookPad
//
//  Created by Mariano Arselan on 26-01-26.
//

import SwiftUI

struct MealCardView: View {
    
    var meal: Meal
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            if let url = URL(string: meal.thumbnail) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .foregroundColor(.black)
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
