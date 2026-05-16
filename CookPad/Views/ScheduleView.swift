//
//  ScheduleView.swift
//  CookPad
//
//  Created by Mariano Arselan on 27-02-26.
//

import SwiftUI


enum MealType: Int, CaseIterable, Identifiable {
    var id: Self  { self }
    case breakfast, lunch, dinner, other
    
    var stringValue: String {
        switch self {
        case .breakfast: return "Breakfast"
        case .lunch: return "Lunch"
        case .dinner: return "Dinner"
        case .other: return "Other"
        }
    }
    
    var tagForegroundColor: Color {
        switch self {
        case .breakfast: return .white
        case .lunch: return .white
        case .dinner: return .black
        case .other: return .black
        }
    }
    
    var tagBackgroundColor: Color {
        switch self {
        case .breakfast: return .blue
        case .lunch: return .orange
        case .dinner: return .green
        case .other: return .gray
        }
    }
}

struct ScheduleView: View {
    var meal: Meal
    @State private var selectedDate = Date()
    @State private var type: MealType = .other
    @State private var viewModel = ScheduleMealViewModel()
    @Environment(\.authService) var authViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
       switch viewModel.state {
       case .initial(let docId):
           saveOrUpdate(docId: docId)
        case .errorSaving:
            Text("Error saving meal")
       case .errorUpdating(_):
           Text("Error saving meal")
        case .saved(let docId):
            saved(docId: docId)
       case .saving:
           DotsLoadingIndicator()
               .frame(maxHeight: .infinity)
       }
    }
    
    private func saved(docId: String) -> some View {
        VStack {
            HStack {
                Text(meal.name)
                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                    .padding(.horizontal, 30)
                Spacer()
                Button {
                    viewModel.edit(docId: docId)
                } label: {
                    Image(systemName: "pencil")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .padding()
                        .foregroundStyle(.black)
                }
            }
            HStack {
                Text("Scheduled for:")
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .padding(.leading, 30)
                Text(selectedDate.formatted(.dateTime.month(.wide).day().year()))
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                Spacer()
            }
            HStack {
                Text("Meal type:")
                    .font(.system(size: 16, weight: .regular, design: .rounded))
                    .padding(.leading, 30)
                PlannedMealTag(type: type)
                Spacer()
            }
            Button {
                dismiss()
            } label: {
                Text("Close")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.white)
                    .background(.orange)
                    .cornerRadius(14)
            }
            .padding(.vertical, 40)
            .padding(.horizontal)
            Spacer()
        }
        .padding(.vertical, 40)
    }
    
    private func saveOrUpdate(docId: String? = nil) -> some View {
        VStack {
            Text("Schedule meal")
                .font(.system(size: 24, weight: .bold, design: .rounded))
                .padding()
            ScrollView(showsIndicators: false) {
                HStack {
                    Text(meal.name)
                        .font(.system(size: 20, weight: .semibold, design: .rounded))
                        .padding(.horizontal, 30)
                    Spacer()
                }
                Picker("Meal type", selection: $type) {
                    ForEach(MealType.allCases) { type in
                        Text(type.stringValue)
                    }
                }
                .pickerStyle(.segmented).padding()
                DatePicker("Select Date",
                           selection: $selectedDate,
                           in: Date()...,
                           displayedComponents: [.date]
                )
                .tint(.orange)
                .datePickerStyle(.graphical)
                .padding(.horizontal)
                .foregroundStyle(.orange)
                Button {
                    if let docId {
                        viewModel.update(email: authViewModel.email, docId: docId, mealId: meal.id, type: type.rawValue, date: selectedDate)
                    } else {
                        viewModel.schedule(email: authViewModel.email, mealId: meal.id, type: type.rawValue, date: selectedDate)
                    }
                } label: {
                    Text(docId == nil ? "Schedule" : "Update")
                        .font(.system(size: 24, weight: .bold, design: .rounded))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundStyle(.white)
                        .background(.orange)
                        .cornerRadius(16)
                        .padding(.horizontal, 20)
                }
            }
        }
        .padding(.vertical)
    }
}

#Preview {
    ScheduleView(meal: Meal(id: "", name: "Stew", category: "Some category", thumbnail: "https://www.themealdb.com/images/media/meals/g046bb1663960946.jpg", ingredients: ["garlic", "olive oil", "tomatoes"], measures: ["1tbsp", "100gr", "2 cups"], instructions: "Mix everything", ytUrl: ""))
}

