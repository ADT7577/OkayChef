//
//  DessertViewModel.swift
//  OkayChef
//
//  Created by Alexsa Tolentino on 11/23/23.
//

import Foundation
import SwiftUI

//STRINGS FOR JSON
    
struct Dessert: Codable{
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
}
    
struct DessertList: Codable {
let meals: [Dessert]
}

    
class DessertViewModel: ObservableObject{
        @Published var desserts: [Dessert] = []
        
        func fetchDesserts() {
            guard let url = URL(string: "https://themealdb.com/api/json/v1/1/filter.php?c=Dessert") else
            { return }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let decodeData = try JSONDecoder().decode(DessertList.self, from: data)
                        DispatchQueue.main.async {
                            self.desserts = decodeData.meals
                        }
                    } catch {
                        print("Error")
                    }
                }
            }.resume()
        }
    }
