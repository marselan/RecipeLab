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
    
    @State private var viewModel = MainViewModel()
    @State private var addMealTapped: Bool = false
    @State private var hamburgerTapped: Bool = false
    @AppStorage("selectedTab") private var selectedTab: TabItem = .meals
    
    private var cols = Array(repeating: GridItem(.flexible()), count: 2)
    
    var body: some View {
        VStack {
            switch viewModel.status {
            case .empty:
                EmptyView()
            case .loading:
                DotsLoadingIndicator()
            case .error:
                errorView
            case .loaded(let meals):
                TabView(selection: $selectedTab) {
                    NavigationStack {
                        header
                        
                        NavigationLink(destination: SearchMealView()) {
                            FakeSearchBar()
                                .padding(.vertical)
                        }.accentColor(.black)
                        scrollView(meals)
                            .refreshable {
                                viewModel.fetchRandomMeals()
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
            }

        }
        .padding()
        .fullScreenCover(isPresented: $addMealTapped) {
            AddNewMeal()
        }
        .fullScreenCover(isPresented: $hamburgerTapped) {
            SettingsView()
        }
        .onAppear {
            viewModel.fetchRandomMeals()
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
    
    var errorView: some View {
        VStack {
            Text("Something went wrong")
                .font(.system(size: 20, weight: .semibold, design: .rounded))
                .foregroundStyle(.black)
                .padding()
            Button {
                viewModel.fetchRandomMeals()
            } label: {
                Text("Try again")
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .foregroundStyle(.white)
                    .padding()
            }
            .background(.blue)
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
