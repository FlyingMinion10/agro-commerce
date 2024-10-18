import SwiftUI

struct ContratoStep: View {
    @State private var isAccepted: Bool = false
    var interaction_id: Int
    var step: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("Términos y Condiciones")
                .font(.title)
                .padding(.bottom, 10)
            
            ScrollView {
                Text("""
                Aquí van los términos y condiciones detallados...
                """)
                .padding()
            }
            .frame(height: 300)
            .border(Color.gray, width: 1)
            if step == 1 {
                HStack {
                    CheckBoxView(isChecked: $isAccepted)
                    Text("Acepto los términos y condiciones")
                }
                
                Button(action: {
                    // Acción al enviar
                }) {
                    Text("Enviar")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(isAccepted ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(!isAccepted)
            } else {
                    HStack {
                        Text("Terminos y condiciones aceptados")
                            .font(.system(size: 20))
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(.green)
                    }
                }
        }
        .padding()
    }

    func saveToDatabase() {
        guard let url = URL(string: "https://my-backend-production.up.railway.app/api/step-four/post") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")


        // Crear el diccionario con los datos formateados
        let productData: [String: Any] = [
            "interaction_id": interaction_id
        ]

        // Serializar los datos a JSON
        guard let httpBody = try? JSONSerialization.data(withJSONObject: productData, options: []) else {
            print("Error al guardar contrato")
            return
        }

        request.httpBody = httpBody

        // Crear y ejecutar la tarea de red
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error al guardar contrato: \(error)")
                return
            }

            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Error al guardar contrato")
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Respuesta del servidor: \(json)")
                    // Aquí puedes manejar la respuesta del servidor
                }
            } catch {
                print("Error al decodificar la respuesta JSON")
            }
        }.resume()
    }
}

struct CheckBoxView: View {
    @Binding var isChecked: Bool
    
    var body: some View {
        Button(action: {
            isChecked.toggle()
        }) {
            Image(systemName: isChecked ? "checkmark.square" : "square")
                .foregroundColor(isChecked ? .blue : .gray)
                .font(.system(size: 20))
        }
    }
}

struct ContratoStep_Previews: PreviewProvider {
    static var previews: some View {
        ContratoStep(interaction_id: 1, step: 1)
    }
}
