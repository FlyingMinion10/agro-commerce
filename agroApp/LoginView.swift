import SwiftUI

struct LoginView: View {
    @Binding var isAuthenticated: Bool
    @State private var userInput = ""
    @State private var password = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isShowingRegister = false

    var body: some View {
        VStack {
            Text("Iniciar Sesión")
                .font(.largeTitle)
                .padding()

            TextField("Correo electrónico o teléfono", text: $userInput)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)

            SecureField("Contraseña", text: $password)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: {
                loginUser()
            }) {
                Text("Iniciar Sesión")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            
            Button(action: {
                isShowingRegister = true
            }) {
                Text("Registrarse")
                    .foregroundColor(.blue)
            }
            .sheet(isPresented: $isShowingRegister) {
                RegisterView(isAuthenticated: $isAuthenticated)
            }
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Mensaje"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    func loginUser() {
        guard let url = URL(string: "https://my-backend-production.up.railway.app/api/login?userInput=\(userInput)&password=\(password)") else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                DispatchQueue.main.async {
                    alertMessage = "Error en la solicitud"
                    showAlert = true
                }
                return
            }

            if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                DispatchQueue.main.async {
                    isAuthenticated = true
                    alertMessage = "Inicio de sesión exitoso"
                    showAlert = true
                }
            } else {
                DispatchQueue.main.async {
                    alertMessage = "Credenciales inválidas"
                    showAlert = true
                }
            }
        }.resume()
    }
}
