

import SwiftUI


struct ContentView: View {
    let networkManager = NetworkManager()
    var body: some View{
        NavigationView{
        CategoryView(networkManager: networkManager)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
