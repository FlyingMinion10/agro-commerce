import SwiftUI

struct RegisterView: View {
    @Binding var isAuthenticated: Bool
    @State private var email = ""
    @State private var password = ""
    @State private var phone = ""
    @State private var name = ""
    @State private var accountType = "Productor" // Tipo de cuenta predeterminado
    @State private var showAlert = false
    @State private var alertMessage = ""

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

            Picker("Tipo de cuenta", selection: $accountType) {
                Text("Productor").tag("Productor")
                Text("Bodeguero").tag("Bodeguero")
            }
            .padding()
            .pickerStyle(SegmentedPickerStyle())

            Button(action: {
                registerUser()
            }) {
                Text("Registrarse")
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
        }
        .padding()
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Mensaje"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }

    func registerUser() {
        guard let url = URL(string: "https://my-backend-production.up.railway.app/api/register") else {
            self.alertMessage = "URL inválida"
            self.showAlert = true
            return
        }

        let userData: [String: Any] = [
            "email": email,
            "password": password,
            "phoneNumber": phone,
            "name": name,
            "accountType": accountType,
        ]

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: userData)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.alertMessage = "Error en la solicitud: \(error.localizedDescription)"
                    self.showAlert = true
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    self.alertMessage = "Respuesta no válida del servidor."
                    self.showAlert = true
                }
                return
            }

            if httpResponse.statusCode == 200 {
                DispatchQueue.main.async {
                    self.isAuthenticated = true
                    self.alertMessage = "Registro exitoso"
                    self.showAlert = true
                }
            } else {
                DispatchQueue.main.async {
                    self.alertMessage = "Error en el servidor: \(httpResponse.statusCode)"
                    if let data = data, let responseBody = String(data: data, encoding: .utf8) {
                        self.alertMessage += "\n\(responseBody)"
                    }
                    self.showAlert = true
                }
            }
        }.resume()
    }
}
