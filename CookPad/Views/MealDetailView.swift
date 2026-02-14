//
//  MealDetailView.swift
//  CookPad
//
//  Created by Mariano Arselan on 28-01-26.
//

import SwiftUI
import Foundation
import UIKit

struct MealDetailView: View {
    
    @AppStorage("text-font-size") var textFontSize = 12.0
    @State private var showFontSizeMenu = false
    
    var viewModel = MealDetailViewModel()
    var meal: Meal?
    var id: String?
    @State var opcty = 1.0
    @State var initialOffset: CGFloat = 0.0
    @Environment(\.dismiss) var dismiss
    @Environment(\.openURL) var openURL
    @State var openBrowser: Bool = false
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.black)
                        .frame(width: 10)
                }
                Spacer()
                Image(systemName: "textformat.size")
                        .frame(width: 20, height: 20)
                        .onTapGesture {
                            showFontSizeMenu.toggle()
                        }
            }
            switch viewModel.status {
            case .loading:
                DotsLoadingIndicator()
            case .loaded(let meal):
                mealDescription(meal)
            case .failed:
                Text("Cannot find this meal.")
            }
        }
        .onAppear {
            guard let meal else {
                if let id = id {
                    viewModel.fetchMeal(id: id)
                }
                return
            }
            viewModel.status = .loaded(meal)
        }
    }
    
    private func mealDescription(_ meal: Meal) ->  some View {
        ScrollView(showsIndicators: false) {
            VStack {
                if let url = URL(string: meal.thumbnail) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: .infinity)
                            .opacity(opcty)
                            .scaleEffect(opcty)
                            .aspectRatio(1, contentMode: .fill)
                            .onGeometryChange(for: CGRect.self){ proxy in
                                proxy.frame(in: .global)
                            } action: { newValue in
                                if initialOffset == 0.0 {
                                    initialOffset = newValue.minY
                                }
                                opcty = newValue.minY / (4.0 * initialOffset) + 0.75
                                if opcty > 1.0 {
                                    opcty = 1.0
                                }
                                if opcty < 0.0 {
                                    opcty = 0.0
                                }
                            }
                        
                    } placeholder: {
                        placeholder
                    }
                } else {
                    placeholder
                }
                HStack {
                    Image(systemName: "clock")
                        .frame(width: 20, height: 20)
                    Text("1 hour")
                        .font(.system(.caption, design: .rounded))
                        .bold()
                }
                .padding()
                if let urlString = meal.ytUrl, urlString.isEmpty == false,
                   let _ =
                    URL(string: urlString) {
                    Button("Watch on YouTube") {
                        openBrowser = true
                    }
                }
                Divider()
                HStack {
                    Text("Ingredients")
                        .font(.system(.title3, design: .rounded))
                        .bold()
                        .padding(.vertical)
                    Spacer()
                }
                ForEach ( measuresIngredients(meal), id: \.self ) { mi in
                    HStack {
                        Text(mi.measure)
                            .font(.system(size: textFontSize, weight: .bold, design: .rounded))
                        Text(mi.ingredient)
                            .font(.system(size: textFontSize, weight: .regular, design: .rounded))
                        Spacer()
                    }
                }
                Divider()
                HStack {
                    Text("Instructions")
                        .font(.system(.title3, design: .rounded))
                        .bold()
                        .padding(.vertical)
                    Spacer()
                }
                if let instructions = meal.instructions {
                    Text(instructions)
                        .font(.system(size: textFontSize, weight: .regular, design: .rounded))
                }
            }//VStack
            .confirmationDialog("Paragraph size font change is not yet implemented.", isPresented: $showFontSizeMenu, actions: {
                Button("Small") {
                    textFontSize = 12.0
                }
                Button("Medium") {
                    textFontSize = 18.0
                }
                Button("Large") {
                    textFontSize = 24.0
                }
            })
            .navigationBarBackButtonHidden()
            .fullScreenCover(isPresented: $openBrowser) {
                if let urlString = meal.ytUrl, let url = URL(string: urlString) {
                    ZStack(alignment: .topLeading) {
                        WebView(url: url)
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(.black)
                        }
                        .padding()
                    }
                } else {
                    Text("Invalid URL for video.")
                }
            }
        }
    }
    
    struct MeasureIngredient: Identifiable, Hashable {
        var id = UUID()
        var measure: String
        var ingredient: String
    }
    
    private func measuresIngredients(_ meal: Meal) -> [MeasureIngredient] {
        zip(meal.measures, meal.ingredients).map { MeasureIngredient(measure: $0, ingredient: $1) }
    }
    
    private var placeholder: some View {
        Image(systemName: "photo.fill")
            .resizable()
            .scaledToFill()
            .frame(maxWidth: .infinity)
            .aspectRatio(1, contentMode: .fit)
    }
}

#Preview {
    MealDetailView(meal: Meal(id: "", name: "Chicken Pie", category: "category", thumbnail: "https://www.themealdb.com/images/media/meals/1549542994.jpg", ingredients: ["Chicken", "flour", "salt", "pepper"], measures: ["1 kg", "200 g", "1 tsp", "2 tsp"], instructions: "Mix everything", ytUrl: ""))
}
