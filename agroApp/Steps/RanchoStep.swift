import SwiftUI

struct JustifiedText: UIViewRepresentable {
    var text: String

    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.isEditable = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        textView.textAlignment = .justified
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.textContainerInset = .zero
        textView.textContainer.lineFragmentPadding = 0
        return textView
    }

    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
}

struct RanchoStep: View {
    let screenWidth = UIScreen.main.bounds.width
    
    // MARK: - State Variables
    let publisherName: String = ProfileView.profileName
    let userType: String = ProfileView.accountType
    let userEmail: String = ProfileView.email

    // Condiciones importadas de CHATVIEW
    var interaction_id: Int
    
    // Valores a recopilar para crear la orden de transporte
    @State private var origen: String = ""
    @State private var instrucciones_rancho: String = ""
    @State private var fecha_de_corte: String = ""
    @State private var coste_flete: String = ""
    @State private var tipo_de_camion: String = ""
    
    // Nuevo estado para controlar la alerta
    @State private var showSuccessAlert = false
    @Environment(\.dismiss) var dismiss
    

    var body: some View {
        NavigationView {
            VStack {
                // MARK: - Header
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 24))
                    }
                    Spacer()
                    Text("Información de recolección")
                        .font(.system(size: 24))
                    Spacer()
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "ellipsis")
                            .font(.system(size: 24))
                    }
                }
                .padding()
                .frame(width: screenWidth, height: 60)
                .background(Color.white)
                
                // MARK: - Field
                ScrollView {
                    VStack(spacing: 20) {
                         Text("En estos campos usted debera registrar la infromación relacionada con la recolección de su producto, rellenelos con cuidado.\n")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal)
                            .multilineTextAlignment(.leading) 
                            .overlay(
                                Capsule()
                                    .frame(height: 1) // Altura del borde
                                    .foregroundColor(.gray), alignment: .bottom // Color y alineación del borde
                            )
                        
                        VStack(spacing: 15) {
                            // MARK: - Fecha de corte
                            VStack {
                                Text("Ingrese la fecha aproximada de corte")
                                TextField("dd/mm/yyyy", text: $fecha_de_corte)
                                    .keyboardType(.numberPad)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            // MARK: - Lugar de origen
                            VStack {
                                Text("Ingrese la ubicación exacta del lugar de recolección")
                                TextEditor(text: $origen)
                                    .frame(height: 100)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                    )
                                    .onChange(of: origen) { oldValue, newValue in
                                        let limit = 140
                                        if newValue.count > limit {
                                            origen = String(newValue.prefix(limit))
                                        }
                                    }
                            }
                            // MARK: - Intrucciones
                            VStack {
                                Text("Ingrese instrucciones para el transportista")
                                TextEditor(text: $instrucciones_rancho)
                                    .frame(height: 100)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                    )
                                    .onChange(of: instrucciones_rancho) { oldValue, newValue in
                                        let limit = 140
                                        if newValue.count > limit {
                                            instrucciones_rancho = String(newValue.prefix(limit))
                                        }
                                    }
                            }
                            // MARK: - Coste del flete
                            VStack {
                                Text("El importe total que estaría dispuesto a pagar por el transporte de su producto")
                                HStack {
                                    TextField("Moneda nacional mexicana", text: $coste_flete)
                                        .keyboardType(.numberPad)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                    Text("$ MXN")
                                }
                            }
                            // MARK: - Tipo de camión
                            VStack {
                                Text("Qué tipo de contenedor sugiere usar?")
                                TextField("Tipo de contenedor", text: $tipo_de_camion)
                                    .keyboardType(.numberPad)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                        }
                        // MARK: - Submit Button
                        Button(action: {
                            saveToDatabase()
                        }) {
                            Text("Publicar")
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(12)
                                // Mostrar la alerta cuando `showSuccessAlert` es verdadero
                                .alert(isPresented: $showSuccessAlert) {
                                    Alert(
                                        title: Text("¡Éxito!"),
                                        message: Text("Publicación creada exitosamente."),
                                        dismissButton: .default(Text("OK"), action: {
                                            // Reiniciar la alerta después de que se cierre
                                            showSuccessAlert = false
                                        })
                                    )
                                }
                        }
                        .padding(.horizontal)
                        .disabled(!isFormValid())
                        .opacity(isFormValid() ? 1 : 0.5)
                        
                    }
                    .padding(30)
                }
                .background(Color.gray.opacity(0.1))
            }
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Helper Functions
    func isFormValid() -> Bool {
        return !origen.isEmpty && !fecha_de_corte.isEmpty && !coste_flete.isEmpty && !tipo_de_camion.isEmpty
    }

    func clearForm() {
        origen = ""
        fecha_de_corte = ""
        coste_flete = ""
        tipo_de_camion = ""
    }

    func saveToDatabase() {
        guard let url = URL(string: "https://my-backend-production.up.railway.app/api/step-one/post") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")


        // Crear el diccionario con los datos formateados
        let productData: [String: Any] = [
            "interaction_id": interaction_id,
            "origen": origen,
            "fecha_de_corte": fecha_de_corte,
            "coste_flete": coste_flete,
            "tipo_de_camion": tipo_de_camion
        ]

        // Serializar los datos a JSON
        guard let httpBody = try? JSONSerialization.data(withJSONObject: productData, options: []) else {
            print("Error al serializar los datos del producto")
            return
        }

        request.httpBody = httpBody

        // Crear y ejecutar la tarea de red
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error al guardar los datos: \(error)")
                return
            }

            guard let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                print("Error en la respuesta del servidor")
                return
            }

            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print("Respuesta del servidor: \(json)")
                    // Aquí puedes manejar la respuesta del servidor
                    showSuccessAlert = true
                    clearForm()
                }
            } catch {
                print("Error al decodificar la respuesta JSON")
            }
        }.resume()
    }
}

struct RanchoStep_Previews: PreviewProvider {
    static var previews: some View {
        RanchoStep(interaction_id: 1)
    }
}
