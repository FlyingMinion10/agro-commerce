import SwiftUI

struct RegisterView: View {
    @Binding var isAuthenticated: Bool
    @State private var email = ""
    @State private var password = ""
    @State private var phone = ""
    @State private var name = ""

    var body: some View {
        VStack {
            Text("Registrarse")
                .font(.largeTitle)
                .padding()

            TextField("Correo electrónico", text: $email)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)

            SecureField("Contraseña", text: $password)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Teléfono", text: $phone)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            TextField("Nombre", text: $name)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: {
                // Lógica de registro
                isAuthenticated = true
            }) {
                Text("Registrarse")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}
