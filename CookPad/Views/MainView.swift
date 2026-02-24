//
//  MainView.swift
//  CookPad
//
//  Created by Mariano Arselan on 26-01-26.
//

import SwiftUI

struct MainView: View {
    
    enum TabItem: Int {
        case meals
        case favorites
    }
    
    class MealId {
        var id: String = ""
    }
    
    @State private var mainViewModel = MainViewModel()
    @State private var favoritesViewModel = FavoritesViewModel()
    @Environment(\.authService) var authViewModel
    @State private var addMealTapped: Bool = false
    @State private var hamburgerTapped: Bool = false
    @AppStorage("selectedTab") private var selectedTab: TabItem = .meals
    
    @State private var isPresentingMeal = false
    @State private var mealId = MealId()
    
    
    private var cols = Array(repeating: GridItem(.flexible()), count: 2)
    
    var body: some View {
        VStack {
            switch (favoritesViewModel.status, mainViewModel.status) {
            case (.loading, _), (_, .loading):
                DotsLoadingIndicator()
            case (_, .error):
                reloadRecipesView
            case (.error, _):
                reloadFavoritesView
            case (.loaded(_), .loaded(let meals)):
                TabView(selection: $selectedTab) {
                    NavigationStack {
                        header
                        
                        NavigationLink(destination: SearchMealView()) {
                            FakeSearchBar()
                                .padding(.vertical)
                        }.accentColor(.black)
                        scrollView(meals)
                            .refreshable {
                                mainViewModel.fetchRandomMeals()
                            }
                    }
                    .tabItem {
                        VStack {
                            Image("bowl")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 4, height: 4)
                                .foregroundStyle(selectedTab == .meals ? .blue : .black)
                            Text("Recipes")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .foregroundStyle(selectedTab == .meals ? .blue : .black)
                        }
                    }
                    FavoritesView()
                        .tabItem {
                            Label("Favorites", systemImage: "star")
                                .font(.system(size: 20, weight: .semibold, design: .rounded))
                                .foregroundStyle(selectedTab == .favorites ? .blue : .black)
                            
                        }
                }
                .environment(favoritesViewModel)
            default:
                EmptyView()
            }

        }
        .padding()
        .fullScreenCover(isPresented: $addMealTapped) {
            AddNewMeal()
        }
        .fullScreenCover(isPresented: $hamburgerTapped) {
            SettingsView()
        }
        .fullScreenCover(isPresented: $isPresentingMeal) {
            MealDetailView(id: mealId.id, closeButtonStyle: .cross)
                .padding()
                .environment(favoritesViewModel)
        }
        .onAppear {
            favoritesViewModel.fetchFavorites(email: authViewModel.email)
            mainViewModel.fetchRandomMeals()
        }
        .onOpenURL { url in
            if url.host() == "meal" {
                mealId.id = url.lastPathComponent
                isPresentingMeal.toggle()
            }
        }
    }
}

extension MainView {
    
    var header: some View {
        HStack {
            Button {
                hamburgerTapped.toggle()
            } label: {
                Image(systemName: "line.3.horizontal")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25, height: 25)
                    .foregroundStyle(.black)
            }
            Spacer()
            Button {
                addMealTapped.toggle()
            } label: {
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .foregroundStyle(.black)
            }
        }
    }
    
    var reloadRecipesView: some View {
        VStack {
            Text("Something went wrong")
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .foregroundStyle(.black)
                .padding()
            Button {
                mainViewModel.fetchRandomMeals()
            } label: {
                Text("Try again")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
                    .padding()
            }
            .background(.orange)
            .cornerRadius(10)
        }
    }
    
    var reloadFavoritesView: some View {
        VStack {
            Text("Something went wrong")
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .foregroundStyle(.black)
                .padding()
            Button {
                favoritesViewModel.fetchFavorites(email: authViewModel.email)
            } label: {
                Text("Try again")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
                    .padding()
            }
            .background(.orange)
            .cornerRadius(10)
        }
    }
    
    func scrollView(_ meals: [Meal]) -> some View {
        ScrollView(showsIndicators: false) {
            LazyVGrid(columns: cols, spacing: 10) {
                ForEach(meals) { meal in
                    NavigationLink(destination: SearchMealView(searchText: meal.name)) {
                        MealCardView(meal: meal)
                    }
                }
            }
        } // ScrollView
    }
}

#Preview {
    MainView()
}
