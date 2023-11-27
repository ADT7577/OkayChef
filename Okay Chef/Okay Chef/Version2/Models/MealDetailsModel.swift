

import Foundation
import SwiftUI


//MEAL DETAILS

struct MealDetails: Codable {
    let strMeal: String
    let strMealThumb: String
    let strCategory: String
    let strInstructions: String
    let ingredients: [String]
    let measurements: [String]
    
    enum CodingKeys: String, CodingKey {
        case strMeal, strMealThumb, strCategory, strInstructions
        case strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5, strIngredient6, strIngredient7, strIngredient8, strIngredient9, strIngredient10, strIngredient11, strIngredient12, strIngredient13, strIngredient14, strIngredient15, strIngredient16, strIngredient17, strIngredient18, strIngredient19, strIngredient20
        case strMeasure1, strMeasure2, strMeasure3, strMeasure4, strMeasure5, strMeasure6, strMeasure7, strMeasure8, strMeasure9, strMeasure10, strMeasure11, strMeasure12, strMeasure13, strMeasure14, strMeasure15, strMeasure16, strMeasure17, strMeasure18, strMeasure19, strMeasure20
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        strMeal = try container.decode(String.self, forKey: .strMeal)
        strMealThumb = try container.decode(String.self, forKey: .strMealThumb)
        strCategory = try container.decode(String.self, forKey: .strCategory)
        strInstructions = try container.decode(String.self, forKey: .strInstructions)
        
        var extractedIngredients: [String] = []
        var extractedMeasurements: [String] = []
    
        for i in 1...20 {
            if let ingredientKey = CodingKeys(stringValue: "strIngredient\(i)"),
               let measurementKey = CodingKeys(stringValue: "strMeasure\(i)") {
                if let ingredient = try container.decodeIfPresent(String.self, forKey: ingredientKey), !ingredient.isEmpty {
                    extractedIngredients.append(ingredient)
                }
                if let measurement = try container.decodeIfPresent(String.self, forKey: measurementKey), !measurement.isEmpty {
                    extractedMeasurements.append(measurement)
                }
            }
        }

        ingredients = extractedIngredients
        measurements = extractedMeasurements
   }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        for (index, ingredient) in ingredients.enumerated() {
            if let key = CodingKeys(stringValue: "strIngredient\(index + 1)") {
                try container.encode(ingredient, forKey: key)
            }
        }
        for (index, measurement) in measurements.enumerated() {
            if let key = CodingKeys(stringValue: "strMeasure\(index + 1)") {
                try container.encode(measurement, forKey: key)
            }
        }
    }
    
}
