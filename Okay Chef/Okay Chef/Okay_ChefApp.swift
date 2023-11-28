

import SwiftUI

@main
struct MyApp: App {
    let networkManager = NetworkManager()
    
    var body: some Scene {
        WindowGroup {
        CategoryView(networkManager: networkManager)
        }
    }
}
