import SwiftUI

struct ContentView: View {
    @State private var selectedTab = 2
    // Cambia el número para la vista predeterminada que desees
    @State private var currentIndex = 0
    let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    let screenWidth = UIScreen.main.bounds.width // Obtiene el ancho de la pantalla

    var body: some View {
        VStack {
            
//
            HStack {
            
            }
            .frame(width: screenWidth, height: 1)
            .background(Color.white)

            // Opciones en la parte inferior
            HStack {
                TabView(selection: $selectedTab) {
                    HomeView()
                        .tabItem {
                            Image(systemName: "house")
                            Text("Inicio")
                        }
                    
                    CanvasView()
                        .tabItem {
//                            Image(systemName: "dollarsign.circle")
                            Image(systemName: "carrot")
                            
                            Text("Productos")
                        }
                        .tag(2)
                    
                    PublicationCreatorView()
                        .tabItem {
                            Image(systemName: "plus.square.dashed")
                            Text("Productos")
                        }
                        .tag(5)
                    
                    ChatsView()
                        .tabItem {
                            Image(systemName: "bell.badge")
                            Text("Mensajes")
                        }
                        .tag(3)
                    
                    ProfileView()
                        .tabItem {
                            Image(systemName: "person.crop.circle")
                            Text("Cuenta")
                        }
                        .tag(4)
                }
//                .frame(width: screenWidth, height: 100)
            }
        }
//        .padding() // Agrega espacio alrededor de los elementos
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
