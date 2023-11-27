
import SwiftUI

//MODELS

struct Dessert:  Codable, Identifiable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
    
    var id: String { idMeal }
}

struct MealDetails: Codable {
    let strMeal: String
    let strMealThumb: String
    let strCategory: String
    let strInstructions: String
    let ingredients: [String]
    let measurements: [String]
    
    enum CodingKeys: String, CodingKey {
        case strMeal, strMealThumb, strCategory, strInstructions
        case strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5
        case strMeasure1, strMeasure2, strMeasure3, strMeasure4, strMeasure5
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        strMeal = try container.decode(String.self, forKey: .strMeal)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(strMeal, forKey: .strMeal)
        try container.encode(strMealThumb, forKey: .strMealThumb)
        try container.encode(strCategory, forKey: .strCategory)
        try container.encode(strInstructions, forKey: .strInstructions)
        
        
        
        // Encode ingredients
        for (index, ingredient) in ingredients.enumerated() {
            if let key = CodingKeys(stringValue: "strIngredient\(index + 1)") {
                try container.encode(ingredient, forKey: key)
            }
        }
        
        // Encode measurements
        for (index, measurement) in measurements.enumerated() {
            if let key = CodingKeys(stringValue: "strMeasure\(index + 1)") {
                try container.encode(measurement, forKey: key)
            }
        }
    }
}

//FETCH API

class NetworkManager: ObservableObject {
    @Published var desserts: [Dessert] = []
    @Published var selectedMeal: MealDetails?
    
    
    //DESSERTS
    
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
                        let ingredients = extractIngredients(from: mealDetails)
                        let measurements = extractMeasurements(from: mealDetails)
                        
                        let updatedMealDetails = MealDetails(
                            strMeal: mealDetails.strMeal,
                            strMealThumb: mealDetails.strMealThumb,
                            strCategory: mealDetails.strCategory,
                            strInstructions: mealDetails.strInstructions,
                            ingredients: extractIngredients(from: mealDetails),
                            measurements: extractMeasurements(from: mealDetails)
                        )
                        
                        DispatchQueue.main.async {
                            self.selectedMeal = updatedMealDetails
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


//Views


struct ContentView: View {
    @StateObject var networkManager = NetworkManager()
    
    var body: some View {
        NavigationView {
            List(networkManager.desserts) { dessert in
                NavigationLink(destination: DetailView(networkManager: networkManager, dessert: dessert)) {
                    Text(dessert.strMeal)
                }
            }
            .navigationTitle("Desserts")
        }
        .onAppear{
            networkManager.fetchDesserts()
        }
    }
}

struct DetailView: View {
    @ObservedObject var networkManager: NetworkManager
    let dessert: Dessert

    var body: some View {
        VStack {
            if let meal = networkManager.selectedMeal {
                Text("\(meal.strMeal)")
                Text("\(meal.strInstructions)")
                Text("Ingredients:")
                 List {
                    ForEach(0..<min(meal.ingredients.count, meal.measurements.count), id: \.self) { index in
                        Text("\(meal.measurements[index]) \(meal.ingredients[index])")
                    }
                }
                // Display other meal details here
            } else {
                Text("Loading...")
            }
        }
        .onAppear {
            networkManager.fetchMealDetails(for: dessert)
        }
        .navigationTitle("Meal Details")
    }
}


//PREVIEW
struct ContentView_Preview: PreviewProvider{
    static var previews: some View {
     ContentView()
    }
}
