import SwiftUI

struct BodegaStep: View {
    let screenWidth = UIScreen.main.bounds.width
    
    // MARK: - State Variables
    let publisherName: String = ProfileView.profileName
    let userType: String = ProfileView.accountType
    let userEmail: String = ProfileView.email

    // Condiciones importadas de CHATVIEW
    var interaction_id: Int
    
    // Valores a recopilar para crear la orden de transporte
    @State private var destino: String = ""
    @State private var fecha_de_llegada: String = ""
    @State private var coste_flete: String = ""
    @State private var tipo_de_camion: String = ""
    
    // Valores obtenidos de RanchoStep
    @State private var coste_flete_sug: String = ""
    @State private var tipo_de_camion_sug: String = ""
    
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
                    Text("Información de entrega")
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
                         Text("En estos campos usted debera registrar la infromación relacionada con la entrega del producto, rellenelos con cuidado.\n")
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
                                Text("Ingrese la fecha aproximada de llegada")
                                TextField("dd/mm/yyyy", text: $fecha_de_llegada)
                                    .keyboardType(.numberPad)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            // MARK: - Lugar de destino
                            VStack {
                                Text("Ingrese la ubicación exacta de la bodega")
                                TextEditor(text: $destino)
                                    .frame(height: 100)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                                    )
                                    .onChange(of: destino) { oldValue, newValue in
                                        let limit = 140
                                        if newValue.count > limit {
                                            destino = String(newValue.prefix(limit))
                                        }
                                    }
                            }
                            // MARK: - Coste del flete
                            VStack {
                                Text("El importe aproximado a pagar por el transporte del producto a comprar")
                                HStack {
                                    TextField("\(coste_flete_sug) (Sugerencia del agricultor)", text: $coste_flete)
                                        .keyboardType(.numberPad)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                    Text("$MXN /Km")
                                }
                            }
                            // MARK: - Tipo de camión
                            VStack {
                                Text("Ingrese el tipo de camión que solicitará")
                                TextField("\(tipo_de_camion_sug) (Sugerencia del agricultor)", text: $tipo_de_camion)
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
            .onAppear(perform: fetchValues) // fetchValues()
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Helper Functions
    func isFormValid() -> Bool {
        return !destino.isEmpty && !fecha_de_llegada.isEmpty && !coste_flete.isEmpty && !tipo_de_camion.isEmpty
    }

    func clearForm() {
        destino = ""
        fecha_de_llegada = ""
        coste_flete = ""
        tipo_de_camion = ""
    }

    func fetchValues() {
        guard let baseUrl = URL(string: "https://my-backend-production.up.railway.app/api/step-two/get") else {
            print("URL no válida")
            return
        }

        // Construir la URL con el parámetro de consulta
        var urlComponents = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false)!
        urlComponents.queryItems = [
            URLQueryItem(name: "interaction_id", value: String(interaction_id)), // Convertir Int? a String?
        ]

        guard let url = urlComponents.url else {
            print("URL no válida")
            return
        }

        // print("URL final: \(url)") // PRINT FOR DEBUG

        var request = URLRequest(url: url)
        request.cachePolicy = .reloadIgnoringLocalCacheData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error fetching publications: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No se recibieron datos de la bodega.")
                return
            }

        //     // Imprimir los datos recibidos en formato JSON
        //    if let jsonString = String(data: data, encoding: .utf8) {
        //        print("Datos recibidos del servidor Monopoly: \(jsonString)") // PRINT FOR DEBUG
        //    }

                       do {
                let decodedResponse = try JSONDecoder().decode([[String: String]].self, from: data)
                DispatchQueue.main.async {
                    print("Respuesta decodificada correctamente: \(decodedResponse)") // PRINT FOR DEBUG
            
                    // Asumiendo que solo necesitamos el primer diccionario del array
                    if let firstResponse = decodedResponse.first,
                       let costeFlete = firstResponse["coste_flete"],
                       let tipoDeCamion = firstResponse["tipo_de_camion"] {
                        self.coste_flete_sug = costeFlete
                        self.tipo_de_camion_sug = tipoDeCamion
                    }
                }
            } catch {
                print("Error al decodificar datos de la bodega: \(error)")
                if let decodingError = error as? DecodingError {
                    switch decodingError {
                    case .typeMismatch(let key, let context):
                        print("Tipo no coincide para la clave \(key), \(context.debugDescription)")
                    case .valueNotFound(let key, let context):
                        print("Valor no encontrado para la clave \(key), \(context.debugDescription)")
                    case .keyNotFound(let key, let context):
                        print("Clave no encontrada \(key), \(context.debugDescription)")
                    case .dataCorrupted(let context):
                        print("Datos corruptos: \(context.debugDescription)")
                    @unknown default:
                        print("Error desconocido de decodificación")
                    }
                }
            }
        }.resume()
    }

     func saveToDatabase() {
        guard let url = URL(string: "https://my-backend-production.up.railway.app/api/step-two/post") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")


        // Crear el diccionario con los datos formateados
        let productData: [String: Any] = [
            "interaction_id": interaction_id,
            "destino": destino,
            "fecha_de_llegada": fecha_de_llegada,
            "coste_flete": coste_flete,
            "tipo_de_camion": tipo_de_camion
        ]

        // Serializar los datos a JSON
        guard let httpBody = try? JSONSerialization.data(withJSONObject: productData, options: []) else {
            print("Error al serializar los datos de la bodega")
            return
        }

        request.httpBody = httpBody

        // Crear y ejecutar la tarea de red
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error al guardar los datos de la bodega: \(error)")
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

struct BodegaStep_Previews: PreviewProvider {
    static var previews: some View {
        BodegaStep(interaction_id: 1)
    }
}
