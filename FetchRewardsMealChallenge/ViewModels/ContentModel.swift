//
//  ContentModel.swift
//  FetchRewardsMealChallenge
//
//  Created by ANGEL RAMIREZ on 1/16/23.
//

import Foundation
import UIKit
import SwiftUI

class CacheManager {
    static let instance = CacheManager()
    private init() {}
    
    var imageCache: NSCache<NSString, UIImage> = {
        let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 100
        cache.totalCostLimit = 1024 * 1024 * (100)
        return cache
    }()
    
    func addToCache(image: UIImage, mealName: String) {
        
        imageCache.setObject(image, forKey: mealName as NSString)
        print ("Added to cache!")
    }
    
    func getImageFromCache(mealName: String) -> UIImage? {
        return imageCache.object(forKey: mealName as NSString)
    }
}

class ContentModel: ObservableObject {
    
    @Published var errorMesssage = ""
    
    init() {
        fetchDesserts { [self] success in
            
            if success {
                errorMesssage = ""
            }
            else {
                errorMesssage = "There was an error while fetching your recipes"
            }
        }
    }
    
    @Published var meals:Meals = Meals()
    @Published var dessertDetails = DessertDetails()
    @Published var filterText = ""
    @Published var filteredMeals = Meals().meals
    let cacheManager = CacheManager.instance
    
    
    func saveToCache(image: UIImage, mealName: String) {
        cacheManager.addToCache(image: image, mealName: mealName)
        
    }
    
    func getImageFromCache(mealName: String) -> UIImage? {
        return cacheManager.getImageFromCache(mealName: mealName)
       
    }
    
    func fetchDesserts(completion: @escaping(Bool) -> Void) {
        
        let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert")
        
        if let url = url {
            
            let request = URLRequest(url: url)
            
            let session = URLSession.shared
            
            let task = session.dataTask(with: request) { data, response, error in
                
                guard error == nil && data != nil && response != nil else {return}
                
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(Meals.self, from: data!)
                    
                    DispatchQueue.main.async { [self] in
                        meals = result
                        completion(true)
                    }
                }
                catch {
                    // Notify the UI
                    completion(false)
                }
            }
            
            task.resume()
        }
    }
    
    
    func fetchDessertDetails(id: String, completion: @escaping(Bool) -> Void) {
        
        let url = URL(string: "https://themealdb.com/api/json/v1/1/lookup.php?i=\(id)")
        
        if let url = url {
            
            let request = URLRequest(url: url)
            
            let session = URLSession.shared
            
            let task = session.dataTask(with: request) { [self] data, response, error in
                
                if error == nil {
                    
                    guard response != nil && data != nil else {return}
                    
                    
                    do {
                        let decoder = JSONDecoder()
                        
                        let result = try decoder.decode(DessertDetails.self, from: data!)
                        DispatchQueue.main.async {
                            self.dessertDetails = result
                            
                           completion(true)
                        }
                       
                        
                    }
                    catch {
                        //  Notify the UI
                        completion(false)
                        
                    }
                }
                else {
                    // notify the UI
                    completion(false)
                }
                
            }
            
            task.resume()
        }
    }
    
    
    func filterMeals(filterBy: String) {
        self.filterText = filterBy
        
        if self.filterText  != "" {
            
            self.filteredMeals = meals.meals.filter ({ meal in
                
                meal.strMeal.lowercased().contains(self.filterText)
            })
        }
        else {
            self.filteredMeals = meals.meals
        }
    }
    
    
}
