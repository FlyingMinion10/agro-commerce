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
            if let error = error {
                DispatchQueue.main.async {
                    alertMessage = "Error en la solicitud: \(error.localizedDescription)"
                    showAlert = true
                }
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    alertMessage = "Error en la respuesta del servidor"
                    showAlert = true
                }
                return
            }
            if httpResponse.statusCode == 200 {
                guard let data = data else {
                    DispatchQueue.main.async {
                        alertMessage = "Datos no recibidos"
                        showAlert = true
                    }
                    return
                }
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let responseDict = json as? [String: Any],
                        let userData = responseDict["userData"] as? [String: Any] else {
                        DispatchQueue.main.async {
                            alertMessage = "Error al procesar los datos del usuario"
                            showAlert = true
                        }
                        return
                    }
                    print(responseDict)
                    let name = userData["name"] as? String
                    let accountType = userData["accountType"] as? String
                    let email = userData["email"] as? String
                    // Almacenar datos del usuario de forma local
                    UserDefaults.standard.set(name, forKey: "profileName")
                    UserDefaults.standard.set(accountType, forKey: "accountType")
                    UserDefaults.standard.set(email, forKey: "email")
                    
                    DispatchQueue.main.async {
                        isAuthenticated = true
                        alertMessage = "Inicio de sesión exitoso"
                        showAlert = true
                    }
                } catch {
                    DispatchQueue.main.async {
                        alertMessage = "Error al decodificar los datos: \(error.localizedDescription)"
                        showAlert = true
                    }
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
