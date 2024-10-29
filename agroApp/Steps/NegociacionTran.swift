import SwiftUI

struct MyOffer: Decodable {
    let fecha_de_corte: String
    let fecha_de_llegada: String
    let coste_flete: String
    let tipo_de_camion: String
}

struct TransportOffer: Identifiable, Codable {
    var id: Int?
    let email_tran: String
    let empresa_tran: String
    let coste_flete: String
    let fecha_de_llegada: String
    let last_mod: String
    let accepted: Bool
}

struct NegociacionTran: View {
    let screenWidth = UIScreen.main.bounds.width
    
    // MARK: - State Variables
    let publisherName: String = ProfileView.profileName
    let userType: String = ProfileView.accountType
    let userEmail: String = ProfileView.email

    // Condiciones importadas de CHATVIEW
    var interaction_id: Int
    var producto_completo: String

    // Variables para almacenar las publicaciones
    @State private var transportOffers: [TransportOffer] = []
    
    // Valores a recopilar para crear la orden de transporte
    @State private var fecha_de_corte: String = "fecha_de_corte"
    @State private var fecha_de_llegada: String = "fecha_de_llegada"
    @State private var coste_flete: String = "coste_flete"
    @State private var tipo_de_camion: String = "tipo_de_camion"
    
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
                    Text("Negociación del transporte")
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
                .overlay(
                    Capsule()
                        .frame(height: 1) // Altura del borde
                        .foregroundColor(.accentColor), alignment: .bottom // Color
                )
                
                // MARK: - Datos iniciales
                VStack (alignment: .leading) {
                    HStack {
                        Image(producto_completo.components(separatedBy: " ").first ?? "Manzana") // Remplazar por la imagen del producto real
                            .resizable()
                            .frame(width: 100, height: 100)
                        Text(producto_completo)
                            .font(.system(size: 25))
                    }
                    HStack {
                        VStack (alignment: .leading) {
                            Text("Fecha de corte:")
                            Text("Fecha de llegada:")
                            Text("Coste de flete:")
                            Text("Tipo de camión:")
                        }
                        Spacer()
                        VStack (alignment: .leading) {
                            Text(fecha_de_corte)
                            Text(fecha_de_llegada)
                            Text(coste_flete)
                            Text(tipo_de_camion)
                        }
                        .bold()
                        Spacer(minLength: 50)
                    }
                }
                .padding()
                .frame(width: screenWidth-40)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .overlay(
                    Capsule()
                        .frame(height: 1) // Altura del borde
                        .foregroundColor(.accentColor), alignment: .bottom // Color
                )
                
