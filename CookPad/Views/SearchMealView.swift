//
//  SearchMealView.swift
//  CookPad
//
//  Created by Mariano Arselan on 27-01-26.
//

import SwiftUI

struct SearchMealView: View {
    
    @AppStorage("searchFilter") private var filterBy = "name"
    @Environment(\.dismiss) var dismiss
    @State var searchText: String
    @State var settingsIsPresented: Bool = false
    @State private var initialized = false
    @State private var viewModel = SearchViewModel()
    
    init(searchText: String = "") {
        self.searchText = searchText
    }
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .frame(width: 10, height: 10)
                        .tint(.black)
                }
                SearchBar(text: $searchText)
                    .padding(.horizontal, 5)
                    .onSubmit {
                        viewModel.fetchMeals(filterBy: filterBy, string: searchText)
                    }
                Button {
                    settingsIsPresented.toggle()
                } label: {
                    Image(systemName: "slider.vertical.3")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .tint(.black)
                }
            }
            .padding()
            Text("Filter by \(filterBy)")
                .font(.system(.body, design: .rounded))
                .bold()
            resultBody
            Spacer()
        }
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $settingsIsPresented) {
            SearchSettings()
                .presentationDetents([.medium])
                .presentationDragIndicator(.visible)
        }
        .onChange(of: filterBy) { _, _ in
            searchText = ""
            viewModel.clear()
        }
        .onAppear {
            if !initialized {
                if !searchText.isEmpty {
                    filterBy = "name"
                    viewModel.fetchMeals(filterBy: filterBy, string: searchText)
                }
                initialized = true
            }
        }
    }
    
    private protocol InitState {
        func execute()
    }
    
    @ViewBuilder var resultBody: some View {
        switch viewModel.status {
        case .idle:
            EmptyView()
        case .loading:
            DotsLoadingIndicator()
                .frame(maxHeight: .infinity)
        case .error:
            Text("Something went wrong.")
        case .notFound:
            Text("No meals found.")
        case .found(let meals):
            ScrollView(showsIndicators: false) {
                    ForEach(meals) { meal in
                        NavigationLink(destination: MealDetailView(meal: meal)) {
                            MealRowView(meal: meal)
                                .padding(.vertical, 5)
                    }
                }
            }
        case .foundByIngredient(let meals):
            ScrollView(showsIndicators: false) {
                    ForEach(meals) { meal in
                        NavigationLink(destination: MealDetailView(id: meal.id)) {
                            MealRowView(meal: meal)
                                .padding(.vertical, 5)
                        }
                    }
                }
            }
    }
}

#Preview {
    SearchMealView()
}
