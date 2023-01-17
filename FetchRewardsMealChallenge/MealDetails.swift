//
//  MealDetails.swift
//  FetchRewardsMealChallenge
//
//  Created by ANGEL RAMIREZ on 1/16/23.
//

import SwiftUI

struct MealDetails: View {
    @EnvironmentObject var model:ContentModel
    var mealID: String
    var body: some View {
        
        VStack {
            if model.dessertDetails.meals.count > 0 {
                ScrollView(showsIndicators: false) {
                    let mealDetails = model.dessertDetails.meals[0]
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundColor(.white)
                            .shadow(radius: 10, x: 5, y: 5)
                        
                        VStack {
                            
                            HStack {
                                Text(mealDetails.strMeal ?? "")
                                    .font(.title)
                                Spacer()
                                
                                Link(destination: URL(string: mealDetails.strYoutube ?? "https://www.youtube.com")!) {
                                    Image(systemName: "play.rectangle.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(height: 25)
                                        .foregroundColor(.red)
                                }
                            }
                            .padding(.top)
                            .padding(.horizontal)
                            
                            Divider()
                            if model.getImageFromCache(mealName: mealDetails.strMeal ?? "") == nil {
                                AsyncImage(url: URL(string: mealDetails.strMealThumb ?? "")) { phase in
                                    
                                    switch phase {
                                        
                                    case .empty:
                                        ProgressView()
                                        
                                    case .failure(let error):
                                        Text("Error Loading Image \(error.localizedDescription)")
                                            .multilineTextAlignment(.center)
                                        
                                    case .success(let image):
                                        
                                        image
                                            .resizable()
                                            .scaledToFit()
                                            .cornerRadius(10)
                                    @unknown default:
                                        ProgressView()
                                    }
                                    
                                }
                            }
                            else {
                                Image(uiImage: model.getImageFromCache(mealName: mealDetails.strMeal ?? "")!)
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(10)
                            }
                            Divider()
                            
                            
                            HStack {
                                
                                if mealDetails.strDrinkAlternate != nil {
                                    Spacer()
                                    Text(mealDetails.strDrinkAlternate ?? "")
                                }
                                if mealDetails.strCategory != nil {
                                    Spacer()
                                    Text(mealDetails.strCategory ?? "")
                                }
                                if mealDetails.strArea != nil {
                                    Spacer()
                                    Text(mealDetails.strArea ?? "")
                                }
                                Spacer()
                            }
                            .font(.caption)
                            .padding(.bottom, 5)
                            
                            if mealDetails.strTags != nil || mealDetails.strSource != nil {
                                Divider()
                            }
                            
                            HStack {
                                if mealDetails.strTags != nil {
                                    if mealDetails.strTags != "" {
                                       
                                        Text("Tags: \(mealDetails.strTags!)")
                                            .font(.caption)
                                           
                                    }
                                }
                                
                                Spacer()
                                
                                if mealDetails.strSource != nil {
                                    if mealDetails.strSource != "" {
                                       
                                        Link(destination: URL(string: mealDetails.strSource ?? "https://www.bbcgoodfood.com/")!) {
                                            
                                            Image(systemName: "network")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 20)
                                                .foregroundColor(.blue)
                                            
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.bottom, 10)
                        }
                    }
                    
                    HStack {
                        VStack(alignment: .leading) {
                            
                            Text("Ingredients:")
                                .font(.callout)
                                .fontWeight(.bold)
                                .padding(.bottom, 5)
                            
                            ForEach(getIngredientes(), id: \.self) { ingredient in
                                    
                                    Text(ingredient)
                                        .font(.caption)
                                
                            }
                           
                            
                            Divider()
                            
                            Text("Intructions:")
                                .font(.callout)
                                .fontWeight(.bold)
                            
                            Text(mealDetails.strInstructions ?? "")
                        }
                        .font(.caption)
                        
                        Spacer()
                    }
                }
            }
            else {
                if model.errorMesssage == "" {
                    ProgressView("Loading Recipe")
                }
                else {
                    Text(model.errorMesssage)
                        .font(.title2)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .padding(.horizontal, 10)
        .task {
            model.fetchDessertDetails(id: mealID) { sucess in
                
                if sucess {
                    model.errorMesssage = ""
                }
                else {
                    model.errorMesssage = "Sorry, there was an error while fetching the Dessert details"
                }
            }
        }
        
    }
    
    func getIngredientes() -> [String] {
        
        let mealDetails = model.dessertDetails.meals[0]
        var num = 1
        var ingredients = [String]()
        for ingredient in mealDetails.ingredients {
            
            if ingredient != "" {
                ingredients.append("\(num < 10 ? " " : "")\(num).- \(mealDetails.measure[num - 1]) \(ingredient)")
                num += 1
            }
            
        }
        
        return ingredients
    }
}

struct MealDetails_Previews: PreviewProvider {
    static var previews: some View {
        MealDetails(mealID: "")
            .environmentObject(ContentModel())
    }
}
