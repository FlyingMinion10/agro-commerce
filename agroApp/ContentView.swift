import SwiftUI
import FirebaseAuth


struct ContentView: View {
    @State private var isAuthenticated = false
    @State private var selectedTab = 4

    var body: some View {
        VStack {
//            if isAuthenticated {
            if true {
                MainTabView(selectedTab: $selectedTab, isAuthenticated: $isAuthenticated)
            } else {
                LoginView(isAuthenticated: $isAuthenticated)
            }
        }
        .onAppear {
            checkIfLoggedIn()
        }
    }

    func checkIfLoggedIn() {
        // Verificar si las credenciales existen en el Keychain
        if let credentialsData = KeychainHelper.shared.read(service: "com.tuapp.login", account: "userCredentials"),
           let credentials = String(data: credentialsData, encoding: .utf8) {
            print("Credenciales encontradas: \(credentials)")
            isAuthenticated = true
        } else {
            isAuthenticated = false
        }
    }
}


struct MainTabView: View {
    @Binding var selectedTab: Int
    @Binding var isAuthenticated: Bool
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Inicio")
                }
                .tag(1)
            
            CanvasView()
                .tabItem {
                    Image(systemName: "carrot")
                    Text("Productos")
                }
                .tag(2)
            
            PublicationCreatorView()
                .tabItem {
                    Image(systemName: "plus.square.dashed")
                    Text("Crear Producto")
                }
                .tag(5)
            
            ChatsView()
                .tabItem {
                    Image(systemName: "bell.badge")
                    Text("Mensajes")
                }
                .tag(3)
            
            ProfileView(isAuthenticated: $isAuthenticated)
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Cuenta")
                }
                .tag(4)
        }
        .onAppear {
            Task {
                await authenticateAnonymously()
            }
        }

    }
    func authenticateAnonymously() async {
        // print("Deberia autenticarse en Firebase.")
        // do {
        //     let authResult = try await Auth.auth().signInAnonymously()
        //     let user = authResult.user
        //     print("Usuario autenticado anónimamente con UID: \(user.uid)")
        // } catch {
        //     print("Error en autenticación anónima: \(error.localizedDescription)")
        // }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
