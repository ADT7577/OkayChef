

import Foundation
import SwiftUI

//DESSERT

struct Dessert:  Codable, Identifiable {
    let idMeal: String
    let strMeal: String
    let strMealThumb: String
    
    var id: String { idMeal }
}
