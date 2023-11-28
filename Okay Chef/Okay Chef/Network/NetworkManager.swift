

import Foundation
import SwiftUI

//FETCH API


class NetworkManager: ObservableObject {
    @Published var categories: [Category] = []
    @Published var desserts: [Dessert] = []
    @Published var selectedMeal: MealDetails?
        
    //DESSERTS
    
    func fetchCategory(){
        guard let url = URL(string: "https://www.themealdb.com/api/json/v1/1/categories.php") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
            print("No Category Data")
                return
            }
            do {
                let response = try JSONDecoder().decode([String: [Category]].self, from: data)
                if let categories = response["categories"] {
                    DispatchQueue.main.async {
                        self.categories = categories
                    }
                }
            } catch {
                print("Error on the category fetch")
            }
        }.resume()
    }
        
    func fetchDesserts(){
        guard let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                print("There's no data here!!")
                return
            }
            do {
                let response = try JSONDecoder().decode([String: [Dessert]].self, from: data)
                if let desserts = response["meals"] {
                    DispatchQueue.main.async {
                        self.desserts = desserts
                    }
                }
            } catch {
                print("ERROR trying to get that dessert")
            }
        }.resume()
    }
    
  
   //MEAL DETAILS
    func fetchMealDetails(for dessert: Dessert) {
        guard let url = URL(string:"https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(dessert.idMeal)") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { [self] data, response, error in
            if let data = data {
                do {
                    let response = try JSONDecoder().decode([String: [MealDetails]].self, from: data)
                    if let mealDetails = response.values.first?.first {
                        DispatchQueue.main.async{
                            self.selectedMeal = mealDetails
                        }
                  }
                } catch {
                    print("Error decoding JSON: \(error)")
                    if let jsonString = String(data: data, encoding: .utf8) {
                        print("JSON String: \(jsonString)")
                    }
                }
            } else {
                print("No Data Recieved Over Here Buddy")
            }
        }.resume()
    }

 
 
    
    
    
    
    
    
//PRIVATE FUNCTIONS
    
    //INGREDIENTS
    private func extractIngredients(from meal: MealDetails) -> [String] {
        var ingredients: [String] = []
        let mirror = Mirror(reflecting: meal)
        for case let (label?, value) in mirror.children {
            if label.hasPrefix("strIngredient"), let ingredient = value as? String, !ingredient.isEmpty {
                ingredients.append(ingredient)
            }
        }
        return ingredients
    }

    
    //MEASUREMENTS

    private func extractMeasurements(from meal: MealDetails) -> [String] {
        var measurements: [String] = []
        let mirror = Mirror(reflecting: meal)
        for case let (label?, value) in mirror.children {
            if label.hasPrefix("strMeasure"), let measurement = value as? String, !measurement.isEmpty {
                measurements.append(measurement)
            }
        }
        return measurements
    }
}

  
