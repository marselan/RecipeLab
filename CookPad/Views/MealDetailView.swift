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
    
    enum CloseButtonStyle {
        case cross
        case back
    }
    
    @AppStorage("text-font-size") var textFontSize = 12.0
    @State private var showFontSizeMenu = false
    @State private var showAddNoteSheet = false
    
    var viewModel = MealDetailViewModel()
    @Environment(FavoritesViewModel.self) private var favoritesViewModel
    var meal: Meal?
    var id: String?
    var closeButtonStyle: CloseButtonStyle = .back
    @State var opcty = 0.0
    @State var initialOffset: CGFloat = 0.0
    @Environment(\.dismiss) var dismiss
    @Environment(\.openURL) var openURL
    @State var openBrowser: Bool = false
    
    var body: some View {
        VStack {
            switch viewModel.status {
            case .loading:
                DotsLoadingIndicator()
            case .loaded(let meal):
                VStack {
                    header(meal)
                    mealDescription(meal)
                }
            case .failed:
                Text("Cannot find this meal.")
            }
        }
        .navigationBarBackButtonHidden()
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
                    AsyncImage(url: url,
                               transaction: Transaction(animation: .spring)) { phase in
                        switch phase {
                        case .failure(_):
                            placeholder
                                .transition(.opacity)
                        case .empty:
                            emptyView
                        case .success(let image):
                            ZStack(alignment: .topTrailing) {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .transition(.opacity)
                                    .frame(maxWidth: .infinity,  maxHeight: .infinity)
                                    .opacity(opcty)
                                    .scaleEffect(opcty)
                                    .onGeometryChange(for: CGRect.self){ proxy in
                                        proxy.frame(in: .global)
                                    } action: { newValue in
                                        if initialOffset == 0.0 {
                                            initialOffset = newValue.minY
                                        }
                                        opcty = newValue.minY / (4.0 * initialOffset) + 0.75
                                        if opcty < 0.0 {
                                            opcty = 0.0
                                        }
                                    }
                            }
                        @unknown default:
                            emptyView
                        } // switch
                
                    }
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
            .sheet(isPresented: $showAddNoteSheet) {
                AddNoteView(id: meal.id)
                    .presentationDragIndicator(.visible)
            }
        }
    }
    
    private func header(_ meal: Meal) -> some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: closeButtonStyle == .back ? "chevron.left" : "xmark.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundColor(.black)
                    .frame(height: closeButtonStyle == .back ? 20 : 30)
            }
            Spacer()
            Image(systemName: "pencil.tip.crop.circle.badge.plus")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.black)
                .frame(width: 20, height: 20)
                .padding(.trailing, 10)
                .onTapGesture { _ in
                    showAddNoteSheet.toggle()
                }
            Image(systemName: favoritesViewModel.isFavorite(meal: meal) ? "heart.fill" : "heart")
                .resizable()
                .scaledToFit()
                .foregroundStyle(.black)
                .frame(width: 20, height: 20)
                .padding(.trailing, 10)
                .onTapGesture { _ in
                    favoritesViewModel.toggle(meal: meal)
                }
            Image(systemName: "textformat.size")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundStyle(.black)
                .frame(width: 20, height: 20)
                .onTapGesture {
                    showFontSizeMenu.toggle()
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
            .scaledToFit()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var emptyView: some View {
        Rectangle()
            .foregroundStyle(.clear)
            .frame(maxWidth: .infinity)
            .frame(height: 300)
    }
}

#Preview {
    MealDetailView(meal: Meal(id: "", name: "Chicken Pie", category: "category", thumbnail: "https://www.themealdb.com/images/media/meals/1549542994.jpg", ingredients: ["Chicken", "flour", "salt", "pepper"], measures: ["1 kg", "200 g", "1 tsp", "2 tsp"], instructions: "Mix everything", ytUrl: ""))
        .environment(FavoritesViewModel())
}
