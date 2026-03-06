//
//  MealPlanDetailView.swift
//  CookPad
//
//  Created by Mariano Arselan on 06-03-26.
//

import Foundation
import SwiftUI

struct MealPlanDetailView: View {
    @State var viewModel: MealPlanDetailViewModelProtocol = MealPlanDetailViewModel()
    @Environment(\.authService) var authViewModel
    @Environment(\.dismiss) var dismiss
    
    var meal: Meal
    
    var body: some View {
        VStack {
            switch viewModel.state {
            case .loading:
                DotsLoadingIndicator()
                    .frame(maxHeight: .infinity)
            default:
                ZStack {
                    header
                    mainView
                }
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.fetchMeals(email: authViewModel.email, mealId: meal.id)
        }
    }
    
    var mainView: some View {
        VStack {
            switch viewModel.state {
            case .empty:
                empty
            case .loaded(let plannedMeals):
                loaded(plannedMeals)
            case .error:
                error
            default:
                EmptyView()
            }
        }
    }
    
    private var error: some View {
        VStack {
            Text("Something went wrong.")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .padding(.top, 40)
            Button {
                viewModel.fetchMeals(email: authViewModel.email, mealId: meal.id)
            } label: {
                Text("Try again")
                    .font(.system(size: 16, weight: .bold, design: .rounded))
                    .padding()
                    .foregroundStyle(.white)
                    .background(.orange)
                    .cornerRadius(14)
            }
        }
    }
    
    private func loaded(_ plannedMeals: [PlannedMeal]) -> some View {
        VStack {
            Text(meal.name)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .padding(.top, 40)
            HStack {
                Text("You are going to enjoy it on:")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .padding()
                Spacer()
            }
            ScrollView(showsIndicators: false) {
                ForEach(plannedMeals) { plannedMeal in
                    HStack {
                        Text(plannedMeal.date.formatted(date: .long, time: .omitted))
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .frame(minWidth: 120)
                            .padding(.horizontal)
                        PlannedMealTag(type: MealType(rawValue:  plannedMeal.type))
                        Spacer()
                    }
                    .padding(.vertical, 5)
                }
            }
        }
    }
    
    private var header: some View {
        VStack {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.black)
                        .frame(height: 20)
                }
                Spacer()
            }
            Spacer()
        }
    }
    
    private var empty: some View {
        VStack {
            Text(meal.name)
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .padding(.vertical, 60)
            Text("No plans for this meal yet.")
                .font(.system(size: 20, weight: .bold, design: .rounded))
                .padding()
            Spacer()
        }
    }
}

struct PlannedMealTag: View {
    
    var type: MealType?
    
    var body: some View {
        if let type {
            Text(type.stringValue)
                .font(.system(size: 12, weight: .regular, design: .rounded))
                .padding(.horizontal)
                .padding(.vertical, 5)
                .foregroundStyle(type.tagForegroundColor)
                .background(type.tagBackgroundColor)
                .cornerRadius(8)
        } else {
            EmptyView()
        }
    }
}

#Preview {
    @Previewable @State var viewModel: MealPlanDetailViewModelProtocol = MockMealPlanDetailViewModel()
    MealPlanDetailView(viewModel: viewModel, meal: Meal(id: "1", name: "Pollo a la portuguesa", thumbnail: ""))
    
}

#Preview {
    @Previewable @State var viewModel: MealPlanDetailViewModelProtocol = MockEmptyMealPlanDetailViewModel()
    MealPlanDetailView(viewModel: viewModel, meal: Meal(id: "1", name: "Pollo a la portuguesa", thumbnail: ""))
    
}

#Preview {
    @Previewable @State var viewModel: MealPlanDetailViewModelProtocol = MockErrorMealPlanDetailViewModel()
    MealPlanDetailView(viewModel: viewModel, meal: Meal(id: "1", name: "Pollo a la portuguesa", thumbnail: ""))
    
}

@Observable
fileprivate class MockMealPlanDetailViewModel: MealPlanDetailViewModel {
    
    let meals = [PlannedMeal(id: "1", mealId: "1", type: 0, date: Date()),
                 PlannedMeal(id: "2", mealId: "1", type: 1, date: Calendar.current.date(byAdding: .day, value: 1, to: Date()) ?? Date()),
                 PlannedMeal(id: "3", mealId: "1", type: 2, date: Calendar.current.date(byAdding: .day, value: 2, to: Date()) ?? Date()),
                 PlannedMeal(id: "4", mealId: "1", type: 3, date: Calendar.current.date(byAdding: .day, value: 11, to: Date()) ?? Date())]
    
    override func fetchMeals(email: String, mealId: String) {
        state = .loaded(meals)
    }
}

@Observable
fileprivate class MockEmptyMealPlanDetailViewModel: MealPlanDetailViewModel {
    
    override func fetchMeals(email: String, mealId: String) {
        state = .empty
    }
}

@Observable
fileprivate class MockErrorMealPlanDetailViewModel: MealPlanDetailViewModel {
    
    override func fetchMeals(email: String, mealId: String) {
        state = .error
    }
}
