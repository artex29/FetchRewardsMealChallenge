//
//  ContentView.swift
//  FetchRewardsMealChallenge
//
//  Created by ANGEL RAMIREZ on 1/16/23.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var model: ContentModel
    @State var searchMeal = ""
  
    
    var body: some View {
        
        NavigationStack {
            if model.meals.meals.count > 0 {
                
                List(model.filteredMeals) { meal in
                    NavigationLink {
                        MealDetails(mealID: meal.idMeal)
                        
                    } label: {
                        MealRow(meal: meal)
                            .searchable(text: $searchMeal)
                        
                    }
                    .onChange(of: searchMeal) { newValue in
                        model.filterMeals(filterBy: searchMeal.lowercased().trimmingCharacters(in: .whitespacesAndNewlines))
                    }
                    
                }
                .onAppear {
                    model.filterMeals(filterBy: searchMeal.lowercased().trimmingCharacters(in: .whitespacesAndNewlines))
                }
                .navigationTitle("Delicious Desserts")
                .navigationBarTitleDisplayMode(.inline)
                
            }
            else {
                if model.errorMesssage == "" {
                    ProgressView("Loading Delicious Desserts")
                }
                else {
                    Text(model.errorMesssage)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                        
                }
            }
            
        }
        .task {
            model.filterMeals(filterBy: searchMeal.lowercased().trimmingCharacters(in: .whitespacesAndNewlines))
        }
        
    }
    
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ContentModel())
    }
}
