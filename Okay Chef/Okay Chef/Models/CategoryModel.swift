
import Foundation
import SwiftUI


struct Category:  Codable, Identifiable {
    let idCategory: String
    let strCategory: String
    let strCategoryThumb: String
    
    var id: String { idCategory }
}
