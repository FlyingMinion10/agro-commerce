import SwiftUI

struct LoginView: View {
    @Binding var isAuthenticated: Bool
    @State private var email = ""
    @State private var password = ""
    @State private var isShowingRegister = false

    var body: some View {
        VStack {
            Text("Iniciar Sesión")
                .font(.largeTitle)
                .padding()

            TextField("Correo electrónico", text: $email)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)

            SecureField("Contraseña", text: $password)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: {
                // Lógica de autenticación
                loginUser(email: email, password: password)
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
    }

    func loginUser(email: String, password: String) {
        // Suponiendo que el login fue exitoso
        let credentials = "\(email):\(password)"
        if let credentialsData = credentials.data(using: .utf8) {
            KeychainHelper.shared.save(credentialsData, service: "com.tuapp.login", account: "userCredentials")
            isAuthenticated = true
        }
    }
}