                // MARK: - Ofertas
                ScrollView {
                    LazyVStack {
                        ForEach(transportOffers) { transportOffer in
                            NavigationLink(destination: DetailOffer(transportOffer: transportOffer, offer_tran_id: transportOffer.id ?? 0, interaction_id: interaction_id)) {
                                HStack {
                                    VStack {
                                        Text(transportOffer.empresa_tran)
                                            .font(.system(size: 18))
                                            .textCase(.uppercase)
                                        HStack {
                                            Image("TuLogo")
                                                .resizable()
                                                .frame(width: 60, height: 60)
                                            Text("5")
                                            Image(systemName: "star.fill")
                                                .foregroundColor(.yellow)
                                        }
                                        .font(.system(size: 25))
                                    }
                                    .frame(width: 200)
                                    Divider()
                                    VStack {
                                        Text("$ \(transportOffer.coste_flete) MXN")
                                        Divider()
                                        Text("Fecha: \(transportOffer.fecha_de_llegada)")
                                    }
                                }
                                .foregroundColor(.black)
                                .frame(width: 340, height: 100)
                                .padding(10)
                                .background(Color.white)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                            }
                        }
                    }
                    .padding()
                }
                .padding(.top, 20)
            }
            .onAppear(perform: fetchStartingValues) // fetchValues()
            .onAppear(perform: fetchOffers) // fetchValues()
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Helper Functions

    func fetchStartingValues() {
        guard let baseUrl = URL(string: "\(Stock.endPoint)/api/step-four/mine") else {
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
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Datos recibidos del servidor Monopoly: \(jsonString)") // PRINT FOR DEBUG
            }

            do {
                let decodedResponse = try JSONDecoder().decode([MyOffer].self, from: data)
            DispatchQueue.main.async {
                print("FormBodega Datos decodificados correctamente: \(decodedResponse)") // PRINT FOR DEBUG
        
                if let firstResponse = decodedResponse.first {
                    self.fecha_de_corte = firstResponse.fecha_de_corte
                    self.fecha_de_llegada = firstResponse.fecha_de_llegada
                    self.coste_flete = firstResponse.coste_flete
                    self.tipo_de_camion = firstResponse.tipo_de_camion
                }
            }
            } catch {
                print("Error al decodificar datos de la transporte: \(error)")
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
    
    func fetchOffers() {
        guard let baseUrl = URL(string: "\(Stock.endPoint)/api/step-four/get") else {
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

            if let jsonString = String(data: data, encoding: .utf8) {
                print("Datos recibidos del servidor Monopoly: \(jsonString)") // PRINT FOR DEBUG
            }

            do {
                let decodedOffer = try JSONDecoder().decode([TransportOffer].self, from: data) // Cambiado a [TransportOffer].self
                DispatchQueue.main.async {
                    print("FormBodega Datos decodificados correctamente: \(decodedOffer)") // PRINT FOR DEBUG
                    self.transportOffers = decodedOffer // Asignar correctamente a la variable @State
                }
            } catch {
                print("Error al decodificar datos de la transporte: \(error)")
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

}

struct DetailOffer: View {
    @Environment(\.dismiss) var dismiss
    let screenWidth = UIScreen.main.bounds.width
    let screenHeight = UIScreen.main.bounds.height
    
    let myEmail = ProfileView.email

    @State private var showSuccessAlert = false
    @State private var justEdited: Bool = false
    @State private var showPopup = false
    @State private var counterPrice = ""
    @State private var counterDate = ""
    
    var transportOffer: TransportOffer // Assume you have a `TransportOffer` model
    var offer_tran_id: Int
    var interaction_id: Int

    var body: some View {
       ZStack {
           VStack {
                HStack {
                    // Botón para volver a la vista anterior
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 24))
                    }
                    Spacer()
                    // Imagen de perfil o icono
                    Image(systemName: "person.circle.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 20))
                    Text(transportOffer.empresa_tran)
                        .font(.system(size: 24))
                        .textCase(.uppercase)
                    Spacer()
                }
                .padding()
                .frame(width: screenWidth, height: 60)
                .background(Color.white)

                HStack {
                    Image("TuLogo")
                       .resizable()
                       .frame(width: 60, height: 60)
                    Text("5")
                    Image(systemName: "star.fill")
                       .foregroundColor(.yellow)
                }
                .font(.system(size: 25))
                Text("$ \(transportOffer.coste_flete) MXN")
                Text("Fecha: \(transportOffer.fecha_de_llegada)")
                Button(action: {
                    showPopup = true
                }) {
                    Text("Show Popup")
                        .padding(10)
                        .background(Color.blue)
                        .foregroundStyle(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
               Spacer()
           }
           .frame(width: screenWidth-10, height: 650)
           .padding()
           .background(Color.white)
           .clipShape(RoundedRectangle(cornerRadius: 8))
//           .shadow(color: .gray, radius: 8, x: 0, y: 4) // Corrección aplicada aquí
           .blur(radius: showPopup ? 3 : 0)

           if showPopup {
               Color.black.opacity(0.4)
                   .edgesIgnoringSafeArea(.all)
                   .onTapGesture {
                       withAnimation {
                           showPopup = false
                       }
                   }
               HStack(alignment: .top) {
                   // Columna "Yo mero"
                   VStack {
                       Text("Yo mero")
                       Divider()

                       if transportOffer.accepted {
                           Image(systemName: "checkmark.circle.fill")
                               .font(.system(size: 45))
                               .foregroundStyle(Color.green)
                               .padding(.vertical, 20)
                       } else if justEdited {
                           Button(action: {
                               editTranOffer()
                               showPopup = false
                           }) {
                               Image(systemName: "paperplane.circle.fill")
                                   .font(.system(size: 45))
                                   .foregroundStyle(Color.gray)
                                   .padding(.vertical, 20)
                           }
                       } else if myEmail != transportOffer.last_mod {
                           Button(action: {
                               acceptTranDeal()
                               showPopup = false
                           }) {
                               Image(systemName: "checkmark.circle.fill")
                                   .font(.system(size: 45))
                                   .foregroundStyle(Color.gray)
                                   .padding(.vertical, 20)
                           }
                       } else {
                           Button(action: {
                               showPopup = false
                           }) {
                               Image(systemName: "paperplane.circle.fill")
                                   .font(.system(size: 45))
                                   .foregroundStyle(Color.blue)
                                   .padding(.vertical, 20)
                           }
                       }

                   }
                   .frame(maxWidth: .infinity) // Asegura el mismo ancho

                   Divider()
                   // Columna "Negociación"
                   VStack(alignment: .leading, spacing: 10) {
                       Text("Negociación")
                       Divider()
                       Text("Precio total del flete:")
                       HStack {
                           if myEmail != transportOffer.last_mod && !transportOffer.accepted {
                               TextField(transportOffer.coste_flete, text: $counterPrice)
                                   .onChange(of: counterPrice) { _ in
                                       justEdited = true
                                   }
                           } else {
                               Text(transportOffer.coste_flete)
                           }
                       }

                       Text("Fecha asegurada de llegada")
                       HStack {
                           if myEmail != transportOffer.last_mod && !transportOffer.accepted{
                               TextField(transportOffer.fecha_de_llegada, text: $counterDate)
                                   .onChange(of: counterDate) { _ in
                                       justEdited = true
                                   }
                           } else {
                               Text(transportOffer.fecha_de_llegada)
                           }
                       }
                   }
                   .frame(width: 120) // Asegura el mismo ancho
                   Divider()
                   // Columna "Interlocutor"
                   VStack {
                       Text("Interlocutor")
                       Divider()

                       if myEmail != transportOffer.last_mod {
                           Button(action: {
                               // Acción para aceptar la propuesta
                               showPopup = false
                           }) {
                               Image(systemName: "checkmark.circle.fill")
                                   .font(.system(size: 45))
                                   .foregroundStyle(Color.green)
                                   .padding(.vertical, 20)
                           }
                       } else {
                           Button(action: {
                               // Acción para aceptar la propuesta
                               showPopup = false
                           }) {
                               Image(systemName: "checkmark.circle.fill")
                                   .font(.system(size: 45))
                                   .foregroundStyle(Color.gray)
                                   .padding(.vertical, 20)
                           }
                       }
                   }
                   .frame(maxWidth: .infinity) // Asegura el mismo ancho
               }
               .padding(10)
               .frame(width: screenWidth - 40, height: 300)
               .background(Color.white)
               .clipShape(RoundedRectangle(cornerRadius: 16))
               .shadow(radius: 10)
               .transition(.opacity) // Transición suave

           }
        }
        .navigationBarBackButtonHidden(true)
   }
    
    // MARK: - Func Accept Deal
    func acceptTranDeal() {
        guard let url = URL(string: "\(Stock.endPoint)/api/step-four/accept") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Crear el diccionario con los datos formateados
        let idToAcceptDeal: [String: Any] = [
            "offer_tran_id": offer_tran_id, // MFM Verificar si "ID" es el nombre
            "interaction_id": interaction_id
        ]

        // Serializar los datos a JSON
        guard let httpBody = try? JSONSerialization.data(withJSONObject: idToAcceptDeal, options: []) else {
            print("Error al serializar los datos para aceptar monopoly")
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
                print("Error en la respuesta del servidor acceptDeal()")
                return
            }

            do {
//                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
//                    print("Respuesta del servidor: \(json)")
//                    // Aquí puedes manejar la respuesta del servidor
//                }
                self.dismiss()
//                self.start3chat() MFI Funcion para habilitar el chat tripoint
            } catch {
                print("Error al decodificar la respuesta JSON")
            }
        }.resume()
    }

    // MARK: - Func Edit Mply
    func editTranOffer() {
        guard let url = URL(string: "\(Stock.endPoint)/api/step-four/edit") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        // Crear el diccionario con los datos actualizados
        let offerData: [String: Any] = [
            "offer_tran_id": offer_tran_id,
            "coste_flete": counterPrice,
            "fecha_de_llegada": counterDate,
            "last_mod": myEmail
        ]

        // Serializar los datos a JSON
        guard let httpBody = try? JSONSerialization.data(withJSONObject: offerData, options: []) else {
            print("Error al serializar los datos para editar monopoly")
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
                print("Error en la respuesta del servidor editTranOffer()")
                return
            }

            do {
//              Aquí puedes manejar la respuesta del servidor
                print("Oferta editado exitosamente")
                // Una vez que la solicitud se complete exitosamente, llamar a
                DispatchQueue.main.async {
                    self.dismiss()
                    // Opcionalmente, restablecer el estado de justEdited si es necesario
                    self.justEdited = true
                    // Opcionalmente, puedes cerrar la vista de Monopoly si así lo deseas
                    self.showPopup = false
                }
            } catch {
                print("Error al decodificar la respuesta JSON")
            }
        }.resume()
    }
}

struct NegociacionTran_Previews: PreviewProvider {
    static var previews: some View {
        NegociacionTran(interaction_id: 3, producto_completo: "Aguacate Haas")
    }
}
